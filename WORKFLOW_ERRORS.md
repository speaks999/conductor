# GitHub Actions Workflow Error Troubleshooting

If your workflows are failing, follow this guide to diagnose and fix the issue.

## Step 1: Check the Error Message

1. Go to: https://github.com/speaks999/conductor/actions
2. Click on the failed workflow run
3. Click on the failed job (e.g., "lint-and-type-check" or "build")
4. Expand the failed step to see the error message

## Common Errors and Fixes

### Error: "Missing secret: NEXT_PUBLIC_SUPABASE_URL"

**Fix:** Add the GitHub Secret

1. Go to: https://github.com/speaks999/conductor/settings/secrets/actions
2. Click "New repository secret"
3. Name: `NEXT_PUBLIC_SUPABASE_URL`
4. Value: `https://fjsponosnbzzcxkgptzt.supabase.co`
5. Click "Add secret"

### Error: "Missing secret: NEXT_PUBLIC_SUPABASE_ANON_KEY"

**Fix:** Add the GitHub Secret

1. Go to: https://github.com/speaks999/conductor/settings/secrets/actions
2. Click "New repository secret"
3. Name: `NEXT_PUBLIC_SUPABASE_ANON_KEY`
4. Value: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZqc3Bvbm9zbmJ6emN4a2dwdHp0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM5MzgxNDMsImV4cCI6MjA3OTUxNDE0M30.qDIjnemRg4V4xVCBy4YXfjFstH7DOWzSUx2P2cLr2UI`
5. Click "Add secret"

### Error: "Dependencies lock file is not found"

**Fix:** This should be resolved now that `package-lock.json` is committed. If you still see this:

1. Make sure `package-lock.json` is in the repository
2. Re-run the workflow

### Error: Build fails with "process.env.NEXT_PUBLIC_SUPABASE_URL is undefined"

**Fix:** The secrets are missing or not set correctly. Follow the steps above to add them.

### Error: Linting or Type Check fails

**Fix:** This is a code issue, not a configuration issue:

1. Check the error message in the workflow logs
2. Fix the linting/type errors locally:
   ```bash
   npm run lint
   npm run type-check
   ```
3. Commit and push the fixes

## Quick Fix Checklist

- [ ] Added `NEXT_PUBLIC_SUPABASE_URL` secret
- [ ] Added `NEXT_PUBLIC_SUPABASE_ANON_KEY` secret
- [ ] `package-lock.json` is in the repository
- [ ] Re-ran the failed workflow after adding secrets

## After Adding Secrets

1. Go to: https://github.com/speaks999/conductor/actions
2. Click on the failed workflow
3. Click "Re-run all jobs" (top right)
4. The workflow should now pass! ✅

## Still Having Issues?

1. **Check the workflow logs** for the specific error message
2. **Verify secrets are set correctly**:
   - Go to: https://github.com/speaks999/conductor/settings/secrets/actions
   - Make sure both secrets are listed
3. **Check secret names** - they must match exactly (case-sensitive):
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`

## Need Help?

If you're still stuck, share:
1. The exact error message from the workflow logs
2. Which step is failing (lint, type-check, or build)
3. Screenshot of your GitHub Secrets page (hide the values!)

