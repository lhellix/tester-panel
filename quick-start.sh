#!/bin/bash

# Quick Start Guide for Tester Panel Backend

echo "╔════════════════════════════════════════╗"
echo "║  Tester Panel Backend - Quick Start    ║"
echo "╚════════════════════════════════════════╝"
echo ""

# Check prerequisites
echo "📋 Checking prerequisites..."
echo ""

# Node.js check
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo "✓ Node.js $NODE_VERSION"
else
    echo "❌ Node.js not found. Please install Node.js >= 14 from https://nodejs.org"
    exit 1
fi

# npm check
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    echo "✓ npm $NPM_VERSION"
else
    echo "❌ npm not found"
    exit 1
fi

# Docker check (optional)
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    echo "✓ $DOCKER_VERSION"
else
    echo "ℹ️  Docker not found (optional for containerized deployment)"
fi

echo ""
echo "════════════════════════════════════════"
echo "🚀 QUICK START OPTIONS"
echo "════════════════════════════════════════"
echo ""

echo "1️⃣  OPTION 1: Local Development (Recommended for development)"
echo "   npm run dev"
echo "   - Auto-reload on file changes"
echo "   - Requires local MySQL setup"
echo "   - API runs on http://localhost:3000"
echo ""

echo "2️⃣  OPTION 2: Docker Compose (Recommended for testing)"
echo "   docker-compose up"
echo "   - Includes MySQL automatically"
echo "   - No local database setup needed"
echo "   - API runs on http://localhost:3000"
echo ""

echo "3️⃣  OPTION 3: Production (Local)"
echo "   npm install"
echo "   npm start"
echo "   - Optimized for production"
echo "   - Requires MySQL configured"
echo ""

echo "4️⃣  OPTION 4: Deploy to Cloud (Production)"
echo "   - Railway: npm install -g @railway/cli && railway up"
echo "   - Heroku: heroku create app-name && git push heroku main"
echo "   - See DEPLOY.md for detailed instructions"
echo ""

echo "════════════════════════════════════════"
echo "📚 DOCUMENTATION"
echo "════════════════════════════════════════"
echo ""
echo "📖 API Endpoints........: README.md"
echo "🚀 Deployment Guide.....: DEPLOY.md"
echo "📁 Project Structure....: STRUCTURE.md"
echo "📮 Postman Collection...: Postman_Collection.json"
echo "🧪 Test Examples........: ./test-api.sh"
echo ""

echo "════════════════════════════════════════"
echo "🔧 SETUP & CONFIGURATION"
echo "════════════════════════════════════════"
echo ""

# Check if .env exists
if [ -f .env ]; then
    echo "✓ .env file found"
else
    echo "📝 Creating .env file from template..."
    if [ -f .env.example ]; then
        cp .env.example .env
        echo "✓ .env created - Please update with your settings"
    fi
fi

echo ""

# Check if node_modules exists
if [ -d node_modules ]; then
    echo "✓ Dependencies already installed"
else
    echo "📦 Installing dependencies..."
    npm install
fi

echo ""
echo "════════════════════════════════════════"
echo "✅ READY TO START!"
echo "════════════════════════════════════════"
echo ""
echo "Choose your startup option above and run the command."
echo ""
echo "Questions? Check the documentation files above."
echo ""
