# GitHub Repository Setup

Your GitHub repository has been created at: **https://github.com/speaks999/conductor**

## Connect Your Local Repository

Run these commands to connect your local code to the GitHub repository:

```bash
# Option 1: Use the setup script (recommended)
./scripts/connect-github.sh
./scripts/push-initial.sh

# Option 2: Manual setup
git init
git branch -M main
git remote add origin https://github.com/speaks999/conductor.git
git add .
git commit -m "Initial commit: Conductor application"
git push -u origin main
```

## Set Up GitHub Secrets

For CI/CD to work, you need to add secrets in GitHub:

1. Go to: https://github.com/speaks999/conductor/settings/secrets/actions
2. Click "New repository secret"
3. Add these secrets:

### Required Secrets

- **NEXT_PUBLIC_SUPABASE_URL**
  - Get from: Supabase Dashboard > Settings > API > Project URL

- **NEXT_PUBLIC_SUPABASE_ANON_KEY**
  - Get from: Supabase Dashboard > Settings > API > anon public key

- **SUPABASE_SERVICE_ROLE_KEY**
  - Get from: Supabase Dashboard > Settings > API > service_role secret key
  - ⚠️ Keep this secret! Never commit it.

- **OPENAI_API_KEY**
  - Get from: [platform.openai.com/api-keys](https://platform.openai.com/api-keys)
  - Format: `sk-...`

- **GITHUB_TOKEN**
  - Create at: [github.com/settings/tokens](https://github.com/settings/tokens)
  - Needs `repo` scope for full access
  - Format: `ghp_...`

- **CURSOR_API_KEY** (optional, when available)
  - Will be provided when Cursor API is available

## Verify Setup

After pushing, you should see:

1. ✅ All files in the repository
2. ✅ GitHub Actions workflows in `.github/workflows/`
3. ✅ CI workflow runs on push/PR

## Next Steps

1. ✅ Repository connected
2. ⏳ Set up GitHub Secrets (see above)
3. ⏳ Create Supabase project (see [SETUP.md](./SETUP.md))
4. ⏳ Configure `.env.local` with your credentials
5. ⏳ Run `npm run dev` to start development

## Troubleshooting

### "Permission denied" when pushing
- Make sure you're authenticated with GitHub
- Check your SSH keys or use HTTPS with a personal access token

### "Repository not found"
- Verify the repository exists at https://github.com/speaks999/conductor
- Check you have write access to the repository

### CI/CD not running
- Make sure GitHub Secrets are configured
- Check Actions tab for error messages
- Verify workflow files are in `.github/workflows/`

