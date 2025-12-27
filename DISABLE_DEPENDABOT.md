# Disable Dependabot

If you only want to maintain the `main` branch and don't want Dependabot creating PRs, you can disable it.

## Option 1: Delete Dependabot Configuration File

```bash
rm .github/dependabot.yml
git add .github/dependabot.yml
git commit -m "Disable Dependabot"
git push origin main
```

## Option 2: Use GitHub UI

1. Go to: https://github.com/speaks999/conductor/settings/security
2. Scroll to "Code security and analysis"
3. Find "Dependabot alerts" and "Dependabot version updates"
4. Click "Disable" for both

## Option 3: Clean Up Existing PRs

Run the cleanup script:

```bash
./scripts/cleanup-dependabot.sh
```

This will:
- Close all Dependabot PRs
- Delete all Dependabot branches
- Leave only your `main` branch

## After Disabling

- ✅ No more Dependabot PRs will be created
- ✅ All workflow runs will be green (only main branch)
- ✅ You can manually update dependencies when needed

