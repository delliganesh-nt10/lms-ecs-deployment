#!/bin/bash

# Production Deployment Script for AI-LMS
# This script handles production deployment with safety checks

set -e  # Exit on error

echo "╔════════════════════════════════════════╗"
echo "║   AI-LMS Production Deployment         ║"
echo "╚════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}❌ Do not run this script as root${NC}"
    exit 1
fi

# Check if .env.production exists
if [ ! -f .env.production ]; then
    echo -e "${RED}❌ .env.production file not found!${NC}"
    echo "Please create .env.production from .env.production.example"
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Pre-flight checks passed${NC}"
echo ""

# Menu
echo "Select deployment action:"
echo "1. Initial deployment (first time)"
echo "2. Update deployment (rebuild and restart)"
echo "3. Rollback to previous version"
echo "4. View logs"
echo "5. Backup database"
echo "6. Restore database"
echo "7. Stop production"
echo ""
read -p "Enter your choice (1-7): " choice

case $choice in
    1)
        echo ""
        echo -e "${YELLOW}Starting initial deployment...${NC}"
        
        # Create backup directory
        mkdir -p backups
        
        # Build and start containers
        docker compose -f docker-compose.prod.yml up -d --build
        
        # Wait for database
        echo "Waiting for database to be ready..."
        sleep 10
        
        # Run migrations
        echo "Running database migrations..."
        docker compose -f docker-compose.prod.yml exec app npx drizzle-kit push
        
        if [ $? -eq 0 ]; then
            echo ""
            echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
            echo -e "${GREEN}║   Deployment Successful! 🎉            ║${NC}"
            echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
            echo ""
            echo "Application is running at:"
            echo "🌐 http://localhost:3000"
            echo ""
            echo "To enable HTTPS with nginx:"
            echo "docker compose -f docker-compose.prod.yml --profile with-nginx up -d"
        else
            echo -e "${RED}❌ Deployment failed${NC}"
        fi
        ;;
    
    2)
        echo ""
        echo -e "${YELLOW}Updating deployment...${NC}"
        
        # Create backup before update
        echo "Creating backup..."
        BACKUP_FILE="backups/backup-$(date +%Y%m%d-%H%M%S).sql"
        docker compose -f docker-compose.prod.yml exec postgres pg_dump -U ai_lms_user ai_lms > "$BACKUP_FILE"
        echo -e "${GREEN}✅ Backup created: $BACKUP_FILE${NC}"
        
        # Pull latest changes (if using git)
        if [ -d .git ]; then
            echo "Pulling latest changes..."
            git pull
        fi
        
        # Rebuild and restart
        docker compose -f docker-compose.prod.yml up -d --build
        
        # Run migrations
        echo "Running migrations..."
        docker compose -f docker-compose.prod.yml exec app npx drizzle-kit push
        
        echo -e "${GREEN}✅ Deployment updated!${NC}"
        ;;
    
    3)
        echo ""
        echo -e "${YELLOW}Rolling back...${NC}"
        
        # List available backups
        echo "Available backups:"
        ls -lh backups/*.sql 2>/dev/null || echo "No backups found"
        echo ""
        read -p "Enter backup filename to restore: " backup_file
        
        if [ -f "backups/$backup_file" ]; then
            docker compose -f docker-compose.prod.yml exec -T postgres psql -U ai_lms_user -d ai_lms < "backups/$backup_file"
            docker compose -f docker-compose.prod.yml restart app
            echo -e "${GREEN}✅ Rollback completed${NC}"
        else
            echo -e "${RED}❌ Backup file not found${NC}"
        fi
        ;;
    
    4)
        echo ""
        echo -e "${YELLOW}Showing logs (Ctrl+C to exit)...${NC}"
        docker compose -f docker-compose.prod.yml logs -f
        ;;
    
    5)
        echo ""
        echo -e "${YELLOW}Creating database backup...${NC}"
        BACKUP_FILE="backups/backup-$(date +%Y%m%d-%H%M%S).sql"
        docker compose -f docker-compose.prod.yml exec postgres pg_dump -U ai_lms_user ai_lms > "$BACKUP_FILE"
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Backup created: $BACKUP_FILE${NC}"
            ls -lh "$BACKUP_FILE"
        else
            echo -e "${RED}❌ Backup failed${NC}"
        fi
        ;;
    
    6)
        echo ""
        echo "Available backups:"
        ls -lh backups/*.sql 2>/dev/null || echo "No backups found"
        echo ""
        read -p "Enter backup filename to restore: " backup_file
        
        if [ -f "backups/$backup_file" ]; then
            echo -e "${RED}⚠️  This will overwrite the current database!${NC}"
            read -p "Are you sure? (yes/no): " confirm
            
            if [ "$confirm" = "yes" ]; then
                docker compose -f docker-compose.prod.yml exec -T postgres psql -U ai_lms_user -d ai_lms < "backups/$backup_file"
                echo -e "${GREEN}✅ Database restored${NC}"
            fi
        else
            echo -e "${RED}❌ Backup file not found${NC}"
        fi
        ;;
    
    7)
        echo ""
        echo -e "${RED}⚠️  This will stop the production application!${NC}"
        read -p "Are you sure? (yes/no): " confirm
        
        if [ "$confirm" = "yes" ]; then
            docker compose -f docker-compose.prod.yml down
            echo -e "${GREEN}✅ Production stopped${NC}"
        fi
        ;;
    
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac
