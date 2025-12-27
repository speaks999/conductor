# GitHub Secrets - Quick Reference

Copy these values directly into GitHub Secrets:

## Secret 1: NEXT_PUBLIC_SUPABASE_URL
```
https://fjsponosnbzzcxkgptzt.supabase.co
```

## Secret 2: NEXT_PUBLIC_SUPABASE_ANON_KEY
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZqc3Bvbm9zbmJ6emN4a2dwdHp0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM5MzgxNDMsImV4cCI6MjA3OTUxNDE0M30.qDIjnemRg4V4xVCBy4YXfjFstH7DOWzSUx2P2cLr2UI
```

## Where to Add Them

**⚠️ Important: These must be Repository secrets, NOT Environment secrets!**

1. Go to: https://github.com/speaks999/conductor/settings/secrets/actions
2. Make sure you're on the **"Secrets"** tab
3. Scroll to the **"Repository secrets"** section (NOT "Environment secrets")
4. Click **"New repository secret"**
5. Paste the name and value above
6. Click "Add secret"
7. Repeat for both secrets

**If you already added them as Environment secrets:**
- Delete the Environment secrets
- Add them again as Repository secrets (see steps above)

## After Adding Secrets

1. Go to: https://github.com/speaks999/conductor/actions
2. Click on the failed workflow
3. Click "Re-run all jobs"

Done! ✅

