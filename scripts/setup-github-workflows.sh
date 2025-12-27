#!/bin/bash

# Setup GitHub Workflows
# This script helps you set up GitHub Actions workflows properly

set -e

echo "🔧 GitHub Workflows Setup"
echo "========================"
echo ""

# Check if workflow files exist
if [ ! -d .github/workflows ]; then
    echo "❌ .github/workflows directory not found"
    echo "   Make sure you're in the conductor directory"
    exit 1
fi

echo "📋 Current workflow files:"
ls -la .github/workflows/
echo ""

echo "📝 To set up workflows properly, you need:"
echo ""
echo "1. A GitHub Personal Access Token with 'workflow' scope"
echo "2. Updated git credentials"
echo ""
echo "Let's set this up step by step..."
echo ""

# Check if remote is configured
if ! git remote get-url origin > /dev/null 2>&1; then
    echo "❌ No git remote configured"
    echo "   Run: git remote add origin https://github.com/speaks999/conductor.git"
    exit 1
fi

CURRENT_REMOTE=$(git remote get-url origin)
echo "📍 Current remote: $CURRENT_REMOTE"
echo ""

# Check if workflows are already committed
if git ls-files --error-unmatch .github/workflows/*.yml > /dev/null 2>&1; then
    echo "✅ Workflow files are tracked in git"
else
    echo "📦 Staging workflow files..."
    git add .github/workflows/
    git commit -m "Add GitHub Actions workflows" 2>/dev/null || echo "   (Already committed or no changes)"
fi

echo ""
echo "🔐 Token Setup Instructions:"
echo ""
echo "1. Go to: https://github.com/settings/tokens"
echo "2. Click 'Generate new token (classic)'"
echo "3. Name: 'Conductor Workflow Token'"
echo "4. Select scopes:"
echo "   ✅ repo (Full control)"
echo "   ✅ workflow (Update GitHub Action workflows) ⭐"
echo "5. Generate and copy the token"
echo ""
read -p "Press Enter when you have your token ready..."

echo ""
echo "Enter your GitHub token (it will start with 'ghp_'):"
read -s GITHUB_TOKEN

if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ Token is required"
    exit 1
fi

echo ""
echo "🔗 Updating git remote with token..."

# Extract username and repo from current remote
if [[ $CURRENT_REMOTE == *"@"* ]]; then
    # Already has token, extract repo part
    REPO_PART=$(echo $CURRENT_REMOTE | sed 's/.*@//')
else
    # Extract from https://github.com/username/repo.git
    REPO_PART=$(echo $CURRENT_REMOTE | sed 's|https://github.com/||' | sed 's|\.git$||')
fi

# Update remote with token
git remote set-url origin "https://${GITHUB_TOKEN}@github.com/${REPO_PART}.git"

echo "✅ Remote updated"
echo ""

# Test connection
echo "🧪 Testing connection..."
if git ls-remote --heads origin main > /dev/null 2>&1; then
    echo "✅ Connection successful!"
else
    echo "⚠️  Connection test failed, but continuing..."
fi

echo ""
echo "📤 Pushing workflows..."
if git push origin main; then
    echo ""
    echo "✅ Successfully pushed workflows!"
    echo ""
    echo "🎉 Setup complete!"
    echo ""
    echo "📝 Next steps:"
    echo "   1. Go to: https://github.com/speaks999/conductor/actions"
    echo "   2. Verify workflows are listed"
    echo "   3. Set up GitHub Secrets (see GITHUB_WORKFLOWS_SETUP.md)"
    echo "   4. Make a test commit to trigger workflows"
else
    echo ""
    echo "❌ Push failed. This might be because:"
    echo "   - Token doesn't have 'workflow' scope"
    echo "   - Token has expired"
    echo "   - Repository permissions issue"
    echo ""
    echo "Try:"
    echo "   1. Verify token has 'workflow' scope"
    echo "   2. Create a new token if needed"
    echo "   3. Run this script again"
fi

