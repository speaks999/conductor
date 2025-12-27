# Fix GitHub Workflow Scope Issue

You're getting this error because your GitHub token doesn't have the `workflow` scope:

```
refusing to allow an OAuth App to create or update workflow `.github/workflows/ci.yml` without `workflow` scope
```

## Solution 1: Update Your GitHub Token (Recommended)

1. **Go to GitHub Token Settings**:
   - Visit: https://github.com/settings/tokens
   - Or: Settings → Developer settings → Personal access tokens → Tokens (classic)

2. **Create a New Token**:
   - Click "Generate new token" → "Generate new token (classic)"
   - Give it a name: `Conductor Workflow Token`
   - Select these scopes:
     - ✅ `repo` (Full control of private repositories)
     - ✅ `workflow` (Update GitHub Action workflows) ← **This is the important one!**
   - Click "Generate token"
   - **Copy the token immediately** (you won't see it again!)

3. **Update Your Git Credentials**:
   ```bash
   # Option A: Update remote URL with token
   git remote set-url origin https://YOUR_TOKEN@github.com/speaks999/conductor.git
   
   # Option B: Use credential helper (recommended)
   git config --global credential.helper store
   # Then on next push, enter your username and the new token as password
   ```

4. **Push Again**:
   ```bash
   git push origin main
   ```

## Solution 2: Push Without Workflows First

If you want to push everything else first and add workflows later:

```bash
./scripts/push-without-workflows.sh
```

This script will:
1. Temporarily move workflow files
2. Push everything else
3. Restore workflow files
4. Try to push workflows (will fail if token doesn't have scope)

## Solution 3: Add Workflows Manually

1. **Push without workflows**:
   ```bash
   # Temporarily remove workflows
   mkdir -p /tmp/workflows-backup
   mv .github/workflows/*.yml /tmp/workflows-backup/
   
   # Commit and push
   git add .
   git commit -m "Initial commit (without workflows)"
   git push -u origin main
   ```

2. **Add workflows via GitHub UI**:
   - Go to: https://github.com/speaks999/conductor
   - Click "Add file" → "Create new file"
   - Path: `.github/workflows/ci.yml`
   - Copy contents from your local file
   - Commit directly on GitHub

3. **Or update token and push workflows**:
   - After updating your token (Solution 1)
   - Restore workflows: `mv /tmp/workflows-backup/*.yml .github/workflows/`
   - Commit and push: `git add .github/workflows/ && git commit -m "Add workflows" && git push`

## Verify Your Token Has Workflow Scope

Check your current token scopes:
```bash
# This will show what scopes your current credentials have
curl -H "Authorization: token YOUR_TOKEN" https://api.github.com/user
```

Look for `"workflow"` in the response.

## Quick Fix Script

Run this to push without workflows first:

```bash
./scripts/push-without-workflows.sh
```

Then update your token and push workflows separately.


