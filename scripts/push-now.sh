#!/bin/bash

# Push Now - Push everything except workflows, then add workflows separately
# This works around the workflow scope requirement

set -e

echo "📤 Pushing to GitHub (workaround for workflow scope)..."
echo ""

# Check if we have a remote
if ! git remote get-url origin > /dev/null 2>&1; then
    echo "❌ No remote configured. Run ./scripts/create-and-push.sh first"
    exit 1
fi

# Temporarily move workflow files
if [ -d .github/workflows ]; then
    echo "📦 Temporarily moving workflow files..."
    mkdir -p /tmp/conductor-workflows-backup
    mv .github/workflows/*.yml /tmp/conductor-workflows-backup/ 2>/dev/null || true
    echo "✅ Workflow files moved"
    
    # Commit the removal
    git add .github/workflows/
    git commit -m "Temporarily remove workflows (will add back with proper token)" 2>/dev/null || true
fi

# Push without workflows
echo "📤 Pushing (without workflows)..."
if git push -u origin main; then
    echo "✅ Successfully pushed (without workflows)!"
    
    # Restore workflow files
    if [ -d /tmp/conductor-workflows-backup ]; then
        echo ""
        echo "📦 Restoring workflow files locally..."
        mv /tmp/conductor-workflows-backup/*.yml .github/workflows/ 2>/dev/null || true
        rmdir /tmp/conductor-workflows-backup 2>/dev/null || true
        
        # Add workflows back to git
        git add .github/workflows/
        git commit -m "Add GitHub Actions workflows" 2>/dev/null || true
        
        echo ""
        echo "📝 Workflow files restored locally."
        echo ""
        echo "To add workflows to GitHub:"
        echo "  1. Update your GitHub token with 'workflow' scope"
        echo "  2. Run: git push origin main"
        echo ""
        echo "Or add them manually via GitHub UI:"
        echo "  - Go to: https://github.com/speaks999/conductor"
        echo "  - Click 'Add file' → 'Create new file'"
        echo "  - Path: .github/workflows/ci.yml"
        echo "  - Copy contents from your local file"
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
echo "✅ Done! Your code is on GitHub (workflows can be added later)"


