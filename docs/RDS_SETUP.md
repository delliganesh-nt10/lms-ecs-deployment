# 🗄️ AWS RDS PostgreSQL Setup Guide

Complete guide for setting up and deploying AI-LMS with AWS RDS PostgreSQL database.

---

## 📋 Prerequisites

- ✅ AWS Account with RDS access
- ✅ AWS CLI configured (optional)
- ✅ Basic understanding of VPC and Security Groups
- ✅ SSH access to your deployment server (if deploying on EC2)

---

## 🚀 Step-by-Step RDS Setup

### **1. Create RDS PostgreSQL Instance**

#### **Using AWS Console:**

1. **Navigate to RDS**
   - Login to AWS Console
   - Go to Services → Database → RDS
   - Click "Create database"

2. **Database Creation Method**
   - Choose: **Standard create**

3. **Engine Options**
   - Engine type: **PostgreSQL**
   - Version: **PostgreSQL 16.x** (or latest)

4. **Templates**
   - **Free tier** (for development/testing)
   - **Production** (for production workloads)

5. **Settings**
   - DB instance identifier: `ai-lms-db`
   - Master username: `ai_lms_admin`
   - Master password: [Create a strong password - save it securely!]

6. **DB Instance Size**
   - **Free Tier:** db.t3.micro (1 vCPU, 1 GB RAM)
   - **Production:** db.t3.small or higher

7. **Storage**
   - Storage type: General Purpose SSD (gp3)
   - Allocated storage: 20 GB (minimum)
   - Enable storage autoscaling: Yes
   - Maximum storage threshold: 100 GB

8. **Connectivity**
   - **Virtual Private Cloud (VPC):** Select your VPC
   - **Subnet group:** Default or custom
   - **Public access:** 
     - **Yes** (if accessing from local machine or outside AWS)
     - **No** (if only EC2 in same VPC needs access)
   - **VPC Security Group:** Create new or select existing
   - **Availability Zone:** No preference (for Multi-AZ, choose specific zones)

9. **Database Authentication**
   - Choose: **Password authentication**

10. **Additional Configuration**
    - Initial database name: `ai_lms`
    - DB parameter group: default.postgres16
    - Backup retention: 7 days (production) or 1 day (development)
    - Enable encryption: Yes (recommended for production)
    - Enable automatic backups: Yes

11. **Click "Create database"**
    - Wait 5-10 minutes for instance to be available

#### **Using AWS CLI:**

```bash
# Create RDS PostgreSQL instance
aws rds create-db-instance \
  --db-instance-identifier ai-lms-db \
  --db-instance-class db.t3.micro \
  --engine postgres \
  --engine-version 16.1 \
  --master-username ai_lms_admin \
  --master-user-password 'YourStrongPassword123!' \
  --allocated-storage 20 \
  --db-name ai_lms \
  --backup-retention-period 7 \
  --publicly-accessible \
  --storage-type gp3 \
  --storage-encrypted

# Wait for instance to be available
aws rds wait db-instance-available --db-instance-identifier ai-lms-db
```

---

### **2. Configure Security Group**

#### **Using AWS Console:**

1. **Go to RDS Dashboard** → Select your instance
2. **Click on VPC security group** (under Connectivity & security)
3. **Edit inbound rules:**

   | Type       | Protocol | Port | Source         | Description           |
   |------------|----------|------|----------------|-----------------------|
   | PostgreSQL | TCP      | 5432 | My IP          | Your local machine    |
   | PostgreSQL | TCP      | 5432 | EC2 SG ID      | Your EC2 instances    |

4. **For Development (Temporary):**
   - Source: `0.0.0.0/0` (Allow from anywhere)
   - ⚠️ **Warning:** Not recommended for production!

5. **For Production:**
   - Source: Your EC2 security group ID or specific IP ranges
   - Example: `sg-0123456789abcdef0`

#### **Using AWS CLI:**

