#!/bin/bash

# Quick Setup Script for Conductor
# This script helps you get started quickly

set -e

echo "🚀 Conductor Quick Setup"
echo "========================"
echo ""

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 20+ first."
    exit 1
fi

NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 20 ]; then
    echo "⚠️  Warning: Node.js version is less than 20. Recommended: Node.js 20+"
fi

# Check npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed. Please install npm first."
    exit 1
fi

echo "✅ Node.js $(node -v) detected"
echo "✅ npm $(npm -v) detected"
echo ""

# Install dependencies
echo "📦 Installing dependencies..."
npm install
echo "✅ Dependencies installed"
echo ""

# Check for .env.local
if [ ! -f .env.local ]; then
    echo "📝 Creating .env.local from example..."
    cp .env.local.example .env.local
    echo "✅ .env.local created"
    echo ""
    echo "⚠️  IMPORTANT: Edit .env.local with your credentials:"
    echo "   - Supabase URL and keys"
    echo "   - OpenAI API key"
    echo "   - GitHub token"
    echo ""
    read -p "Press Enter when you've configured .env.local..."
else
    echo "✅ .env.local already exists"
fi

# Check if Supabase migration has been run
echo ""
echo "📋 Supabase Setup:"
echo "1. Have you created a Supabase project? [y/N]"
read -p "   " has_supabase

if [ "$has_supabase" != "y" ] && [ "$has_supabase" != "Y" ]; then
    echo ""
    echo "📝 Create a Supabase project:"
    echo "   1. Go to https://app.supabase.com"
    echo "   2. Create a new project"
    echo "   3. Run the migration from supabase/migrations/001_initial_schema.sql"
    echo "   4. Get your API keys from Settings > API"
    echo ""
fi

# Check if GitHub repo exists
echo ""
echo "📋 GitHub Setup:"
echo "1. Do you want to set up GitHub repository now? [y/N]"
read -p "   " setup_github

if [ "$setup_github" = "y" ] || [ "$setup_github" = "Y" ]; then
    if [ -f scripts/setup-github.sh ]; then
        ./scripts/setup-github.sh
    else
        echo "   Run: ./scripts/setup-github.sh"
    fi
fi

echo ""
echo "✨ Setup complete!"
echo ""
echo "🚀 Next steps:"
echo "   1. Make sure .env.local is configured"
echo "   2. Run: npm run dev"
echo "   3. Open: http://localhost:3000"
echo ""
echo "📚 Documentation:"
echo "   - Quick Start: QUICKSTART.md"
echo "   - Detailed Setup: SETUP.md"
echo "   - Implementation: IMPLEMENTATION.md"
echo ""


