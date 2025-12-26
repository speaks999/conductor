# Create a New GitHub Repository

You have two options to create a new GitHub repository:

## Option 1: Using GitHub CLI (Easiest)

If you have GitHub CLI installed:

```bash
./scripts/create-new-github-repo.sh
```

This will:
- Create a new repository on GitHub
- Connect your local code to it
- Push everything automatically

**Install GitHub CLI** (if needed):
```bash
# macOS
brew install gh

# Then login
gh auth login
```

## Option 2: Manual Creation

1. **Create repository on GitHub**:
   - Go to: https://github.com/new
   - Repository name: `conductor` (or your choice)
   - Description: `Conductor — the control plane for AI-native software delivery`
   - Choose **Public** or **Private**
   - ⚠️ **IMPORTANT**: Do NOT check any boxes (no README, no .gitignore, no license)
   - Click "Create repository"

2. **Connect your local code**:
   ```bash
   ./scripts/connect-to-new-repo.sh
   ```
   
   Or manually:
   ```bash
   # Remove old remote if exists
   git remote remove origin 2>/dev/null || true
   
   # Add new remote (replace with your username/repo)
   git remote add origin https://github.com/YOUR_USERNAME/conductor.git
   
   # Push
   git push -u origin main
   ```

## Option 3: Quick Manual Commands

If you want to do it all manually:

```bash
# 1. Create repo on GitHub (go to https://github.com/new)
#    - Name: conductor
#    - Don't initialize with anything

# 2. Remove old remote
git remote remove origin 2>/dev/null || true

# 3. Add new remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/conductor.git

# 4. Push everything
git push -u origin main
```

## After Creating the Repository

1. **Set up GitHub Secrets** (for CI/CD):
   - Go to: `https://github.com/YOUR_USERNAME/conductor/settings/secrets/actions`
   - Add these secrets:
     - `NEXT_PUBLIC_SUPABASE_URL`
     - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
     - `SUPABASE_SERVICE_ROLE_KEY`
     - `OPENAI_API_KEY`
     - `GITHUB_TOKEN` (with `workflow` scope this time!)
     - `CURSOR_API_KEY` (when available)

2. **Create Supabase project** (see SETUP.md)

3. **Configure environment**:
   ```bash
   cp .env.local.example .env.local
   # Edit .env.local with your credentials
   ```

## Why Create a New Repo?

If you're having issues with:
- Workflow scope errors
- Existing repository conflicts
- Want a fresh start

Creating a new repository is a clean solution!

