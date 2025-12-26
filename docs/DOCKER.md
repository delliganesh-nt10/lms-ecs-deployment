# 🐳 Docker Installation Guide for AI-LMS

## 📋 Prerequisites

Before you begin, make sure you have:
- ✅ Docker installed ([Get Docker](https://docs.docker.com/get-docker/))
- ✅ Docker Compose installed (usually comes with Docker Desktop)

## 🚀 Quick Start

### **Option 1: Using the Setup Script (Recommended)**

```bash
# Make the script executable (if not already)
chmod +x docker-setup.sh

# Run the setup script
./docker-setup.sh
```

The script will guide you through:
1. Building the application
2. Starting/stopping containers
3. Viewing logs
4. Rebuilding
5. Cleanup

### **Option 2: Manual Commands**

#### **First Time Setup:**

```bash
# 1. Build and start all containers
docker compose up -d --build

# 2. Wait for containers to start (about 30 seconds)
# Then run database migrations
./docker-migrate.sh

# Or manually:
docker compose exec app npx drizzle-kit push
```

#### **Access the Application:**
- **Web Application:** http://localhost:3000
- **Database:** localhost:5432

---

## 📦 What Gets Installed

The Docker setup includes:

1. **PostgreSQL Database (Container)**
   - Version: PostgreSQL 16
   - Port: 5432
   - Database: `ai_lms`
   - User: `ai_lms_user`
   - Password: `ai_lms_password`

2. **Next.js Application (Container)**
   - Port: 3000
   - Production-optimized build
   - Automatic restart on failure

3. **Docker Network**
   - Isolated network for app and database communication

4. **Persistent Storage**
   - Database data stored in Docker volume

---

## 🔧 Common Commands

### **Start the Application:**
```bash
docker compose up -d
```

### **Stop the Application:**
```bash
docker compose down
```

### **View Logs:**
```bash
# All services
docker compose logs -f

# Just the app
docker compose logs -f app

# Just the database
docker compose logs -f postgres
```

### **Rebuild After Code Changes:**
```bash
docker compose up -d --build
```

### **Run Database Migrations:**
```bash
./docker-migrate.sh
```

### **Access Database:**
```bash
# Using docker exec
docker compose exec postgres psql -U ai_lms_user -d ai_lms

# Or from your host (if psql is installed)
psql -h localhost -U ai_lms_user -d ai_lms
# Password: ai_lms_password
```

### **Check Container Status:**
```bash
docker compose ps
```

### **Restart a Service:**
```bash
# Restart app
docker compose restart app

# Restart database
docker compose restart postgres
```

---

## 🗄️ Database Management

### **View Tables:**
```bash
docker compose exec postgres psql -U ai_lms_user -d ai_lms -c "\dt"
```

### **View Users:**
```bash
docker compose exec postgres psql -U ai_lms_user -d ai_lms -c "SELECT id, name, email FROM users;"
```

### **Backup Database:**
```bash
docker compose exec postgres pg_dump -U ai_lms_user ai_lms > backup.sql
```

### **Restore Database:**
```bash
cat backup.sql | docker compose exec -T postgres psql -U ai_lms_user -d ai_lms
```

---

## 🔄 Update and Redeploy

When you make code changes:

```bash
# 1. Stop the current containers
docker compose down

# 2. Rebuild and start
docker compose up -d --build

# 3. If schema changed, run migrations
./docker-migrate.sh
```

---

## 🧹 Cleanup

### **Stop and Remove Containers:**
```bash
docker compose down
```

### **Remove Containers and Volumes (⚠️ Deletes all data):**
```bash
docker compose down -v
```

### **Remove Images:**
```bash
docker rmi ai-lms-app
docker rmi postgres:16
```

### **Complete Cleanup:**
```bash
./docker-setup.sh
# Choose option 6
```

---

## 🌐 Production Deployment

### **Environment Variables**

For production, update `docker-compose.yml`:

```yaml
environment:
  - NODE_ENV=production
  - NEXT_PUBLIC_DATABASE_CONNECTION_STRING=postgresql://user:pass@postgres:5432/dbname
  - JWT_SECRET=your-super-secret-production-key-here  # ⚠️ CHANGE THIS!
```

### **Security Recommendations:**

1. **Change Default Passwords:**
   - Update PostgreSQL password in `docker-compose.yml`
   - Update JWT_SECRET

2. **Use Environment Files:**
   ```bash
   # Create .env.production
   echo "JWT_SECRET=your-secret-here" > .env.production
   
   # Update docker-compose.yml to use it
   env_file:
     - .env.production
   ```

3. **Enable SSL:**
   - Use a reverse proxy (nginx, traefik)
   - Add SSL certificates

4. **Limit Ports:**
   - Don't expose database port (5432) publicly
   - Only expose app port (3000) through reverse proxy

---

## 🐛 Troubleshooting

### **Containers Won't Start:**
```bash
# Check logs
docker compose logs

# Check if ports are already in use
lsof -i :3000
lsof -i :5432

# Kill processes using the ports
npx kill-port 3000 5432
```

### **Database Connection Errors:**
```bash
# Check if database is ready
docker compose exec postgres pg_isready -U ai_lms_user

# Restart database
docker compose restart postgres
```

### **App Not Accessible:**
```bash
# Check if container is running
docker compose ps

# Check app logs
docker compose logs app

# Restart app
docker compose restart app
```

### **Out of Disk Space:**
```bash
# Clean up unused Docker resources
docker system prune -a

# Remove unused volumes
docker volume prune
```

### **Permission Errors:**
```bash
# Fix ownership (Linux)
sudo chown -R $USER:$USER .
```

---

## 📊 Monitoring

### **Check Resource Usage:**
```bash
docker stats
```

### **Check Container Health:**
```bash
docker compose ps
```

### **View Real-time Logs:**
```bash
docker compose logs -f --tail=100
```

---

## 🔐 Security Checklist

Before deploying to production:

- [ ] Change JWT_SECRET
- [ ] Change database password
- [ ] Use environment variables for secrets
- [ ] Enable HTTPS/SSL
- [ ] Set up firewall rules
- [ ] Regular backups
- [ ] Update Docker images regularly
- [ ] Limit container resources
- [ ] Use non-root user in containers
- [ ] Enable Docker security scanning

---

## 📝 Files Created

- `Dockerfile` - Multi-stage build for Next.js
- `docker-compose.yml` - Full stack orchestration
- `.dockerignore` - Exclude unnecessary files
- `docker-setup.sh` - Interactive setup script
- `docker-migrate.sh` - Database migration script
- `DOCKER.md` - This documentation

---

## 🆘 Getting Help

If you encounter issues:

1. Check logs: `docker compose logs -f`
2. Verify containers are running: `docker compose ps`
3. Check Docker version: `docker --version`
4. Restart containers: `docker compose restart`

---

## 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Next.js Docker Documentation](https://nextjs.org/docs/deployment#docker-image)
- [PostgreSQL Docker Hub](https://hub.docker.com/_/postgres)

---

**🎉 Your AI-LMS is now ready to run in Docker!**

**Quick Start:** `./docker-setup.sh` → Choose option 1 → Access http://localhost:3000
