
# AI-Powered Learning Management System (AI-LMS)

A modern, full-stack Learning Management System built with Next.js, featuring custom authentication, PostgreSQL database, and Docker deployment support. Create personalized study materials for exam preparation, job interviews, or general practice.

## ✨ Features

### **Core Features:**
* **Custom Authentication System** - Secure JWT-based authentication without external dependencies
* **User Management** - Registration, login, and session management
* **Study Material Management** - Create and organize learning content
* **Interactive Dashboard** - User-friendly interface for managing courses
* **Protected Routes** - Middleware-based route protection

### **Study Materials:**
* **Chapter Notes** - Detailed notes in markdown format
* **Flashcards** - Interactive flashcards for memorization
* **Quizzes** - Gamified quizzes with timers and scoring
* **Q&A** - Comprehensive question-and-answer pairs

### **Technical Features:**
* **Flexible Database** - PostgreSQL with Drizzle ORM (Local, Docker, or AWS RDS)
* **Docker Support** - Full containerization with Docker Compose
* **Production Ready** - Optimized builds and deployment
* **Responsive Design** - Modern UI with Tailwind CSS
* **Cloud Ready** - Easy integration with AWS RDS and managed databases

## 🚀 Tech Stack

* **Frontend:** Next.js 15 (App Router), React 18, Tailwind CSS
* **Backend:** Node.js, Next.js API Routes
* **Database:** PostgreSQL 16, Drizzle ORM
* **Authentication:** JWT (jsonwebtoken), bcryptjs
* **DevOps:** Docker, Docker Compose
* **Optional:** Inngest (background jobs), Google Gemini (AI)

## 📁 Project Structure

```
ai-lms/
├── app/              # Next.js application
├── configs/          # Configuration files
├── contexts/         # React contexts
├── docs/             # Documentation
├── lib/              # Utility libraries
├── scripts/          # Setup scripts
├── public/           # Static assets
└── docker-compose.yml
```

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for detailed architecture.

## 🛠️ Installation and Setup

### **Option 1: Docker with Local Database (Recommended for Development)**

```bash
# 1. Clone the repository
git clone https://github.com/navattech/lms.git
cd ai-lms

# 2. Run Docker setup
./scripts/docker-setup.sh
# Choose option 1 (Build and start)

# 3. Run database migrations
./scripts/docker-migrate.sh

# 4. Access the application
# http://localhost:3000
```

### **Option 2: Local Development with Local PostgreSQL**

```bash
# 1. Clone and install
git clone https://github.com/navattech/lms.git
cd ai-lms
npm install

# 2. Setup PostgreSQL database
./scripts/setup-db.sh

# 3. Create .env.local file
cat > .env.local << EOF
NEXT_PUBLIC_DATABASE_CONNECTION_STRING=postgresql://ai_lms_user:ai_lms_password@localhost:5432/ai_lms
JWT_SECRET=$(openssl rand -base64 32)
EOF

# 4. Run database migrations
npx drizzle-kit push

# 5. Start development server
npm run dev
```

### **Option 3: AWS RDS PostgreSQL (Recommended for Production)**

#### **Step 1: Create RDS PostgreSQL Instance**

1. **Login to AWS Console** → Navigate to RDS
2. **Create Database:**
   - Engine: PostgreSQL 16
   - Template: Free tier (dev) or Production
   - DB Instance: `ai-lms-db`
   - Master username: `ai_lms_admin`
   - Master password: [Create strong password]
   - DB name: `ai_lms`
   - Instance class: db.t3.micro (or higher for production)

3. **Configure Security:**
   - VPC: Select your VPC
   - Public access: Yes (if accessing from outside AWS)
   - Security group: Create new or select existing
   
4. **Security Group Rules:**
   - Type: PostgreSQL
   - Port: 5432
   - Source: Your IP or 0.0.0.0/0 (development only)

#### **Step 2: Setup Application with RDS**

```bash
# 1. Clone and install
git clone https://github.com/navattech/lms.git
cd ai-lms
npm install

# 2. Create .env.local with RDS endpoint
cat > .env.local << 'EOF'
NEXT_PUBLIC_DATABASE_CONNECTION_STRING=postgresql://ai_lms_admin:YOUR_PASSWORD@your-instance.region.rds.amazonaws.com:5432/ai_lms
JWT_SECRET=GENERATE_STRONG_SECRET_KEY
EOF

# 3. Generate JWT secret
echo "JWT_SECRET=$(openssl rand -base64 32)" >> .env.local

# 4. Run database migrations to RDS
npx drizzle-kit push

# 5. Start the application
npm run dev
```

#### **Step 3: Verify RDS Connection**

```bash
# Test RDS connection
psql "postgresql://ai_lms_admin:YOUR_PASSWORD@your-instance.region.rds.amazonaws.com:5432/ai_lms"

# Check tables were created
\dt
```

### **Environment Variables Reference**

Create `.env.local` (development) or `.env.production` (production):

```env
# Database (Required)
NEXT_PUBLIC_DATABASE_CONNECTION_STRING=postgresql://user:password@host:5432/database

# JWT Secret (Required) - Generate with: openssl rand -base64 32
JWT_SECRET=your-super-secret-jwt-key

# Optional: AI Features
NEXT_PUBLIC_GEMINI_API_KEY=your_gemini_api_key

# Optional: Background Jobs
INNGEST_EVENT_KEY=your_inngest_event_key
INNGEST_SIGNING_KEY=your_inngest_signing_key

# Application URL
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

### **Database Connection String Formats**

```bash
# Local PostgreSQL
postgresql://ai_lms_user:ai_lms_password@localhost:5432/ai_lms

