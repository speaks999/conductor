#!/bin/bash

# Supabase Setup Script
# This script helps set up the Supabase project and run migrations

set -e

echo "🚀 Setting up Supabase for Conductor..."

# Check if Supabase CLI is installed
if ! command -v supabase &> /dev/null; then
    echo "❌ Supabase CLI is not installed."
    echo "📦 Install it with: npm install -g supabase"
    exit 1
fi

# Check if user is logged in
if ! supabase projects list &> /dev/null; then
    echo "🔐 Please log in to Supabase:"
    supabase login
fi

echo ""
echo "📋 Choose an option:"
echo "1. Link to existing Supabase project"
echo "2. Create new Supabase project"
echo "3. Run migrations on linked project"
echo "4. Start local Supabase (for development)"
read -p "Enter choice [1-4]: " choice

case $choice in
    1)
        echo "🔗 Linking to existing project..."
        read -p "Enter your project reference ID: " project_ref
        supabase link --project-ref "$project_ref"
        echo "✅ Linked to project: $project_ref"
        ;;
    2)
        echo "🆕 Creating new Supabase project..."
        read -p "Enter project name: " project_name
        read -p "Enter database password: " db_password
        read -p "Enter region (e.g., us-east-1): " region
        
        supabase projects create "$project_name" \
            --db-password "$db_password" \
            --region "$region"
        
        echo "✅ Project created! Please link it using option 1."
        ;;
    3)
        echo "📦 Running migrations..."
        supabase db push
        echo "✅ Migrations applied!"
        ;;
    4)
        echo "🏃 Starting local Supabase..."
        supabase start
        echo "✅ Local Supabase is running!"
        echo "📊 Studio: http://localhost:54323"
        echo "🔌 API URL: http://localhost:54321"
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "✨ Setup complete!"
echo ""
echo "📝 Next steps:"
echo "1. Copy your Supabase URL and anon key from the dashboard"
echo "2. Add them to .env.local:"
echo "   NEXT_PUBLIC_SUPABASE_URL=your_url"
echo "   NEXT_PUBLIC_SUPABASE_ANON_KEY=your_key"
echo "   SUPABASE_SERVICE_ROLE_KEY=your_service_role_key"


