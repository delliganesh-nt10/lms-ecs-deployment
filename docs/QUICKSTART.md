# 🚀 Quick Start Guide

## Current Status: ✅ Server Running!

Your AI-LMS application is currently running at:
### **http://localhost:3000**

The app is configured to run **WITHOUT Clerk authentication and AI features**.

---

## 📋 Complete These Steps:

### Step 1: Setup Database (Required)

Run the database setup script:

```bash
./setup-db.sh
```

This will:
- Create PostgreSQL user: `ai_lms_user`
- Create database: `ai_lms`
- Set up permissions

**Note:** You'll need to enter your system password (sudo).

---

### Step 2: Create Database Tables (Required)

After the database is created, run:

```bash
npx drizzle-kit push
```

This creates all the tables needed by the application.

---

### Step 3: Open the Application

Visit: **http://localhost:3000**

---

## 🎯 What's Working Now

✅ Next.js server running  
✅ No authentication required  
✅ Database configuration ready  
⏳ Database needs to be created (Step 1 & 2 above)  

---

## 📁 Important Files

- **`.env.local`** - Environment configuration (database connection)
- **`setup-db.sh`** - Database setup script
- **`SETUP.md`** - Detailed setup documentation
- **`README.md`** - Original project documentation

---

## 🔧 Common Commands

```bash
# Start development server
npm run dev

# Stop server
# Press Ctrl+C in the terminal

# Setup database
./setup-db.sh

# Create/update database tables
npx drizzle-kit push

# View database
psql -U ai_lms_user -d ai_lms -h localhost
# Password: ai_lms_password
```

---

## ⚠️ Current Limitations

Since Clerk and AI are disabled:
- ❌ No user authentication
- ❌ No AI-generated content
- ❌ Some features may not work

The app will work for:
- ✅ Viewing the interface
- ✅ Database operations
- ✅ Basic CRUD operations

---

## 🆘 Need Help?

1. **Server won't start?**
   ```bash
   npx kill-port 3000
   npm run dev
   ```

2. **Database connection errors?**
   ```bash
   sudo systemctl status postgresql
   sudo systemctl start postgresql
   ```

3. **Want to enable Clerk & AI?**
   - See `SETUP.md` for instructions
   - You'll need API keys from Clerk and Google

---

## 📚 Next Steps

After completing Steps 1 & 2 above:

1. Explore the application at http://localhost:3000
2. Check the database tables
3. Review the code structure
4. Decide if you want to enable Clerk/AI features

---

**Happy Coding! 🎉**
