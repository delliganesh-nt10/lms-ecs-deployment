# 🗄️ Database Configuration Guide

Quick reference for configuring PostgreSQL database with AI-LMS.

---

## 📊 Database Options

| Option | Use Case | Pros | Cons | Cost |
|--------|----------|------|------|------|
| **Local PostgreSQL** | Local development | Fast, free, full control | Manual setup, not production-ready | Free |
| **Docker PostgreSQL** | Development/Testing | Easy setup, isolated, reproducible | Not production-ready, local only | Free |
| **AWS RDS** | Production | Managed, scalable, automatic backups | Paid service, AWS lock-in | ~$15-100+/month |
| **Neon** | Development/Production | Serverless, free tier, auto-scaling | Limited free tier | Free - $69/month |
| **Supabase** | Development/Production | Free tier, built-in auth, realtime | PostgreSQL extensions limited | Free - $25/month |

---

## 🚀 Quick Setup by Environment

### **Local Development**

```bash
# 1. Install PostgreSQL
sudo apt install postgresql postgresql-contrib  # Ubuntu/Debian
# or
brew install postgresql  # macOS

# 2. Create database
./scripts/setup-db.sh

# 3. Configure .env.local
NEXT_PUBLIC_DATABASE_CONNECTION_STRING=postgresql://ai_lms_user:ai_lms_password@localhost:5432/ai_lms

# 4. Run migrations
npx drizzle-kit push
```

### **Docker Development**

```bash
# 1. Start Docker containers
docker compose up -d

# 2. Run migrations
./scripts/docker-migrate.sh

# Connection string (already in docker-compose.yml)
# postgresql://ai_lms_user:ai_lms_password@postgres:5432/ai_lms
```

### **AWS RDS Production**

See **[RDS_SETUP.md](RDS_SETUP.md)** for complete guide.

```bash
# Quick steps:
# 1. Create RDS instance in AWS Console
# 2. Configure security groups
# 3. Get endpoint from AWS

# 4. Configure .env.production
NEXT_PUBLIC_DATABASE_CONNECTION_STRING=postgresql://ai_lms_admin:password@endpoint.rds.amazonaws.com:5432/ai_lms

# 5. Run migrations
npx drizzle-kit push
```

### **Neon (Serverless PostgreSQL)**

```bash
# 1. Sign up at https://neon.tech
# 2. Create new project
# 3. Copy connection string

# 4. Configure .env.local or .env.production
NEXT_PUBLIC_DATABASE_CONNECTION_STRING=postgresql://user:password@ep-xxx.region.aws.neon.tech/ai_lms?sslmode=require

# 5. Run migrations
npx drizzle-kit push
```

### **Supabase**

```bash
# 1. Sign up at https://supabase.com
# 2. Create new project
# 3. Go to Project Settings > Database
# 4. Copy connection string (use "Connection pooling" for better performance)

# 5. Configure .env.local or .env.production
NEXT_PUBLIC_DATABASE_CONNECTION_STRING=postgresql://postgres.xxx:password@aws-0-region.pooler.supabase.com:6543/postgres

# 6. Run migrations
npx drizzle-kit push
```

---

## 🔗 Connection String Format

```
postgresql://[username]:[password]@[host]:[port]/[database]?[options]
```

### **Components:**

- **username**: Database user (e.g., `ai_lms_user`, `postgres`)
- **password**: User password (URL encode if contains special characters)
- **host**: Database server hostname or IP
- **port**: PostgreSQL port (default: `5432`)
- **database**: Database name (e.g., `ai_lms`)
- **options**: Optional parameters (e.g., `sslmode=require`)

### **Examples:**

```bash
# Local
postgresql://ai_lms_user:mypass@localhost:5432/ai_lms

# Docker
postgresql://ai_lms_user:mypass@postgres:5432/ai_lms

# AWS RDS
postgresql://admin:mypass@db.abc.us-east-1.rds.amazonaws.com:5432/ai_lms

# With SSL
postgresql://user:pass@host:5432/db?sslmode=require

# With special characters in password (URL encoded)
postgresql://user:p%40ss%23word@host:5432/db
```

---

## 🔧 Configuration Files

### **Environment Files:**

| File | Purpose | When to use |
|------|---------|-------------|
| `.env.local` | Local development | When running `npm run dev` |
| `.env.production` | Production deployment | When deploying with Docker or PM2 |
| `docker-compose.yml` | Docker development | Using Docker for development |
| `docker-compose.prod.yml` | Docker production | Using Docker for production |

