#!/bin/bash

# Push Initial Commit to GitHub
# This script stages all files, commits, and pushes to the remote repository

set -e

echo "🚀 Pushing initial commit to GitHub..."
echo ""

# Check if git is initialized
if [ ! -d .git ] && ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Git repository not initialized. Run ./scripts/connect-github.sh first"
    exit 1
fi

# Check if remote exists
if ! git remote get-url origin > /dev/null 2>&1; then
    echo "❌ Remote repository not configured. Run ./scripts/connect-github.sh first"
    exit 1
fi

# Stage all files
echo "📦 Staging files..."
git add .

# Check if there are changes to commit
if git diff --staged --quiet; then
    echo "⚠️  No changes to commit"
else
    # Commit
    echo "💾 Creating commit..."
    git commit -m "Initial commit: Conductor application

- Set up Next.js project with TypeScript
- Implemented Planner using Vercel AI SDK v6
- Built Orchestrator state machine
- Created Cursor Background Agent adapter
- Implemented GitHub adapter for PR management
- Set up Supabase database schema
- Created API endpoints for job management
- Built dashboard UI with Next.js and Tailwind CSS
- Added GitHub Actions workflows
- Created setup scripts and documentation"

    echo "✅ Commit created"
fi

# Push to remote
echo "📤 Pushing to GitHub..."
git push -u origin main

echo ""
echo "✅ Successfully pushed to https://github.com/speaks999/conductor"
echo ""
echo "🎉 Your repository is now connected and pushed!"
echo ""
echo "📝 Next steps:"
echo "   1. Set up GitHub Secrets (Settings > Secrets and variables > Actions):"
echo "      - NEXT_PUBLIC_SUPABASE_URL"
echo "      - NEXT_PUBLIC_SUPABASE_ANON_KEY"
echo "      - SUPABASE_SERVICE_ROLE_KEY"
echo "      - OPENAI_API_KEY"
echo "      - GITHUB_TOKEN"
echo ""
echo "   2. Create your Supabase project (see SETUP.md)"
echo "   3. Configure .env.local with your credentials"
echo "   4. Run: npm run dev"

