#!/bin/bash

# Push without workflow files first, then add them
# This works around the workflow scope requirement

set -e

echo "📤 Pushing to GitHub (without workflows first)..."
echo ""

# Check if git is initialized
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Git repository not initialized"
    exit 1
fi

# Check if remote exists
if ! git remote get-url origin > /dev/null 2>&1; then
    echo "❌ Remote repository not configured"
    exit 1
fi

# Temporarily move workflow files
if [ -d .github/workflows ]; then
    echo "📦 Temporarily moving workflow files..."
    mkdir -p /tmp/conductor-workflows-backup
    mv .github/workflows/*.yml /tmp/conductor-workflows-backup/ 2>/dev/null || true
    echo "✅ Workflow files moved"
fi

# Stage everything (without workflows)
git add .

# Check if there are changes
if ! git diff --staged --quiet 2>/dev/null; then
    echo "💾 Creating commit (without workflows)..."
    git commit -m "Initial commit: Conductor application (without workflows)" || true
fi

# Push without workflows
echo "📤 Pushing (without workflows)..."
if git push -u origin main; then
    echo "✅ Successfully pushed (without workflows)"
    
    # Restore workflow files
    if [ -d /tmp/conductor-workflows-backup ]; then
        echo ""
        echo "📦 Restoring workflow files..."
        mv /tmp/conductor-workflows-backup/*.yml .github/workflows/ 2>/dev/null || true
        rmdir /tmp/conductor-workflows-backup 2>/dev/null || true
        
        # Add and commit workflows
        git add .github/workflows/
        git commit -m "Add GitHub Actions workflows" || true
        
        echo "📤 Pushing workflows..."
        if git push origin main; then
            echo "✅ Workflows pushed successfully!"
        else
            echo ""
            echo "⚠️  Could not push workflows. This is because your GitHub token needs 'workflow' scope."
            echo ""
            echo "To fix this:"
            echo "1. Go to: https://github.com/settings/tokens"
            echo "2. Create a new token with 'workflow' scope"
            echo "3. Update your git credentials:"
            echo "   git remote set-url origin https://YOUR_TOKEN@github.com/speaks999/conductor.git"
            echo "4. Push again: git push origin main"
        fi
    fi
else
    # Restore workflow files even if push failed
    if [ -d /tmp/conductor-workflows-backup ]; then
        mv /tmp/conductor-workflows-backup/*.yml .github/workflows/ 2>/dev/null || true
        rmdir /tmp/conductor-workflows-backup 2>/dev/null || true
    fi
    exit 1
fi

echo ""
echo "✅ Push complete!"