### **Database Files:**

| File | Purpose |
|------|---------|
| `configs/db.js` | Database connection setup |
| `configs/schema.js` | Database schema definition |
| `drizzle.config.js` | Drizzle ORM configuration |

---

## 📝 Common Tasks

### **Test Database Connection**

```bash
# Using psql
psql "postgresql://username:password@host:5432/database"

# Using Node.js
node -e "const { neon } = require('@neondatabase/serverless'); const sql = neon('CONNECTION_STRING'); sql\`SELECT version()\`.then(console.log)"

# Check from application
curl http://localhost:3000/api/health
```

### **Run Migrations**

```bash
# Push schema changes to database
npx drizzle-kit push

# Generate migration files (optional)
npx drizzle-kit generate

# View current schema
npx drizzle-kit introspect
```

### **Backup Database**

```bash
# Local/Docker PostgreSQL
pg_dump -U ai_lms_user -d ai_lms > backup.sql

# AWS RDS (using psql)
pg_dump -h endpoint.rds.amazonaws.com -U ai_lms_admin -d ai_lms > backup.sql

# Restore
psql -U ai_lms_user -d ai_lms < backup.sql
```

### **Reset Database**

```bash
# Drop and recreate all tables
npx drizzle-kit drop
npx drizzle-kit push
```

---

## 🆘 Troubleshooting

### **Connection Refused**

```bash
# Check PostgreSQL is running
sudo systemctl status postgresql  # Linux
brew services list  # macOS

# Check if port is open
telnet localhost 5432
nc -zv localhost 5432
```

### **Authentication Failed**

```bash
# Verify credentials
psql -U ai_lms_user -d ai_lms -h localhost

# Reset password (if needed)
sudo -u postgres psql -c "ALTER USER ai_lms_user WITH PASSWORD 'new_password';"
```

### **Database Does Not Exist**

```bash
# Create database
sudo -u postgres psql -c "CREATE DATABASE ai_lms OWNER ai_lms_user;"

# Or use setup script
./scripts/setup-db.sh
```

### **SSL/TLS Issues**

```bash
# Add SSL mode to connection string
?sslmode=require        # Require SSL
?sslmode=prefer         # Prefer SSL but allow non-SSL
?sslmode=disable        # Disable SSL (development only)
```

### **Timeout/Slow Queries**

```bash
# Add connection timeout
?connect_timeout=10

# Add statement timeout
?options=-c%20statement_timeout=30000
```

---

## 🔐 Security Best Practices

### **Password Security:**

- ✅ Use strong passwords (16+ characters, mixed case, numbers, symbols)
- ✅ Never commit passwords to Git
- ✅ Use environment variables for credentials
- ✅ Rotate passwords regularly
- ✅ Use AWS Secrets Manager or similar for production

### **Network Security:**

- ✅ Use SSL/TLS for remote connections
- ✅ Restrict database access by IP (security groups)
- ✅ Use VPC for AWS deployments
- ✅ Never expose database ports publicly in production

### **Access Control:**

- ✅ Use principle of least privilege
- ✅ Create separate users for application vs admin
- ✅ Enable audit logging
- ✅ Monitor failed login attempts

---

## 📚 Additional Resources

- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Drizzle ORM Docs](https://orm.drizzle.team/)
- [AWS RDS Setup Guide](RDS_SETUP.md)
- [Docker PostgreSQL Guide](DOCKER.md)
- [Production Deployment](PRODUCTION.md)

---

## 🎯 Decision Matrix

**Choose based on your needs:**

### **Use Local PostgreSQL if:**
- Developing locally
- Learning the system
- No internet connectivity required
- Full database access needed

### **Use Docker PostgreSQL if:**
- Want easy setup/teardown
- Testing different configurations
- Need isolated environments
- Developing in teams (consistency)

### **Use AWS RDS if:**
- Deploying to production
- Need automated backups
- Want managed service
- Scalability is important
- Have budget for managed services

### **Use Neon/Supabase if:**
- Want free tier for small projects
- Need serverless autoscaling
- Want additional features (auth, storage)
- Prefer PostgreSQL-as-a-Service

---

**Need help?** Check the [main README](../README.md) or open an [issue](https://github.com/ramesh-nt04/lms/issues).
