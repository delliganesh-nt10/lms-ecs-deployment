# 🚀 AI-LMS - Running Without Clerk & AI

## ✅ Current Status

Your application is now configured to run **WITHOUT**:
- ❌ Clerk Authentication (disabled)
- ❌ Google Gemini AI (disabled)
- ❌ Inngest (disabled)

The app will run with:
- ✅ Local PostgreSQL database only
- ✅ Basic functionality without authentication

## 📝 Next Steps

### 1. Setup PostgreSQL Database

You need to create the database. Choose one of these methods:

#### Option A: Run the setup script (requires sudo password)
```bash
./setup-db.sh
```

#### Option B: Manual setup
```bash
# Access PostgreSQL
sudo -u postgres psql

# Run these commands:
CREATE USER ai_lms_user WITH PASSWORD 'ai_lms_password';
CREATE DATABASE ai_lms OWNER ai_lms_user;
GRANT ALL PRIVILEGES ON DATABASE ai_lms TO ai_lms_user;
\q
```

### 2. Create Database Tables

After creating the database, run:
```bash
npx drizzle-kit push
```

This will create all the necessary tables in your database.

### 3. Access the Application

The app is running at:
**http://localhost:3000**

## 🔧 What Was Changed

1. **middleware.js** - Disabled Clerk authentication middleware
2. **app/layout.js** - Removed ClerkProvider wrapper
3. **app/provider.js** - Disabled useUser hook
4. **.env.local** - Removed Clerk and AI API keys
5. **drizzle.config.js** - Updated to use environment variable

## 📊 Database Schema

The app uses these tables:
- `users` - User information
- `studyMaterial` - Course/study material data
- `chapterNotes` - Chapter notes content
- `studyTypeContent` - Quiz, flashcard, Q&A content

## ⚠️ Limitations

Without Clerk and AI:
- No user authentication (anyone can access)
- No AI-generated content (you'll need to add content manually)
- Some features may not work as expected

## 🔄 To Re-enable Clerk & AI Later

1. Uncomment the code in:
   - `middleware.js`
   - `app/layout.js`
   - `app/provider.js`

2. Add your API keys to `.env.local`:
   ```env
   NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=your_key
   CLERK_SECRET_KEY=your_secret
   NEXT_PUBLIC_GEMINI_API_KEY=your_key
   ```

3. Restart the dev server

## 🆘 Troubleshooting

### Server won't start
```bash
# Kill any process on port 3000
npx kill-port 3000
# Restart
npm run dev
```

### Database connection errors
```bash
# Check if PostgreSQL is running
sudo systemctl status postgresql

# Start PostgreSQL if needed
sudo systemctl start postgresql
```

### Can't connect to database
```bash
# Test connection
psql -U ai_lms_user -d ai_lms -h localhost
# Password: ai_lms_password
```
