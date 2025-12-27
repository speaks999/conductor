# Force Update package-lock.json

If the workflow is still failing, try this to force regenerate the lock file:

## Steps

1. **Delete the lock file and regenerate:**
   ```bash
   rm package-lock.json
   npm install
   ```

2. **Commit and push:**
   ```bash
   git add package-lock.json
   git commit -m "Force regenerate package-lock.json for AI SDK v6"
   git push origin main
   ```

3. **Verify the workflow is using the latest commit:**
   - Go to: https://github.com/speaks999/conductor/actions
   - Make sure the latest workflow run is from the commit you just pushed
   - If not, manually trigger a new run

## Alternative: Check Current Lock File

If you want to verify the lock file is correct:

```bash
# Check AI SDK version in lock file
grep -A 2 '"node_modules/ai"' package-lock.json | head -5

# Check @ai-sdk/openai version
grep -A 2 '"node_modules/@ai-sdk/openai"' package-lock.json | head -5
```

You should see:
- `ai@6.0.3` (or similar v6.x)
- `@ai-sdk/openai@1.3.24` (or similar v1.x)

