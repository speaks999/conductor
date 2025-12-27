# ⚠️ CRITICAL: package-lock.json is Missing Required Fields

The committed `package-lock.json` is missing the `resolved` and `integrity` fields that npm needs. This is why the workflow is failing.

## The Problem

The last commit removed 129 lines from the lock file, including critical metadata like:
- `resolved` URLs for packages
- `integrity` hashes for package verification

## Fix It Now

Run these commands to regenerate the lock file properly:

```bash
# Delete the broken lock file
rm package-lock.json

# Regenerate it completely
npm install

# Verify it has the required fields
grep -c "resolved" package-lock.json
# Should show a large number (hundreds)

# Verify the AI SDK versions are correct
grep -A 2 '"node_modules/ai"' package-lock.json | head -3
# Should show: "version": "6.0.3"

# Commit and push
git add package-lock.json
git commit -m "Fix package-lock.json: restore resolved and integrity fields"
git push origin main
```

## Why This Happened

The lock file was likely edited manually or generated incorrectly, removing the `resolved` and `integrity` fields that npm requires for `npm ci` to work.

After pushing the fixed lock file, the workflow should pass!

