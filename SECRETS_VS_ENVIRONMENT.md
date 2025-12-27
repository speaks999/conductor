# Repository Secrets vs Environment Secrets

## The Issue

Your secrets are currently set as **Environment secrets**, but the workflows need them as **Repository secrets**.

## Why?

- **Repository secrets** are available to all workflows in the repository by default
- **Environment secrets** are only available when a workflow job explicitly specifies an environment

Our workflows don't specify an environment, so they can't access Environment secrets.

## How to Fix

### Step 1: Delete the Environment Secrets

1. Go to: https://github.com/speaks999/conductor/settings/secrets/actions
2. Click on the **"Secrets"** tab
3. In the **"Environment secrets"** section, click on each secret
4. Click **"Delete"** for:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`

### Step 2: Add as Repository Secrets

1. Still on the same page, scroll to **"Repository secrets"** section
2. Click **"New repository secret"**
3. Add each secret:

   **Secret 1:**
   - Name: `NEXT_PUBLIC_SUPABASE_URL`
   - Value: `https://fjsponosnbzzcxkgptzt.supabase.co`
   - Click "Add secret"

   **Secret 2:**
   - Name: `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - Value: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZqc3Bvbm9zbmJ6emN4a2dwdHp0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM5MzgxNDMsImV4cCI6MjA3OTUxNDE0M30.qDIjnemRg4V4xVCBy4YXfjFstH7DOWzSUx2P2cLr2UI`
   - Click "Add secret"

### Step 3: Verify

After adding, you should see:
- ✅ Two secrets in the **"Repository secrets"** section
- ✅ No secrets in the **"Environment secrets"** section (or only ones you want to keep)

### Step 4: Re-run Workflows

1. Go to: https://github.com/speaks999/conductor/actions
2. Click on a failed workflow
3. Click **"Re-run all jobs"**
4. The workflows should now pass! ✅

## When to Use Each Type

### Repository Secrets
- ✅ Use for secrets needed by most/all workflows
- ✅ Available to all workflows by default
- ✅ Simpler setup

### Environment Secrets
- Use when you need different secrets for different environments (e.g., staging vs production)
- Requires adding `environment: <name>` to workflow jobs
- More complex but more flexible

For this project, **Repository secrets** are the right choice.

