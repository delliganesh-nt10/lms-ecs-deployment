# ✅ Production Deployment Checklist

## Pre-Deployment

### **Security**
- [ ] Changed default database password
- [ ] Generated strong JWT_SECRET (use: `openssl rand -base64 32`)
- [ ] Removed all test/development credentials
- [ ] Configured firewall rules (ports 80, 443, 22 only)
- [ ] SSL certificates obtained and configured
- [ ] Security headers enabled in nginx
- [ ] Rate limiting configured

### **Environment**
- [ ] Created `.env.production` from `.env.production.example`
- [ ] All environment variables set correctly
- [ ] Database option chosen:
  - [ ] **AWS RDS** - RDS instance created and accessible (see [RDS_SETUP.md](RDS_SETUP.md))
  - [ ] **Docker PostgreSQL** - Using bundled database container
  - [ ] **Other Cloud** - Neon/Supabase/managed PostgreSQL configured
- [ ] Database connection string configured correctly
- [ ] Database connection tested successfully
- [ ] Application URL set to production domain
- [ ] Verified no `.env.local` in production

### **Infrastructure**
- [ ] Server meets minimum requirements (2GB RAM, 2 CPU)
- [ ] Docker and Docker Compose installed
- [ ] Domain DNS configured correctly
- [ ] Backup storage configured
- [ ] Monitoring tools set up

### **Application**
- [ ] Latest code pulled from repository
- [ ] Dependencies installed (`npm install`)
- [ ] Database migrations tested
- [ ] Health check endpoint working
- [ ] Build process tested locally

---

## Deployment

### **Initial Setup**
- [ ] Run `./scripts/deploy-production.sh`
- [ ] Choose option 1 (Initial deployment)
- [ ] Wait for containers to start
- [ ] Verify database migrations completed
- [ ] Check application health: `curl http://localhost:3000/api/health`

### **SSL Configuration (if using nginx)**
- [ ] SSL certificates copied to `nginx/ssl/`
- [ ] nginx.conf updated with correct domain
- [ ] Start with nginx profile: `docker compose -f docker-compose.prod.yml --profile with-nginx up -d`
- [ ] Verify HTTPS working

### **Verification**
- [ ] Application accessible at domain
- [ ] Can register new user
- [ ] Can login successfully
- [ ] Dashboard loads correctly
- [ ] Database connection working
- [ ] No errors in logs

---

## Post-Deployment

### **Monitoring**
- [ ] Set up log monitoring
- [ ] Configure uptime monitoring
- [ ] Set up error alerting
- [ ] Monitor resource usage
- [ ] Test health check endpoint

### **Backups**
- [ ] Manual backup created
- [ ] Automated backup cron job configured
- [ ] Backup restoration tested
- [ ] Backup retention policy set

### **Documentation**
- [ ] Production credentials documented (securely)
- [ ] Deployment process documented
- [ ] Rollback procedure tested
- [ ] Team notified of deployment

### **Performance**
- [ ] Response times acceptable
- [ ] Database queries optimized
- [ ] Caching working correctly
- [ ] Static files served efficiently

---

## Security Hardening

### **Server Level**
- [ ] SSH key-based authentication only
- [ ] Fail2ban installed and configured
- [ ] Automatic security updates enabled
- [ ] Non-root user for application
- [ ] Unnecessary services disabled

### **Application Level**
- [ ] HTTPS enforced (HTTP redirects to HTTPS)
- [ ] Security headers configured
- [ ] Rate limiting active
- [ ] SQL injection protection (ORM)
- [ ] XSS protection enabled
- [ ] CSRF protection enabled

### **Database Level**
- [ ] Strong database password set
- [ ] Database security configured:
  - [ ] **If using RDS:** Security groups properly configured
  - [ ] **If using Docker:** Database not exposed publicly
  - [ ] **If using Cloud:** SSL/TLS enabled
- [ ] Regular backups scheduled
- [ ] Connection pooling configured
- [ ] Query logging enabled (for debugging)
- [ ] Database performance monitoring enabled

---

## Maintenance Plan

### **Daily**
- [ ] Check application health
- [ ] Review error logs
- [ ] Verify backups completed
- [ ] Monitor resource usage

### **Weekly**
- [ ] Review security logs
- [ ] Check for updates
- [ ] Test backup restoration
- [ ] Performance review

### **Monthly**
- [ ] Update dependencies
- [ ] Security audit
- [ ] Capacity planning
- [ ] Documentation review

---

## Rollback Plan

### **If Deployment Fails:**
1. [ ] Stop new deployment
2. [ ] Restore from latest backup
3. [ ] Restart previous version
4. [ ] Verify application working
5. [ ] Investigate failure
6. [ ] Document issues

### **Rollback Command:**
```bash
./scripts/deploy-production.sh
# Choose option 3 (Rollback)
```

---

## Emergency Contacts

- **System Admin:** [Name/Contact]
- **Database Admin:** [Name/Contact]
- **DevOps:** [Name/Contact]
- **On-Call:** [Contact]

---

## Quick Commands

```bash
# Health check
curl https://yourdomain.com/api/health

# View logs
docker compose -f docker-compose.prod.yml logs -f

# Restart application
docker compose -f docker-compose.prod.yml restart app

# Backup database
./scripts/deploy-production.sh  # Option 5

# Update deployment
./scripts/deploy-production.sh  # Option 2
```

---

**Deployment Date:** _________________

**Deployed By:** _________________

**Sign-off:** _________________
