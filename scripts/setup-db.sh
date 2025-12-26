#!/bin/bash

# Quick Database Setup for AI-LMS
# This script will guide you through setting up PostgreSQL

echo "╔════════════════════════════════════════╗"
echo "║   AI-LMS Database Setup Wizard        ║"
echo "╚════════════════════════════════════════╝"
echo ""

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo "❌ PostgreSQL is not installed!"
    echo "Install it with: sudo apt install postgresql"
    exit 1
fi

echo "✅ PostgreSQL is installed"
echo ""

# Check if PostgreSQL is running
if sudo systemctl is-active --quiet postgresql 2>/dev/null; then
    echo "✅ PostgreSQL service is running"
else
    echo "⚠️  PostgreSQL service is not running"
    echo "Starting PostgreSQL..."
    sudo systemctl start postgresql
    if [ $? -eq 0 ]; then
        echo "✅ PostgreSQL started successfully"
    else
        echo "❌ Failed to start PostgreSQL"
        exit 1
    fi
fi

echo ""
echo "Creating database and user..."
echo "You may be prompted for your system password."
echo ""

# Create database setup
sudo -u postgres psql << 'EOF'
-- Drop existing if needed (optional, comment out if you want to keep existing data)
-- DROP DATABASE IF EXISTS ai_lms;
-- DROP USER IF EXISTS ai_lms_user;

-- Create user
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_user WHERE usename = 'ai_lms_user') THEN
        CREATE USER ai_lms_user WITH PASSWORD 'ai_lms_password';
        RAISE NOTICE 'User ai_lms_user created';
    ELSE
        RAISE NOTICE 'User ai_lms_user already exists';
    END IF;
END
$$;

-- Create database
SELECT 'CREATE DATABASE ai_lms OWNER ai_lms_user'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'ai_lms')\gexec

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE ai_lms TO ai_lms_user;

-- Connect to the database and grant schema privileges
\c ai_lms
GRANT ALL ON SCHEMA public TO ai_lms_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO ai_lms_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO ai_lms_user;

\echo ''
\echo '✅ Database setup complete!'
\echo ''
EOF

if [ $? -eq 0 ]; then
    echo ""
    echo "╔════════════════════════════════════════╗"
    echo "║        Setup Successful! 🎉            ║"
    echo "╚════════════════════════════════════════╝"
    echo ""
    echo "Database Configuration:"
    echo "  📦 Database: ai_lms"
    echo "  👤 User: ai_lms_user"
    echo "  🔑 Password: ai_lms_password"
    echo "  🌐 Host: localhost"
    echo "  🔌 Port: 5432"
    echo ""
    echo "Connection String (already in .env.local):"
    echo "postgresql://ai_lms_user:ai_lms_password@localhost:5432/ai_lms"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Next Step: Create database tables"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Run this command to create tables:"
    echo "  npx drizzle-kit push"
    echo ""
else
    echo ""
    echo "❌ Database setup failed!"
    echo "Please check the error messages above."
    exit 1
fi