```bash
# Get security group ID
SECURITY_GROUP_ID=$(aws rds describe-db-instances \
  --db-instance-identifier ai-lms-db \
  --query 'DBInstances[0].VpcSecurityGroups[0].VpcSecurityGroupId' \
  --output text)

# Add inbound rule for your IP
MY_IP=$(curl -s ifconfig.me)
aws ec2 authorize-security-group-ingress \
  --group-id $SECURITY_GROUP_ID \
  --protocol tcp \
  --port 5432 \
  --cidr $MY_IP/32
```

---

### **3. Get RDS Endpoint**

#### **Using AWS Console:**

1. Go to RDS Dashboard → Databases
2. Click on `ai-lms-db`
3. Copy **Endpoint** from "Connectivity & security" section
   - Example: `ai-lms-db.abc123xyz.us-east-1.rds.amazonaws.com`

#### **Using AWS CLI:**

```bash
aws rds describe-db-instances \
  --db-instance-identifier ai-lms-db \
  --query 'DBInstances[0].Endpoint.Address' \
  --output text
```

---

### **4. Test RDS Connection**

```bash
# Install PostgreSQL client (if not installed)
# Ubuntu/Debian:
sudo apt update && sudo apt install postgresql-client -y

# macOS:
brew install libpq
brew link --force libpq

# Test connection
psql "postgresql://ai_lms_admin:YourPassword@your-endpoint.rds.amazonaws.com:5432/ai_lms"

# If successful, you'll see:
# ai_lms=>
```

---

### **5. Configure Application**

#### **Create Environment File**

Create `.env.local` (development) or `.env.production` (production):

```env
# AWS RDS PostgreSQL Connection
NEXT_PUBLIC_DATABASE_CONNECTION_STRING=postgresql://ai_lms_admin:YourPassword@your-endpoint.us-east-1.rds.amazonaws.com:5432/ai_lms

# JWT Secret (generate with: openssl rand -base64 32)
JWT_SECRET=your-generated-jwt-secret-key

# Optional: AI Features
NEXT_PUBLIC_GEMINI_API_KEY=your_gemini_api_key

# Application URL
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

#### **Update Connection String Format**

```
postgresql://[USERNAME]:[PASSWORD]@[ENDPOINT]:[PORT]/[DATABASE]

Example:
postgresql://ai_lms_admin:MyPass123@ai-lms-db.abc.us-east-1.rds.amazonaws.com:5432/ai_lms
```

---

### **6. Run Database Migrations**

```bash
# Install dependencies
npm install

# Push schema to RDS
npx drizzle-kit push

# Verify tables were created
psql "postgresql://ai_lms_admin:YourPassword@your-endpoint.rds.amazonaws.com:5432/ai_lms" -c "\dt"

# Expected output:
# users
# studyMaterial
# chapterNotes
# studyTypeContent
```

---

### **7. Start Application**

```bash
# Development
npm run dev

# Production build
npm run build
npm start
```

---

## 🔒 Security Best Practices

### **1. Use Secrets Manager**

Store database credentials in AWS Secrets Manager:

```bash
# Create secret
aws secretsmanager create-secret \
  --name ai-lms/db-credentials \
  --secret-string '{"username":"ai_lms_admin","password":"YourPassword"}'

# Retrieve secret in application
# Use AWS SDK to fetch credentials dynamically
```

### **2. Use IAM Authentication**

Enable IAM database authentication for passwordless access:

```bash
# Enable IAM authentication on RDS
aws rds modify-db-instance \
  --db-instance-identifier ai-lms-db \
  --enable-iam-database-authentication \
  --apply-immediately
```

### **3. SSL/TLS Encryption**

Use SSL for database connections:

```env
# Connection string with SSL
NEXT_PUBLIC_DATABASE_CONNECTION_STRING=postgresql://user:pass@endpoint:5432/ai_lms?sslmode=require
```

### **4. Restrict Security Group**

- Only allow specific IP ranges
- Use VPC peering for EC2-to-RDS communication
- Never use `0.0.0.0/0` in production

### **5. Enable Encryption**

- ✅ Enable encryption at rest
- ✅ Enable automated backups
- ✅ Enable deletion protection
- ✅ Use parameter groups for security settings

---

## 📊 Monitoring and Maintenance

### **1. CloudWatch Monitoring**

Enable enhanced monitoring:

```bash
aws rds modify-db-instance \
  --db-instance-identifier ai-lms-db \
  --monitoring-interval 60 \
  --monitoring-role-arn arn:aws:iam::account-id:role/rds-monitoring-role
