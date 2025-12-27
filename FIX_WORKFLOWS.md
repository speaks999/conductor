# Fix GitHub Actions Workflows

Your workflows are failing because they need GitHub Secrets to access Supabase during the build process.

## Quick Fix (5 minutes)

### Step 1: Add GitHub Secrets

1. Go to your repository settings:
   ```
   https://github.com/speaks999/conductor/settings/secrets/actions
   ```

2. Click **"New repository secret"** and add these secrets one by one:

   **Secret 1: `NEXT_PUBLIC_SUPABASE_URL`**
   - Name: `NEXT_PUBLIC_SUPABASE_URL`
   - Value: `https://fjsponosnbzzcxkgptzt.supabase.co`
   - Click "Add secret"

   **Secret 2: `NEXT_PUBLIC_SUPABASE_ANON_KEY`**
   - Name: `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - Value: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZqc3Bvbm9zbmJ6emN4a2dwdHp0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM5MzgxNDMsImV4cCI6MjA3OTUxNDE0M30.qDIjnemRg4V4xVCBy4YXfjFstH7DOWzSUx2P2cLr2UI`
   - Click "Add secret"

   **Secret 3: `SUPABASE_SERVICE_ROLE_KEY`** (Optional for CI, but recommended)
   - Name: `SUPABASE_SERVICE_ROLE_KEY`
   - Value: Get this from your Supabase dashboard:
     - Go to: https://supabase.com/dashboard/project/hknjyzhnlgktsxxktpci/settings/api
     - Copy the `service_role` `secret` key
   - Click "Add secret"

### Step 2: Re-run the Workflows

After adding the secrets:

1. Go to the Actions tab:
   ```
   https://github.com/speaks999/conductor/actions
   ```

2. Click on the failed workflow run (e.g., "CI #1")

3. Click **"Re-run all jobs"** in the top right

4. The workflows should now pass! ✅

## What Was Wrong?

The workflows were trying to build your Next.js app, which requires:
- `NEXT_PUBLIC_SUPABASE_URL` - Your Supabase project URL
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` - Your public Supabase API key

These are needed at build time because Next.js embeds them into the client-side bundle.

## Verify It's Working

After adding secrets and re-running:

1. ✅ **CI Workflow** should pass:
   - Linting
   - Type checking
   - Building

2. ✅ **Deploy Workflow** should pass:
   - Building (ready for deployment)

## Optional: Add More Secrets

For full functionality, you may also want to add:

- `OPENAI_API_KEY` - For the Planner service
- `GITHUB_TOKEN` - For GitHub operations (with `workflow` scope)
- `CURSOR_API_KEY` - For Cursor agent integration (when available)

But these aren't required for the workflows to pass - they're only needed when running the app.

## Troubleshooting

**If workflows still fail after adding secrets:**

1. Check the workflow logs for specific error messages
2. Make sure secret names match exactly (case-sensitive)
3. Verify the Supabase URL and keys are correct
4. Check that the secrets were added to the correct repository

## Next Steps

Once workflows are passing:
- ✅ Your CI/CD pipeline is working
- ✅ Every push will automatically lint, type-check, and build
- ✅ Ready to add deployment (Vercel, etc.)

