# 🚀 Production Deployment Guide

## 📋 Prerequisites

Before deploying to production:

- ✅ Docker and Docker Compose installed
- ✅ Domain name configured (for HTTPS)
- ✅ SSL certificates (Let's Encrypt recommended)
- ✅ Server with at least 2GB RAM
- ✅ Database choice:
  - **Option 1:** AWS RDS PostgreSQL (recommended for production)
  - **Option 2:** Docker PostgreSQL (for self-hosted)
  - **Option 3:** Other managed PostgreSQL (Neon, Supabase, etc.)
- ✅ PostgreSQL backup strategy

---

## 🔐 Security Checklist

### **Before Deployment:**

- [ ] Change all default passwords
- [ ] Generate strong JWT_SECRET
- [ ] Configure firewall rules
- [ ] Set up SSL/TLS certificates
- [ ] Enable security headers
- [ ] Configure rate limiting
- [ ] Set up monitoring
- [ ] Plan backup strategy

---

## 🛠️ Step-by-Step Deployment

### **1. Prepare Environment**

```bash
# Clone repository
git clone https://github.com/your-username/ai-lms.git
cd ai-lms

# Create production environment file
cp .env.production.example .env.production

# Edit with your actual values
nano .env.production
```

### **2. Configure Environment Variables**

Edit `.env.production`:

```env
NODE_ENV=production

# Generate strong JWT secret (REQUIRED)
JWT_SECRET=$(openssl rand -base64 32)

# Database - Choose one option:

# Option 1: AWS RDS (Recommended for Production)
NEXT_PUBLIC_DATABASE_CONNECTION_STRING=postgresql://ai_lms_admin:STRONG_PASSWORD@ai-lms-db.xxxxx.region.rds.amazonaws.com:5432/ai_lms

# Option 2: Docker PostgreSQL (for containerized deployment)
# NEXT_PUBLIC_DATABASE_CONNECTION_STRING=postgresql://ai_lms_user:STRONG_PASSWORD@postgres:5432/ai_lms

# Your domain
NEXT_PUBLIC_APP_URL=https://yourdomain.com
```

**📖 For AWS RDS setup, see:** [docs/RDS_SETUP.md](RDS_SETUP.md)

### **3. Deploy Application**

#### **Option A: Deploy with Docker (Local PostgreSQL)**

```bash
# Run deployment script
./scripts/deploy-production.sh

# Choose option 1 (Initial deployment)
```

#### **Option B: Deploy with AWS RDS**

```bash
# 1. Ensure RDS instance is created and accessible
# See docs/RDS_SETUP.md for RDS configuration

# 2. Update .env.production with RDS endpoint
# NEXT_PUBLIC_DATABASE_CONNECTION_STRING=postgresql://user:pass@rds-endpoint:5432/ai_lms

# 3. Build and deploy (without local PostgreSQL)
docker compose -f docker-compose.prod.yml up -d app nginx

# 4. Run migrations to RDS
docker compose -f docker-compose.prod.yml exec app npx drizzle-kit push
```

#### **Option C: Deploy on EC2 with RDS**

```bash
# 1. SSH to your EC2 instance
ssh -i your-key.pem ubuntu@your-ec2-ip

# 2. Clone repository
git clone https://github.com/ramesh-nt04/lms.git
cd ai-lms

# 3. Configure environment with RDS endpoint
nano .env.production

# 4. Build and start application only (no database container)
docker compose -f docker-compose.prod.yml up -d app

# 5. Run migrations to RDS
docker compose -f docker-compose.prod.yml exec app npx drizzle-kit push
```

### **4. Configure SSL (Optional but Recommended)**

#### **Using Let's Encrypt:**

```bash
# Install certbot
sudo apt install certbot

# Get SSL certificate
sudo certbot certonly --standalone -d yourdomain.com -d www.yourdomain.com

# Copy certificates to nginx folder
sudo cp /etc/letsencrypt/live/yourdomain.com/fullchain.pem nginx/ssl/
sudo cp /etc/letsencrypt/live/yourdomain.com/privkey.pem nginx/ssl/

# Start with nginx
docker compose -f docker-compose.prod.yml --profile with-nginx up -d
```

### **5. Verify Deployment**

```bash
# Check health
curl http://localhost:3000/api/health

# View logs
docker compose -f docker-compose.prod.yml logs -f

# Check containers
docker compose -f docker-compose.prod.yml ps
```

---

## 🔄 Updates and Maintenance

### **Update Application:**

```bash
./scripts/deploy-production.sh
# Choose option 2 (Update deployment)
```

### **Backup Database:**

```bash
./scripts/deploy-production.sh
# Choose option 5 (Backup database)
```

### **Restore Database:**

```bash
./scripts/deploy-production.sh
# Choose option 6 (Restore database)
```

---

## 📊 Monitoring

### **Health Check:**

```bash
curl https://yourdomain.com/api/health
```

### **View Logs:**

```bash
# All logs
docker compose -f docker-compose.prod.yml logs -f

# App only
docker compose -f docker-compose.prod.yml logs -f app

# Database only
docker compose -f docker-compose.prod.yml logs -f postgres
```

### **Resource Usage:**

```bash
docker stats
```

---

## 🔒 Security Best Practices

### **1. Firewall Configuration**

```bash
# Allow SSH
sudo ufw allow 22/tcp

# Allow HTTP/HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Enable firewall
sudo ufw enable
```

### **2. Regular Updates**

```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Update Docker images
docker compose -f docker-compose.prod.yml pull
docker compose -f docker-compose.prod.yml up -d
```

### **3. Automated Backups**

Create a cron job for daily backups:

```bash
# Edit crontab
crontab -e

# Add daily backup at 2 AM
0 2 * * * cd /path/to/ai-lms && ./scripts/deploy-production.sh <<< "5"
```

---

## 🌐 Domain Configuration

### **DNS Settings:**

```
Type    Name    Value           TTL
A       @       YOUR_SERVER_IP  3600
A       www     YOUR_SERVER_IP  3600
```

### **Nginx Configuration:**

Update `nginx/nginx.conf`:
- Replace `yourdomain.com` with your actual domain
- Configure SSL certificate paths

---

## 📈 Performance Optimization

### **1. Enable Caching:**

Already configured in `nginx/nginx.conf`:
- Static files cached for 1 hour
- API responses with appropriate cache headers

### **2. Database Optimization:**

```sql
-- Create indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_study_material_created_by ON "studyMaterial"("createdBy");
```

### **3. Resource Limits:**

Configured in `docker-compose.prod.yml`:
- App: 2 CPU, 2GB RAM
- Database: 1 CPU, 1GB RAM

---

## 🆘 Troubleshooting

### **Application Won't Start:**

```bash
# Check logs
docker compose -f docker-compose.prod.yml logs app

# Check environment variables
docker compose -f docker-compose.prod.yml exec app env

# Restart
docker compose -f docker-compose.prod.yml restart app
```

### **Database Connection Errors:**

```bash
# Check database status
docker compose -f docker-compose.prod.yml exec postgres pg_isready

# Check connection string
docker compose -f docker-compose.prod.yml exec app env | grep DATABASE
```

### **SSL Certificate Issues:**

```bash
# Renew certificates
sudo certbot renew

# Copy new certificates
sudo cp /etc/letsencrypt/live/yourdomain.com/* nginx/ssl/

# Restart nginx
docker compose -f docker-compose.prod.yml restart nginx
```

---

## 📝 Maintenance Schedule

### **Daily:**
- Monitor application health
- Check error logs
- Verify backups

### **Weekly:**
- Review resource usage
- Check for security updates
- Test backup restoration

### **Monthly:**
- Update dependencies
- Review and rotate logs
- Performance audit

---

## 🔐 Environment Variables Reference

| Variable | Description | Required | Example |
|----------|-------------|----------|---------|
| `NODE_ENV` | Environment | Yes | `production` |
| `JWT_SECRET` | JWT signing key | Yes | `generated-secret` |
| `NEXT_PUBLIC_DATABASE_CONNECTION_STRING` | Database URL (Local/RDS/Cloud) | Yes | See examples below |
| `NEXT_PUBLIC_APP_URL` | Application URL | Yes | `https://yourdomain.com` |

### **Database Connection Examples:**

```env
# AWS RDS
NEXT_PUBLIC_DATABASE_CONNECTION_STRING=postgresql://ai_lms_admin:pass@ai-lms.abc.us-east-1.rds.amazonaws.com:5432/ai_lms

# Docker PostgreSQL
NEXT_PUBLIC_DATABASE_CONNECTION_STRING=postgresql://ai_lms_user:pass@postgres:5432/ai_lms

# Neon/Supabase/Others
NEXT_PUBLIC_DATABASE_CONNECTION_STRING=postgresql://user:pass@host:5432/db?sslmode=require
```

---

## 📞 Support

For issues or questions:
1. Check logs: `docker compose -f docker-compose.prod.yml logs`
2. Review health endpoint: `/api/health`
3. Check documentation in `docs/` folder

---

**Last Updated:** 2025-12-09
