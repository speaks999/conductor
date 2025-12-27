# Conductor Setup Guide

This guide will help you set up both the GitHub repository and Supabase project for Conductor.

## Prerequisites

- Node.js 20+ installed
- Git installed
- GitHub account
- Supabase account (free tier works)
- OpenAI API key
- GitHub personal access token (for GitHub operations)

## Step 1: Set Up Supabase Project

### Option A: Using Supabase CLI (Recommended)

1. **Install Supabase CLI**:
```bash
npm install -g supabase
```

2. **Login to Supabase**:
```bash
supabase login
```

3. **Run the setup script**:
```bash
chmod +x scripts/setup-supabase.sh
./scripts/setup-supabase.sh
```

4. **Or manually create a project**:
   - Go to [Supabase Dashboard](https://app.supabase.com)
   - Click "New Project"
   - Fill in:
     - Name: `conductor` (or your preferred name)
     - Database Password: (choose a strong password)
     - Region: (choose closest to you)
   - Wait for project to be created (~2 minutes)

5. **Run the migration**:
   - In Supabase Dashboard, go to SQL Editor
   - Copy contents of `supabase/migrations/001_initial_schema.sql`
   - Paste and run it

6. **Get your credentials**:
   - Go to Project Settings > API
   - Copy:
     - Project URL → `NEXT_PUBLIC_SUPABASE_URL`
     - anon/public key → `NEXT_PUBLIC_SUPABASE_ANON_KEY`
     - service_role key → `SUPABASE_SERVICE_ROLE_KEY` (keep this secret!)

### Option B: Using Supabase Dashboard

1. Create project at [app.supabase.com](https://app.supabase.com)
2. Go to SQL Editor
3. Run the migration from `supabase/migrations/001_initial_schema.sql`
4. Get your API keys from Project Settings > API

## Step 2: Set Up GitHub Repository

### Option A: Using GitHub CLI (Recommended)

1. **Install GitHub CLI**:
   - macOS: `brew install gh`
   - Or download from [cli.github.com](https://cli.github.com)

2. **Login to GitHub**:
```bash
gh auth login
```

3. **Run the setup script**:
```bash
chmod +x scripts/setup-github.sh
./scripts/setup-github.sh
```

### Option B: Manual Setup

1. **Create repository on GitHub**:
   - Go to [github.com/new](https://github.com/new)
   - Repository name: `conductor`
   - Description: "Conductor — the control plane for AI-native software delivery"
   - Choose public or private
   - **Don't** initialize with README (we already have one)

2. **Link local repository**:
```bash
git remote add origin https://github.com/YOUR_USERNAME/conductor.git
git branch -M main
git push -u origin main
```

3. **GitHub Repository** (optional):
   - The project works without GitHub integration
   - If you want GitHub features (branches, PRs), set up a repository and configure `GITHUB_TOKEN` in your `.env.local`

## Step 3: Configure Environment Variables

1. **Copy the example file**:
```bash
cp .env.local.example .env.local
```

2. **Edit `.env.local`** with your credentials:
```env
# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key

# OpenAI Configuration
OPENAI_API_KEY=sk-your-openai-key

# Cursor API Configuration (when available)
CURSOR_API_KEY=your_cursor_api_key

# GitHub Configuration
GITHUB_TOKEN=ghp_your_github_token
GITHUB_OWNER=your_username
GITHUB_REPO=conductor

# Application Configuration
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

## Step 4: Install Dependencies and Run

```bash
# Install dependencies
npm install

# Run development server
npm run dev
```

Visit [http://localhost:3000](http://localhost:3000) to see the Conductor dashboard.

## Step 5: Verify Setup

1. **Test Supabase connection**:
   - Create a test job in the dashboard
   - Check Supabase dashboard to see if job was created

2. **Test GitHub integration**:
   - Create a job with a valid GitHub repo URL
   - Check if branch and PR are created

3. **Test Planner**:
   - Create a job with a clear goal
   - Verify tasks are generated

## Troubleshooting

### Supabase Issues

- **Migration fails**: Make sure you're using the correct database (check project settings)
- **RLS errors**: The migration sets up RLS policies, but you may need to adjust them for your use case
- **Connection errors**: Verify your URL and keys are correct

### GitHub Issues

- **Token permissions**: Your GitHub token needs `repo` scope
- **Branch creation fails**: Make sure the token has write access to the repository
- **PR creation fails**: Verify the repository exists and token has permissions

### Cursor API Issues

- **Placeholder endpoints**: The Cursor API adapter uses placeholder endpoints. Replace with actual API when available
- **Webhook not working**: Make sure the webhook URL is accessible (use ngrok for local development)

## Next Steps

1. Review the [IMPLEMENTATION.md](./IMPLEMENTATION.md) for architecture details
2. Customize the planner prompts in `lib/planner.ts`
3. Configure retry logic in `lib/orchestrator.ts`
4. Set up production deployment (Vercel, etc.)

## Support

If you encounter issues:
1. Check the [README.md](./README.md)
2. Review [IMPLEMENTATION.md](./IMPLEMENTATION.md)
3. Check Supabase and GitHub documentation
4. Verify all environment variables are set correctly


