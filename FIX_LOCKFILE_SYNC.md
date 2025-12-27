# Fix: package-lock.json Out of Sync

The `package-lock.json` file is out of sync with `package.json` after updating to AI SDK v6.

## Quick Fix

Run this command in your terminal:

```bash
./scripts/update-lockfile.sh
```

This will:
1. ✅ Run `npm install` to regenerate the lock file
2. ✅ Commit the updated lock file
3. ✅ Push to GitHub

## Manual Fix (Alternative)

If you prefer to do it manually:

```bash
# Update the lock file
npm install

# Stage and commit
git add package-lock.json
git commit -m "Update package-lock.json for AI SDK v6"
git push origin main
```

## Why This Happened

When we updated `package.json` to use AI SDK v6, the `package-lock.json` file still had the old versions locked. `npm ci` requires these files to be in sync.

## After Pushing

The workflow will automatically re-run and should now:
1. ✅ Install dependencies successfully
2. ✅ Pass linting
3. ✅ Pass type-checking
4. ✅ Build successfully

