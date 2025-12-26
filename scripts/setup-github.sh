#!/bin/bash

# GitHub Setup Script
# This script helps set up the GitHub repository

set -e

echo "🚀 Setting up GitHub repository for Conductor..."

# Check if git is initialized
if [ ! -d .git ]; then
    echo "📦 Initializing git repository..."
    git init
    git branch -M main
fi

# Check if GitHub CLI is installed
if command -v gh &> /dev/null; then
    echo ""
    echo "📋 Choose an option:"
    echo "1. Create new GitHub repository"
    echo "2. Link to existing GitHub repository"
    read -p "Enter choice [1-2]: " choice

    case $choice in
        1)
            echo "🆕 Creating new GitHub repository..."
            read -p "Enter repository name [conductor]: " repo_name
            repo_name=${repo_name:-conductor}
            read -p "Enter description: " repo_description
            read -p "Make it private? [y/N]: " is_private
            
            if [ "$is_private" = "y" ] || [ "$is_private" = "Y" ]; then
                gh repo create "$repo_name" \
                    --description "$repo_description" \
                    --private \
                    --source=. \
                    --remote=origin \
                    --push
            else
                gh repo create "$repo_name" \
                    --description "$repo_description" \
                    --public \
                    --source=. \
                    --remote=origin \
                    --push
            fi
            
            echo "✅ Repository created and pushed!"
            ;;
        2)
            echo "🔗 Linking to existing repository..."
            read -p "Enter repository URL (e.g., https://github.com/owner/repo): " repo_url
            git remote add origin "$repo_url" || git remote set-url origin "$repo_url"
            echo "✅ Linked to: $repo_url"
            echo "📤 Push your code with: git push -u origin main"
            ;;
        *)
            echo "❌ Invalid choice"
            exit 1
            ;;
    esac
    
    echo ""
    echo "🔐 Setting up GitHub Secrets..."
    echo "You'll need to add these secrets in GitHub Settings > Secrets and variables > Actions:"
    echo ""
    echo "Required secrets:"
    echo "  - NEXT_PUBLIC_SUPABASE_URL"
    echo "  - NEXT_PUBLIC_SUPABASE_ANON_KEY"
    echo "  - SUPABASE_SERVICE_ROLE_KEY"
    echo "  - OPENAI_API_KEY"
    echo "  - CURSOR_API_KEY (when available)"
    echo "  - GITHUB_TOKEN"
    echo ""
    read -p "Would you like to set these up now? [y/N]: " setup_secrets
    
    if [ "$setup_secrets" = "y" ] || [ "$setup_secrets" = "Y" ]; then
        echo "Setting up secrets..."
        
        read -p "NEXT_PUBLIC_SUPABASE_URL: " supabase_url
        gh secret set NEXT_PUBLIC_SUPABASE_URL --body "$supabase_url"
        
        read -p "NEXT_PUBLIC_SUPABASE_ANON_KEY: " supabase_anon
        gh secret set NEXT_PUBLIC_SUPABASE_ANON_KEY --body "$supabase_anon"
        
        read -p "SUPABASE_SERVICE_ROLE_KEY: " supabase_service
        gh secret set SUPABASE_SERVICE_ROLE_KEY --body "$supabase_service"
        
        read -p "OPENAI_API_KEY: " openai_key
        gh secret set OPENAI_API_KEY --body "$openai_key"
        
        echo "✅ Secrets configured!"
    fi
else
    echo "⚠️  GitHub CLI (gh) is not installed."
    echo "📦 Install it from: https://cli.github.com/"
    echo ""
    echo "Or manually:"
    echo "1. Create a repository on GitHub"
    echo "2. Run: git remote add origin <your-repo-url>"
    echo "3. Run: git push -u origin main"
fi

echo ""
echo "✨ GitHub setup complete!"

