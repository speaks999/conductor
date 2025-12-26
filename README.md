# Conductor

**Conductor — the control plane for AI-native software delivery.**

Conductor orchestrates agents across the entire SDLC, from intent to production. It uses Cursor Background Agents for execution, Vercel AI SDK v6 for reasoning, and Supabase for state management.

**Repository**: [https://github.com/speaks999/conductor](https://github.com/speaks999/conductor)

## Architecture

- **Product**: Conductor
- **Execution**: Cursor Background Agent
- **Orchestration**: Conductor Orchestrator (Node/TS)
- **Reasoning**: Vercel AI SDK v6
- **State**: Supabase
- **UI**: Next.js + Square UI
- **CI/Gate**: GitHub Actions

## Core Components

### Planner
Uses Vercel AI SDK v6's `generateObject` to create structured task DAGs from high-level goals. The planner only creates structure, never writes code.

### Orchestrator
State machine that:
- Resolves task dependencies
- Manages task state transitions
- Launches Cursor Background Agents
- Handles retries and failures
- Finalizes jobs

### Cursor Background Agent Adapter
Interface to Cursor's Background Agent API for executing tasks.

### GitHub Adapter
Manages branches, PRs, and commits for job execution.

## Getting Started

### Quick Setup

1. **Connect to GitHub repository** (if not already cloned):
```bash
./scripts/connect-github.sh
./scripts/push-initial.sh
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

4. **Set up Supabase**:
- Create a new Supabase project at [app.supabase.com](https://app.supabase.com)
- Run the migration in `supabase/migrations/001_initial_schema.sql`
- Get your API keys from Settings > API

5. **Run the development server**:
```bash
npm run dev
```

For detailed setup instructions, see [SETUP.md](./SETUP.md) or [QUICKSTART.md](./QUICKSTART.md).

## Database Schema

- `jobs`: Top-level job records
- `tasks`: Individual tasks within jobs
- `task_events`: Event log for task state changes

## API Endpoints

- `POST /api/job` - Create a new job
- `GET /api/job/:id` - Get job details
- `GET /api/job/:id/tasks` - Get tasks for a job
- `POST /api/job/:id/run` - Start job execution
- `POST /api/webhook/cursor` - Webhook for Cursor agent updates

## License

MIT