# Docker PostgreSQL
postgresql://ai_lms_user:ai_lms_password@postgres:5432/ai_lms

# AWS RDS
postgresql://username:password@instance.region.rds.amazonaws.com:5432/ai_lms

# Neon/Supabase/Other Cloud Providers
postgresql://username:password@host:5432/database?sslmode=require
```


## Project Structure

* **`app`**:  Next.js App Router directory containing all application code:
    * **`api`**:  API routes for backend logic.
    * **`components`**: Reusable UI components.
    * **`course/[courseId]`**:  Course details pages (dynamic routing).
    * **`create`**:  Course creation page.
    * **`dashboard`**:  User dashboard.
    * **`layout.js`**: Main application layout.
    * **`page.js`**: Main landing page (optional).
    * **`provider.js`**:  Clerk user provider and setup.
* **`configs`**: Configuration files:
    * **`AiModel.js`**: Configuration for Google Gemini AI models and prompts.
    * **`db.js`**: Database connection setup with Drizzle ORM.
    * **`schema.js`**: Database schema definition using Drizzle ORM.
* **`inngest`**: Inngest functions for background tasks:
    * **`client.js`**: Inngest client setup.
    * **`functions.js`**: Definitions for all Inngest functions.
* **`public`**: Static assets (images, icons, etc.).
* **`styles`**: Global stylesheets.


## API Routes

* **`/api/courses`**:  Handles fetching courses (`GET`) based on `courseId` (for individual course retrieval) or `createdBy` (for user's course list).  Also handles new course creation (`POST`) initiated by the create course page.
* **`/api/create-user`**:  An API endpoint called by the `CreateNewUser` Inngest function to create a new user record in the database upon initial login with Clerk.
* **`/api/generate-course-outline`**: Handles the creation of new courses and triggers AI course outline generation.  Receives course details (topic, type, difficulty) via `POST` request.
* **`/api/study-type`**:  Retrieves study materials for a specific course and study type (`POST`).  Handles "ALL" type to fetch all material types at once.
* **`/api/study-type-content`**:  Triggers the generation of specific study material content (Flashcards, Quiz, Q&A) through Inngest functions, using `chapter` and `type` data sent via `POST`.


## Inngest Functions

* **`helloWorld`**: Example/test function (can be removed).
* **`CreateNewUser`**: Called on user creation event; creates a new user record in the database if one doesn't exist, syncing with Clerk.
* **`GenerateNotes`**:  Triggered by `/api/generate-course-outline`; generates detailed chapter notes using the AI and updates the course status in the database.
* **`GenerateStudyTypeContent`**:  Triggered by `/api/study-type-content`; generates content for specific study material types (flashcards, quizzes, Q&A) using the configured AI models.  Updates the status of the generated content in the database.


## 📚 Documentation

Comprehensive documentation is available in the `docs/` folder:

### **🚀 Getting Started**
* **[QUICKSTART.md](docs/QUICKSTART.md)** - Quick start guide
* **[SETUP.md](docs/SETUP.md)** - Detailed local setup instructions

### **🗄️ Database Setup**
* **[DATABASE_CONFIG.md](docs/DATABASE_CONFIG.md)** - Database configuration guide ⭐
* **[RDS_SETUP.md](docs/RDS_SETUP.md)** - AWS RDS PostgreSQL setup guide

### **🐳 Deployment**
* **[DOCKER.md](docs/DOCKER.md)** - Docker deployment guide
* **[DOCKER_QUICKSTART.md](docs/DOCKER_QUICKSTART.md)** - Quick Docker reference
* **[PRODUCTION.md](docs/PRODUCTION.md)** - Production deployment guide
* **[PRODUCTION_CHECKLIST.md](docs/PRODUCTION_CHECKLIST.md)** - Pre-deployment checklist

### **📖 Reference**
* **[ARCHITECTURE.md](docs/ARCHITECTURE.md)** - System architecture and design
* **[AUTH_SYSTEM.md](docs/AUTH_SYSTEM.md)** - Authentication system details
* **[STATUS.md](docs/STATUS.md)** - Project status and features

## 🐳 Docker Deployment

The application is fully containerized and ready for deployment:

```bash
# Quick start with Docker
./scripts/docker-setup.sh

# Or manually
docker compose up -d --build
./scripts/docker-migrate.sh
```

See [docs/DOCKER.md](docs/DOCKER.md) for detailed Docker instructions.

## 🔐 Authentication

The system uses custom JWT-based authentication:

* **Registration** - Create new accounts with email/password
* **Login** - Secure authentication with bcrypt password hashing
* **Session Management** - HTTP-only cookies with JWT tokens
* **Protected Routes** - Middleware-based route protection

See [docs/AUTH_SYSTEM.md](docs/AUTH_SYSTEM.md) for authentication details.

## Contributing

Contributions are welcome!  Please follow these guidelines:

* Fork the repository.
* Create a new branch for your feature/fix.
* Commit your changes.
* Push your branch to your fork.
* Open a pull request.
