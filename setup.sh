#!/bin/bash

# Tester Panel Backend - Quick Start & Deployment Script

set -e

echo "======================================"
echo "Tester Panel Backend Setup"
echo "======================================"

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js >= 14"
    exit 1
fi

echo "✓ Node.js found: $(node --version)"

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed"
    exit 1
fi

echo "✓ npm found: $(npm --version)"

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
npm install

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo ""
    echo "📝 Creating .env file..."
    cp .env.example .env
    echo "✓ .env file created. Please update it with your configuration."
fi

echo ""
echo "======================================"
echo "✅ Setup Complete!"
echo "======================================"
echo ""
echo "📋 Next Steps:"
echo ""
echo "1. Development (Local):"
echo "   npm run dev"
echo ""
echo "2. Production (Local):"
echo "   npm start"
echo ""
echo "3. with Docker:"
echo "   docker-compose up"
echo ""
echo "4. Deploy to Railway:"
echo "   npm install -g @railway/cli"
echo "   railway up"
echo ""
echo "5. Deploy to Heroku:"
echo "   heroku create your-app-name"
echo "   git push heroku main"
echo ""
echo "======================================"
echo "API Documentation: See README.md"
echo "======================================"
