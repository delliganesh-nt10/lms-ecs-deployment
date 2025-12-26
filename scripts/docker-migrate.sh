#!/bin/bash

# Database migration script for Docker
# Run this after starting the Docker containers

echo "🗄️  Running database migrations..."

# Wait for database to be ready
echo "Waiting for database to be ready..."
sleep 5

# Run migrations
docker compose exec app npx drizzle-kit push

if [ $? -eq 0 ]; then
    echo "✅ Database migrations completed successfully!"
else
    echo "❌ Migration failed. Make sure the containers are running."
    echo "Run: docker compose up -d"
fi
