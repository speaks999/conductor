# Conductor

**Conductor — the control plane for AI-native software delivery.**

Conductor orchestrates agents across the entire SDLC, from intent to production. It uses Cursor Background Agents for execution, Vercel AI SDK v6 for reasoning, and Supabase for state management.

## 🚀 Quick Start

1. **Clone the repository**:
```bash
git clone https://github.com/speaks999/conductor.git
cd conductor
```

2. **Install dependencies**:
```bash
npm install
```

3. **Set up environment variables**:
```bash
cp .env.local.example .env.local
# Edit .env.local with your credentials
```

4. **Set up Supabase** (see [SETUP.md](./SETUP.md) for details):
   - Create a project at [app.supabase.com](https://app.supabase.com)
   - Run the migration from `supabase/migrations/001_initial_schema.sql`
   - Get your API keys

5. **Run the development server**:
```bash
npm run dev
```

Visit [http://localhost:3000](http://localhost:3000) to see the Conductor dashboard.

## 📚 Documentation

- **[QUICKSTART.md](./QUICKSTART.md)** - Get started in 5 minutes
- **[SETUP.md](./SETUP.md)** - Detailed setup instructions
- **[IMPLEMENTATION.md](./IMPLEMENTATION.md)** - Architecture and implementation details
- **[README.md](./README.md)** - Project overview

## 🏗️ Architecture

- **Product**: Conductor
- **Execution**: Cursor Background Agent
- **Orchestration**: Conductor Orchestrator (Node/TS)
- **Reasoning**: Vercel AI SDK v6
- **State**: Supabase
- **UI**: Next.js + Tailwind CSS
- **CI/Gate**: GitHub Actions

## 🔧 Setup Scripts

- `./scripts/connect-github.sh` - Connect to GitHub repository
- `./scripts/push-initial.sh` - Push initial commit
- `./scripts/setup-supabase.sh` - Set up Supabase project
- `./scripts/setup-github.sh` - Set up GitHub repository
- `./scripts/quick-setup.sh` - Quick setup wizard

## 📝 License

MIT


