# 🚀 AI-LMS Database Setup - Quick Start

Choose your preferred database setup method below.

---

## Option 1: Local PostgreSQL (Development)

**Best for:** Local development, learning, offline work

```bash
# 1. Install PostgreSQL
sudo apt install postgresql postgresql-contrib  # Ubuntu/Debian
brew install postgresql  # macOS

# 2. Setup database
./scripts/setup-db.sh

# 3. Create .env.local
cat > .env.local << 'EOF'
NEXT_PUBLIC_DATABASE_CONNECTION_STRING=postgresql://ai_lms_user:ai_lms_password@localhost:5432/ai_lms
JWT_SECRET=$(openssl rand -base64 32)
EOF

# 4. Run migrations
npx drizzle-kit push

# 5. Start app
npm run dev
```

---

## Option 2: Docker (Development/Testing)

**Best for:** Easy setup, team consistency, isolated environment

```bash
# 1. Start containers
docker compose up -d

# 2. Run migrations
./scripts/docker-migrate.sh

# 3. Access app
# http://localhost:3000
```

---

## Option 3: AWS RDS (Production)

**Best for:** Production deployment, scalability, managed backups

### Quick Steps:

```bash
# 1. Create RDS Instance (AWS Console)
# - Engine: PostgreSQL 16
# - Instance: db.t3.micro (free tier) or db.t3.small (production)
# - DB name: ai_lms
# - Username: ai_lms_admin
# - Password: [strong password]
# - Public access: Yes (if accessing externally)

# 2. Configure Security Group
# Add inbound rule: PostgreSQL (5432) from your IP

# 3. Get RDS Endpoint
# Example: ai-lms-db.abc123.us-east-1.rds.amazonaws.com

# 4. Create .env.production
cat > .env.production << 'EOF'
NEXT_PUBLIC_DATABASE_CONNECTION_STRING=postgresql://ai_lms_admin:YOUR_PASSWORD@YOUR_ENDPOINT.rds.amazonaws.com:5432/ai_lms
JWT_SECRET=YOUR_GENERATED_SECRET
NODE_ENV=production
EOF

# 5. Test connection
psql "postgresql://ai_lms_admin:YOUR_PASSWORD@YOUR_ENDPOINT.rds.amazonaws.com:5432/ai_lms"

# 6. Run migrations
npx drizzle-kit push

# 7. Deploy application
npm run build
npm start
```

**📖 Full Guide:** See [docs/RDS_SETUP.md](docs/RDS_SETUP.md)

---

## Option 4: Neon (Serverless PostgreSQL)

**Best for:** Serverless apps, free tier, auto-scaling

```bash
# 1. Sign up: https://neon.tech
# 2. Create project → Copy connection string
# 3. Create .env.local

cat > .env.local << 'EOF'
NEXT_PUBLIC_DATABASE_CONNECTION_STRING=postgresql://user:password@ep-xxx.region.aws.neon.tech/ai_lms?sslmode=require
JWT_SECRET=$(openssl rand -base64 32)
EOF

# 4. Run migrations
npx drizzle-kit push

# 5. Start app
npm run dev
```

---

## Option 5: Supabase

**Best for:** Full-featured PostgreSQL with built-in auth, storage

```bash
# 1. Sign up: https://supabase.com
# 2. Create project → Settings → Database
# 3. Copy connection string (use Connection Pooling)
# 4. Create .env.local

cat > .env.local << 'EOF'
NEXT_PUBLIC_DATABASE_CONNECTION_STRING=postgresql://postgres.xxx:password@aws-0-region.pooler.supabase.com:6543/postgres
JWT_SECRET=$(openssl rand -base64 32)
EOF

# 5. Run migrations
npx drizzle-kit push

# 6. Start app
npm run dev
```

---

## 🔗 Connection String Format

```
postgresql://[username]:[password]@[host]:[port]/[database]?[options]
```

### Examples:

```bash
# Local
postgresql://ai_lms_user:ai_lms_password@localhost:5432/ai_lms

# Docker
postgresql://ai_lms_user:ai_lms_password@postgres:5432/ai_lms

# AWS RDS
postgresql://ai_lms_admin:mypass@endpoint.us-east-1.rds.amazonaws.com:5432/ai_lms

# Neon (with SSL)
postgresql://user:pass@ep-xxx.region.aws.neon.tech/ai_lms?sslmode=require

# Supabase
postgresql://postgres:pass@db.supabase.co:5432/postgres
```

---

## ✅ Verify Setup

```bash
# Test database connection
psql "YOUR_CONNECTION_STRING"

# Run migrations
npx drizzle-kit push

# Check health
curl http://localhost:3000/api/health

# View tables
psql "YOUR_CONNECTION_STRING" -c "\dt"
```

---

## 🆘 Troubleshooting

### Connection Refused
```bash
# Check PostgreSQL is running
sudo systemctl status postgresql
brew services list

# Check port
telnet localhost 5432
```

### Authentication Failed
```bash
# Verify credentials
psql -U ai_lms_user -d ai_lms -h localhost

# Reset password
sudo -u postgres psql -c "ALTER USER ai_lms_user WITH PASSWORD 'new_pass';"
```

### SSL Required
```bash
# Add to connection string
?sslmode=require
```

---

## 📚 Full Documentation

- **Database Options:** [docs/DATABASE_CONFIG.md](docs/DATABASE_CONFIG.md)
- **AWS RDS Setup:** [docs/RDS_SETUP.md](docs/RDS_SETUP.md)
- **Production Deploy:** [docs/PRODUCTION.md](docs/PRODUCTION.md)
- **Main README:** [README.md](README.md)

---

## 🎯 Quick Decision Guide

**Choose:**
- **Local PostgreSQL** → Learning, offline development
- **Docker** → Easy setup, team projects
- **AWS RDS** → Production, enterprise, scalability
- **Neon** → Serverless, free tier, hobby projects
- **Supabase** → Need auth/storage, full-featured platform

---

**Need help?** Open an [issue](https://github.com/ramesh-nt04/lms/issues) or check the docs!
