#!/bin/bash

# AI-LMS Docker Setup Script
# This script helps you build and run the application in Docker

echo "╔════════════════════════════════════════╗"
echo "║   AI-LMS Docker Setup                  ║"
echo "╚════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed!${NC}"
    echo "Please install Docker first: https://docs.docker.com/get-docker/"
    exit 1
fi

echo -e "${GREEN}✅ Docker is installed${NC}"

# Check if Docker Compose is available
if ! docker compose version &> /dev/null; then
    echo -e "${RED}❌ Docker Compose is not available!${NC}"
    echo "Please install Docker Compose: https://docs.docker.com/compose/install/"
    exit 1
fi

echo -e "${GREEN}✅ Docker Compose is available${NC}"
echo ""

# Menu
echo "What would you like to do?"
echo "1. Build and start the application (first time)"
echo "2. Start the application (already built)"
echo "3. Stop the application"
echo "4. View logs"
echo "5. Rebuild the application"
echo "6. Clean up (remove containers and volumes)"
echo ""
read -p "Enter your choice (1-6): " choice

case $choice in
    1)
        echo ""
        echo -e "${YELLOW}Building and starting the application...${NC}"
        docker compose up -d --build
        
        if [ $? -eq 0 ]; then
            echo ""
            echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
            echo -e "${GREEN}║   Application Started Successfully!   ║${NC}"
            echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
            echo ""
            echo "🌐 Application: http://localhost:3000"
            echo "🗄️  Database: localhost:5432"
            echo ""
            echo "Wait a few seconds for the database to initialize..."
            echo ""
            echo "To view logs: docker compose logs -f"
            echo "To stop: docker compose down"
        else
            echo -e "${RED}❌ Failed to start the application${NC}"
        fi
        ;;
    
    2)
        echo ""
        echo -e "${YELLOW}Starting the application...${NC}"
        docker compose up -d
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Application started!${NC}"
            echo "🌐 http://localhost:3000"
        else
            echo -e "${RED}❌ Failed to start${NC}"
        fi
        ;;
    
    3)
        echo ""
        echo -e "${YELLOW}Stopping the application...${NC}"
        docker compose down
        echo -e "${GREEN}✅ Application stopped${NC}"
        ;;
    
    4)
        echo ""
        echo -e "${YELLOW}Showing logs (Ctrl+C to exit)...${NC}"
        docker compose logs -f
        ;;
    
    5)
        echo ""
        echo -e "${YELLOW}Rebuilding the application...${NC}"
        docker compose down
        docker compose up -d --build
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Application rebuilt and started!${NC}"
            echo "🌐 http://localhost:3000"
        else
            echo -e "${RED}❌ Failed to rebuild${NC}"
        fi
        ;;
    
    6)
        echo ""
        echo -e "${RED}⚠️  This will remove all containers and data!${NC}"
        read -p "Are you sure? (yes/no): " confirm
        
        if [ "$confirm" = "yes" ]; then
            echo -e "${YELLOW}Cleaning up...${NC}"
            docker compose down -v
            docker rmi ai-lms-app 2>/dev/null
            echo -e "${GREEN}✅ Cleanup complete${NC}"
        else
            echo "Cancelled"
        fi
        ;;
    
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac
