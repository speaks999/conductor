# Conductor Quick Start

Get Conductor up and running in 5 minutes!

## Prerequisites Check

```bash
# Check Node.js version (need 20+)
node --version

# Check if you have npm
npm --version

# Check if you have git
git --version
```

## Step 1: Install Dependencies

```bash
npm install
```

## Step 2: Set Up Supabase (Choose One)

### Option A: Quick Setup (Supabase Dashboard)

1. Go to [app.supabase.com](https://app.supabase.com) and sign up/login
2. Click "New Project"
3. Fill in:
   - Name: `conductor`
   - Database Password: (save this!)
   - Region: (choose closest)
4. Wait ~2 minutes for project creation
5. Go to **SQL Editor** → New Query
6. Copy/paste contents of `supabase/migrations/001_initial_schema.sql`
7. Click "Run"
8. Go to **Settings** → **API**
9. Copy:
   - Project URL
   - `anon` `public` key
   - `service_role` `secret` key (keep this secret!)

### Option B: Using Supabase CLI

```bash
# Install Supabase CLI
npm install -g supabase

# Login
supabase login

# Run setup script
./scripts/setup-supabase.sh
```

## Step 3: Configure Environment

```bash
# Copy example file
cp .env.local.example .env.local

# Edit with your credentials
# Use your favorite editor (nano, vim, code, etc.)
nano .env.local
```

Required values:
- `NEXT_PUBLIC_SUPABASE_URL` - From Supabase dashboard
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` - From Supabase dashboard
- `SUPABASE_SERVICE_ROLE_KEY` - From Supabase dashboard
- `OPENAI_API_KEY` - Get from [platform.openai.com](https://platform.openai.com/api-keys)
- `GITHUB_TOKEN` - Create at [github.com/settings/tokens](https://github.com/settings/tokens) (needs `repo` scope)

## Step 4: Run the App

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) 🎉

## Step 5: Create Your First Job

1. Click "Create Job" in the dashboard
2. Enter:
   - **Repository URL**: A GitHub repo you have access to
   - **Base Branch**: `main` (or your default branch)
   - **Goal**: Something like "Add a README file with setup instructions"
3. Click "Create Job"
4. Click "Start Job" to begin execution

## Troubleshooting

### "Supabase connection failed"
- Check your `.env.local` file has correct values
- Verify Supabase project is active
- Check network connection

### "OpenAI API error"
- Verify your API key is correct
- Check you have credits/quota available
- Ensure key has proper permissions

### "GitHub branch creation failed"
- Verify `GITHUB_TOKEN` has `repo` scope
- Check you have write access to the repository
- Ensure repository URL is correct format

## Next Steps

- Read [SETUP.md](./SETUP.md) for detailed setup instructions
- Check [IMPLEMENTATION.md](./IMPLEMENTATION.md) for architecture details
- Review [README.md](./README.md) for project overview

## Need Help?

1. Check the troubleshooting section above
2. Review the detailed [SETUP.md](./SETUP.md)
3. Check Supabase and GitHub documentation
4. Verify all environment variables are set correctly