```

### **2. Performance Insights**

Enable Performance Insights for query analysis:

```bash
aws rds modify-db-instance \
  --db-instance-identifier ai-lms-db \
  --enable-performance-insights \
  --performance-insights-retention-period 7
```

### **3. Automated Backups**

Backups are automatic, but you can create manual snapshots:

```bash
# Create manual snapshot
aws rds create-db-snapshot \
  --db-instance-identifier ai-lms-db \
  --db-snapshot-identifier ai-lms-backup-$(date +%Y%m%d)
```

---

## 🔄 Database Migrations

### **Manual Migration**

```bash
# Export from local database
pg_dump -U ai_lms_user -d ai_lms > backup.sql

# Import to RDS
psql "postgresql://ai_lms_admin:pass@endpoint:5432/ai_lms" < backup.sql
```

### **Using Drizzle ORM**

```bash
# Generate migration
npx drizzle-kit generate

# Apply migration
npx drizzle-kit push
```

---

## 💰 Cost Optimization

### **Development:**
- Use **db.t3.micro** (free tier eligible)
- Enable storage autoscaling
- Set backup retention to 1 day
- Stop instance when not in use

### **Production:**
- Use Reserved Instances for 1-year savings
- Enable Multi-AZ only if needed
- Monitor unused connections
- Use Aurora Serverless for variable workloads

### **Stop/Start RDS Instance:**

```bash
# Stop instance (saves costs)
aws rds stop-db-instance --db-instance-identifier ai-lms-db

# Start instance
aws rds start-db-instance --db-instance-identifier ai-lms-db
```

---

## 🆘 Troubleshooting

### **Cannot Connect to RDS**

**Check:**
1. Security group allows your IP on port 5432
2. RDS instance is "Available"
3. Public accessibility is enabled
4. Endpoint and credentials are correct

```bash
# Test network connectivity
telnet your-endpoint.rds.amazonaws.com 5432

# Test with psql
psql "postgresql://ai_lms_admin:pass@endpoint:5432/ai_lms" -c "SELECT version();"
```

### **Connection Timeout**

- VPC security group may be blocking traffic
- Check NACL (Network ACL) rules
- Verify subnet routing tables

### **Authentication Failed**

- Verify username and password
- Check if IAM authentication is interfering
- Try resetting master password:

```bash
aws rds modify-db-instance \
  --db-instance-identifier ai-lms-db \
  --master-user-password 'NewPassword123!'
```

### **SSL Connection Required**

Add SSL mode to connection string:

```env
NEXT_PUBLIC_DATABASE_CONNECTION_STRING=postgresql://user:pass@endpoint:5432/ai_lms?sslmode=require
```

---

## 📚 Additional Resources

- [AWS RDS Documentation](https://docs.aws.amazon.com/rds/)
- [PostgreSQL on RDS Best Practices](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_BestPractices.html)
- [Drizzle ORM Documentation](https://orm.drizzle.team/)
- [AWS Security Best Practices](https://docs.aws.amazon.com/security/)

---

## 🎯 Quick Reference

### **Connection String Template**
```
postgresql://[user]:[password]@[endpoint]:[port]/[database]?sslmode=require
```

### **Common Commands**
```bash
# List databases
psql "connection_string" -c "\l"

# List tables
psql "connection_string" -c "\dt"

# Check connection
psql "connection_string" -c "SELECT version();"

# Run migrations
npx drizzle-kit push
```

### **Environment Variables**
```env
NEXT_PUBLIC_DATABASE_CONNECTION_STRING=postgresql://ai_lms_admin:pass@endpoint:5432/ai_lms
JWT_SECRET=$(openssl rand -base64 32)
```

---

**Need help?** Check the [main README](../README.md) or [create an issue](https://github.com/ramesh-nt04/lms/issues).
