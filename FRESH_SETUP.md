# Fresh Setup from Scratch

Since you deleted the previous repository, let's set everything up from scratch!

## Quick Setup (Recommended)

Run this single command:

```bash
./scripts/setup-from-scratch.sh
```

This script will:
1. ✅ Clean up any existing git state
2. ✅ Initialize a fresh git repository
3. ✅ Create a new GitHub repository (or connect to one you create)
4. ✅ Push all your code

## Manual Setup

If you prefer to do it step by step:

### Step 1: Clean Up

```bash
# Remove any existing git state
rm -rf .git
```

### Step 2: Initialize Git

```bash
git init
git branch -M main
```

### Step 3: Create GitHub Repository

**Option A: Using GitHub CLI** (if installed)
```bash
gh repo create conductor \
  --description "Conductor — the control plane for AI-native software delivery" \
  --public \
  --source=. \
  --remote=origin \
  --push
```

**Option B: Manual Creation**
1. Go to: https://github.com/new
2. Repository name: `conductor`
3. Description: `Conductor — the control plane for AI-native software delivery`
4. Choose Public or Private
5. **DO NOT** check any boxes (no README, .gitignore, or license)
6. Click "Create repository"

Then connect:
```bash
git remote add origin https://github.com/YOUR_USERNAME/conductor.git
git add .
git commit -m "Initial commit: Conductor application"
git push -u origin main
```

## After Setup

### 1. Set Up GitHub Secrets

Go to: `https://github.com/YOUR_USERNAME/conductor/settings/secrets/actions`

Add these secrets:
- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY`
- `OPENAI_API_KEY`
- `GITHUB_TOKEN` (make sure it has `workflow` scope!)
- `CURSOR_API_KEY` (when available)

### 2. Create Supabase Project

1. Go to: https://app.supabase.com
2. Create a new project
3. Run the migration from `supabase/migrations/001_initial_schema.sql` in SQL Editor
4. Get your API keys from Settings > API

### 3. Configure Environment

```bash
cp .env.local.example .env.local
# Edit .env.local with your credentials
```

### 4. Install and Run

```bash
npm install
npm run dev
```

## Troubleshooting

### "GitHub CLI not found"
Install it:
```bash
brew install gh
gh auth login
```

### "Permission denied" when pushing
- Make sure you're authenticated with GitHub
- Check your SSH keys or use HTTPS with a personal access token

### "Workflow scope error"
- Make sure your `GITHUB_TOKEN` secret has the `workflow` scope
- Create a new token at https://github.com/settings/tokens with `workflow` scope

## Need Help?

- See [QUICKSTART.md](./QUICKSTART.md) for quick start guide
- See [SETUP.md](./SETUP.md) for detailed setup instructions
- See [IMPLEMENTATION.md](./IMPLEMENTATION.md) for architecture details


