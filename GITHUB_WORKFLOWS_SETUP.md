# GitHub Actions Workflows Setup Guide

This guide will help you properly set up GitHub Actions workflows in your repository.

## The Problem

GitHub requires a token with the `workflow` scope to create or update workflow files. Your current token doesn't have this scope, which is why you're seeing:

```
refusing to allow an OAuth App to create or update workflow `.github/workflows/ci.yml` without `workflow` scope
```

## Solution: Create a Token with Workflow Scope

### Step 1: Create a New GitHub Personal Access Token

1. **Go to GitHub Token Settings**:
   - Visit: https://github.com/settings/tokens
   - Or: GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)

2. **Generate New Token**:
   - Click "Generate new token" → "Generate new token (classic)"
   - Give it a descriptive name: `Conductor Workflow Token`
   - Set expiration (recommended: 90 days or custom)

3. **Select Required Scopes**:
   - ✅ **`repo`** - Full control of private repositories
     - This includes: `repo:status`, `repo_deployment`, `public_repo`, `repo:invite`, `security_events`
   - ✅ **`workflow`** - Update GitHub Action workflows ⭐ **This is the critical one!**
   - ✅ **`write:packages`** (optional, if you use GitHub Packages)
   - ✅ **`read:packages`** (optional, if you use GitHub Packages)

4. **Generate and Copy Token**:
   - Click "Generate token" at the bottom
   - **IMPORTANT**: Copy the token immediately (you won't see it again!)
   - It will look like: `ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

### Step 2: Update Your Git Credentials

You have several options:

#### Option A: Update Remote URL with Token (Quick)

```bash
# Replace YOUR_TOKEN with your new token
git remote set-url origin https://YOUR_TOKEN@github.com/speaks999/conductor.git
```

Then push:
```bash
git push origin main
```

#### Option B: Use Git Credential Helper (Recommended)

```bash
# Configure credential helper to store credentials
git config --global credential.helper store

# On next push, you'll be prompted for username and password
# Username: your GitHub username
# Password: paste your new token (not your GitHub password!)
git push origin main
```

#### Option C: Use SSH Instead (Most Secure)

1. **Generate SSH Key** (if you don't have one):
   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   # Press Enter to accept default location
   # Set a passphrase (recommended)
   ```

2. **Add SSH Key to GitHub**:
   ```bash
   # Copy your public key
   cat ~/.ssh/id_ed25519.pub
   ```
   - Go to: https://github.com/settings/keys
   - Click "New SSH key"
   - Paste your public key
   - Save

3. **Update Remote to Use SSH**:
   ```bash
   git remote set-url origin git@github.com:speaks999/conductor.git
   ```

4. **Push**:
   ```bash
   git push origin main
   ```

### Step 3: Push Workflow Files

Once your credentials are updated, push the workflow files:

```bash
# Make sure workflow files are staged
git add .github/workflows/

# Commit if needed
git commit -m "Add GitHub Actions workflows"

# Push
git push origin main
```

## Verify Workflows Are Set Up

1. **Check Repository**:
   - Go to: https://github.com/speaks999/conductor
   - Navigate to: Actions tab
   - You should see the workflows listed

2. **Test the Workflow**:
   - Make a small change and push:
     ```bash
     echo "# Test" >> README.md
     git add README.md
     git commit -m "Test workflow"
     git push origin main
     ```
   - Go to Actions tab and verify the workflow runs

## Set Up GitHub Secrets (For CI/CD)

Your workflows need secrets to run properly. Set them up:

1. **Go to Repository Settings**:
   - Visit: https://github.com/speaks999/conductor/settings/secrets/actions
   - Or: Repository → Settings → Secrets and variables → Actions

2. **Add Required Secrets**:
   Click "New repository secret" for each:

   - **`NEXT_PUBLIC_SUPABASE_URL`**
     - Value: `https://fjsponosnbzzcxkgptzt.supabase.co`
   
   - **`NEXT_PUBLIC_SUPABASE_ANON_KEY`**
     - Value: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZqc3Bvbm9zbmJ6emN4a2dwdHp0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM5MzgxNDMsImV4cCI6MjA3OTUxNDE0M30.qDIjnemRg4V4xVCBy4YXfjFstH7DOWzSUx2P2cLr2UI`
   
   - **`SUPABASE_SERVICE_ROLE_KEY`**
     - Get from: https://supabase.com/dashboard/project/hknjyzhnlgktsxxktpci/settings/api
     - Copy the `service_role` `secret` key
   
   - **`OPENAI_API_KEY`**
     - Get from: https://platform.openai.com/api-keys
     - Format: `sk-...`
   
   - **`GITHUB_TOKEN`** (optional, for GitHub operations)
     - Use the same token you created above, or create a separate one
     - Make sure it has `repo` and `workflow` scopes
   
   - **`CURSOR_API_KEY`** (optional, when available)
     - Will be provided when Cursor API is available

## Quick Setup Script

I've created a script to help you set this up. Run:

```bash
./scripts/setup-github-workflows.sh
```

Or manually follow the steps above.

## Troubleshooting

### "Workflow scope error" persists
- Make sure you're using the new token with `workflow` scope
- Verify the token hasn't expired
- Try removing and re-adding the remote:
  ```bash
  git remote remove origin
  git remote add origin https://YOUR_TOKEN@github.com/speaks999/conductor.git
  git push origin main
  ```

### "Permission denied" when pushing
- Verify your token has `repo` scope
- Check that the token hasn't expired
- Make sure you're using the token as the password, not your GitHub password

### Workflows not showing in Actions tab
- Make sure the `.github/workflows/` directory is in your repository
- Check that the workflow files have `.yml` or `.yaml` extension
- Verify the workflow files are valid YAML

### Workflows fail to run
- Check that all required secrets are set
- Verify the workflow syntax is correct
- Check the Actions tab for error messages

## Security Best Practices

1. **Never commit tokens to git**:
   - Always use GitHub Secrets for sensitive data
   - Use `.env.local` for local development (already in `.gitignore`)

2. **Use fine-grained tokens when possible**:
   - GitHub now supports fine-grained personal access tokens
   - These allow more granular permissions

3. **Rotate tokens regularly**:
   - Set expiration dates on tokens
   - Rotate every 90 days or as needed

4. **Use SSH keys for long-term access**:
   - More secure than HTTPS tokens
   - Easier to manage

## Next Steps

After workflows are set up:

1. ✅ Workflows pushed to repository
2. ✅ GitHub Secrets configured
3. ⏳ Test workflows by making a commit
4. ⏳ Monitor workflow runs in Actions tab
5. ⏳ Set up branch protection rules (optional)

## Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Personal Access Tokens Guide](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
- [Workflow Syntax Reference](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)

