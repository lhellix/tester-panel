# Project Structure

```
backend/
├── config/
│   ├── database.js           # MySQL connection pool
│   └── initDb.js             # Database initialization & migrations
│
├── middleware/
│   ├── auth.js               # JWT verification middleware
│   └── errorHandler.js       # Global error handling
│
├── models/
│   ├── User.js               # User model & database operations
│   └── Item.js               # Item model & database operations
│
├── routes/
│   ├── auth.js               # Authentication endpoints
│   ├── users.js              # User CRUD endpoints
│   └── items.js              # Item CRUD endpoints
│
├── tests/
│   └── api.test.js           # API integration tests
│
├── .env                       # Environment variables (local dev)
├── .env.example               # Environment template
├── .gitignore                 # Git ignore rules
├── Dockerfile                 # Docker image configuration
├── docker-compose.yml         # Local development with Docker
├── package.json               # Project dependencies
├── Procfile                   # Heroku deployment config
├── railway.json               # Railway deployment config
├── server.js                  # Application entry point
│
├── .github/
│   └── workflows/
│       └── deploy.yml         # GitHub Actions CI/CD
│
├── README.md                  # API documentation
├── DEPLOY.md                  # Deployment guide
├── Postman_Collection.json    # Postman API collection
└── setup.sh                   # Setup automation script
```

## File Descriptions

### Core Application Files

**server.js** - Main application entry point, Express setup, route definitions

**config/database.js** - MySQL connection pool with configuration

**config/initDb.js** - Initializes database with required tables on startup

### Middleware

**middleware/auth.js** - JWT token verification and user authentication

**middleware/errorHandler.js** - Global error handler and response formatter

### Data Models

**models/User.js** - User operations: create, read, update, delete, password management

**models/Item.js** - Item operations: CRUD for user-owned items

### Routes / API Endpoints

**routes/auth.js** - POST /register, POST /login

**routes/users.js** - CRUD operations for users

**routes/items.js** - CRUD operations for items

### Configuration Files

**.env** - Local environment variables (development)

**.env.example** - Template for environment variables

**package.json** - Node.js dependencies and scripts

### Deployment

**Dockerfile** - Container image for production deployment

**docker-compose.yml** - Multi-container setup for local development (app + MySQL)

**Procfile** - Heroku deployment specification

**railway.json** - Railway deployment configuration

**.github/workflows/deploy.yml** - GitHub Actions pipeline for testing and deployment

### Documentation

**README.md** - Complete API documentation with examples

**DEPLOY.md** - Step-by-step deployment guide for Railway, Heroku, and Docker

**Postman_Collection.json** - Ready-to-import Postman collection

## Quick Start Commands

```bash
# Development
npm run dev

# Production
npm start

# With Docker
docker-compose up

# Testing
npm test

# Deployment
npm install -g @railway/cli
railway up
```
