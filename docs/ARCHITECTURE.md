# 🏗️ AI-LMS Architecture

## 📁 Project Structure

```
ai-lms/
├── app/                          # Next.js App Router
│   ├── api/                      # API Routes
│   │   ├── auth/                 # Authentication endpoints
│   │   ├── courses/             # Course management
│   │   └── study-type/          # Study materials
│   ├── dashboard/               # User dashboard
│   ├── login/                   # Login page
│   ├── register/                # Registration page
│   └── page.js                  # Home page
│
├── configs/                      # Configuration
│   ├── db.js                    # Database connection
│   └── schema.js                # Database schema
│
├── contexts/                     # React Contexts
│   └── AuthContext.js           # Authentication
│
├── docs/                         # Documentation
│   ├── ARCHITECTURE.md          # This file
│   ├── AUTH_SYSTEM.md           # Auth docs
│   ├── DOCKER.md                # Docker guide
│   └── SETUP.md                 # Setup guide
│
├── lib/                          # Utilities
│   └── auth.js                  # Auth utilities
│
├── scripts/                      # Setup scripts
│   ├── docker-setup.sh          # Docker wizard
│   └── setup-db.sh              # DB setup
│
├── docker-compose.yml           # Docker orchestration
├── Dockerfile                   # Docker build
└── middleware.js                # Auth middleware
```

## 🏛️ Architecture Layers

### 1. **Presentation Layer** (Frontend)
- Next.js App Router
- React Components
- Tailwind CSS

### 2. **API Layer** (Backend)
- Next.js API Routes
- Authentication endpoints
- Course management APIs

### 3. **Business Logic Layer**
- Authentication (JWT)
- Authorization (Middleware)
- Data validation

### 4. **Data Layer**
- PostgreSQL Database
- Drizzle ORM
- Database migrations

## 🔐 Authentication Flow

```
User → Login Page → API → Verify Password → Generate JWT → Set Cookie → Dashboard
```

## 🗄️ Database Schema

- **users** - User accounts
- **studyMaterial** - Courses
- **chapterNotes** - Chapter content
- **studyTypeContent** - Study materials

## 🚀 Deployment

- **Development:** `npm run dev`
- **Docker:** `./scripts/docker-setup.sh`
- **Production:** Docker Compose

## 📦 Technology Stack

- **Frontend:** Next.js 15, React 18, Tailwind CSS
- **Backend:** Node.js, Next.js API Routes
- **Database:** PostgreSQL 16, Drizzle ORM
- **Auth:** JWT, bcryptjs
- **DevOps:** Docker, Docker Compose

---

**Last Updated:** 2025-12-09
