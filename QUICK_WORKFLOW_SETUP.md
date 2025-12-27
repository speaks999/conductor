# Quick Workflow Setup (5 Minutes)

Fastest way to get GitHub Actions workflows working:

## Step 1: Create Token (2 minutes)

1. Go to: https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Name: `Conductor Workflow`
4. Check: ✅ `repo` and ✅ `workflow`
5. Generate and **copy the token** (starts with `ghp_`)

## Step 2: Update Git Credentials (30 seconds)

```bash
# Replace YOUR_TOKEN with the token you just copied
git remote set-url origin https://YOUR_TOKEN@github.com/speaks999/conductor.git
```

## Step 3: Push Workflows (30 seconds)

```bash
git add .github/workflows/
git commit -m "Add GitHub Actions workflows"
git push origin main
```

## Step 4: Verify (1 minute)

1. Go to: https://github.com/speaks999/conductor/actions
2. You should see your workflows listed
3. Make a test commit to trigger them

## Done! ✅

For detailed instructions, see [GITHUB_WORKFLOWS_SETUP.md](./GITHUB_WORKFLOWS_SETUP.md)

