# Conductor Implementation Summary

This document summarizes the Conductor application implementation based on the plan from the ChatGPT conversation.

## Architecture Overview

Conductor is built as a **control plane for AI-native software delivery** that orchestrates Cursor Background Agents across the entire SDLC.

### Technology Stack

- **Product**: Conductor
- **Execution**: Cursor Background Agent
- **Orchestration**: Conductor Orchestrator (Node/TS)
- **Reasoning**: Vercel AI SDK v6
- **State**: Supabase
- **UI**: Next.js + Tailwind CSS
- **CI/Gate**: GitHub Actions (to be configured)

## Core Components Implemented

### 1. Database Schema (Supabase)

Located in `supabase/migrations/001_initial_schema.sql`:

- **jobs**: Top-level job records with status tracking
- **tasks**: Individual tasks within jobs with dependencies
- **task_events**: Event log for task state changes

Features:
- Row Level Security (RLS) enabled
- Auto-updating timestamps
- Proper indexes for performance

### 2. Planner Service (`lib/planner.ts`)

Uses Vercel AI SDK v6's `generateObject` to create structured task DAGs:

- Input: repo URL, base branch, goal
- Output: Structured JSON with phases and tasks
- **Critical**: Planner only creates structure, never writes code
- Uses OpenAI GPT-4 Turbo with structured output schema

### 3. Orchestrator (`lib/orchestrator.ts`)

State machine that manages task execution:

- Resolves task dependencies
- Transitions task states (pending → ready → running → succeeded/failed)
- Launches Cursor Background Agents
- Handles retries (max attempts configurable)
- Finalizes jobs when all tasks complete

### 4. Cursor Background Agent Adapter (`lib/cursor-adapter.ts`)

Interface to Cursor's Background Agent API:

- Launches agents with role-specific prompts
- Tracks Cursor run IDs
- Handles different agent roles (CODER, TESTER, REVIEWER, DOCS, FIXER)

**Note**: Currently uses placeholder API endpoints. Replace with actual Cursor API when available.

### 5. GitHub Adapter (`lib/github-adapter.ts`)

Manages GitHub operations:

- Creates job branches (`conductor/{jobId}`)
- Creates PRs automatically
- Adds PR comments for progress updates
- Parses repo URLs to extract owner/repo

### 6. API Endpoints

All located in `app/api/`:

- `POST /api/job` - Create a new job (triggers planning)
- `GET /api/job` - List all jobs
- `GET /api/job/:id` - Get job details
- `GET /api/job/:id/tasks` - Get tasks for a job
- `POST /api/job/:id/run` - Start job execution
- `POST /api/webhook/cursor` - Webhook for Cursor agent updates

### 7. Dashboard UI

Built with Next.js and Tailwind CSS:

- **Home Page** (`app/page.tsx`): List all jobs, create new jobs
- **Job Detail Page** (`app/job/[id]/page.tsx`): View job details, tasks, and status

Features:
- Real-time polling for job/task updates
- Status indicators with color coding
- Task dependency visualization
- GitHub PR links

## Key Design Decisions

### 1. Separation of Concerns

- **Vercel AI SDK v6**: Used ONLY for reasoning (planning, review, analysis)
- **Orchestrator**: Handles state machine logic, scheduling, retries
- **Supabase**: Single source of truth for state
- **Cursor Agents**: Execution workers

### 2. Planner Contract

The planner outputs structured JSON, never prose. This ensures:
- Predictable task structure
- Easy dependency resolution
- Clear task definitions

### 3. Single PR per Job

MVP uses one PR per job to:
- Simplify merge logic
- Reduce merge conflicts
- Easier retries

### 4. Retry Strategy

- Default max attempts: 2
- Failed tasks increment attempt count
- Status transitions: failed → retrying → pending
- Non-critical tasks don't fail the entire job

## Setup Instructions

1. **Install dependencies**:
```bash
npm install
```

2. **Set up environment variables**:
```bash
cp .env.local.example .env.local
# Edit .env.local with your credentials:
# - Supabase URL and keys
# - OpenAI API key
# - Cursor API key (when available)
# - GitHub token
```

3. **Set up Supabase**:
- Create a new Supabase project
- Run the migration: `supabase/migrations/001_initial_schema.sql`
- Configure RLS policies (currently allows service role full access)

4. **Run the development server**:
```bash
npm run dev
```

## Next Steps / TODO

1. **Streaming Support**: Add real-time streaming for planning and task updates using Vercel AI SDK v6 streams
2. **Cursor API Integration**: Replace placeholder Cursor API calls with actual implementation
3. **Webhook Handling**: Implement proper webhook handling for Cursor agent completion
4. **Error Handling**: Add comprehensive error handling and retry logic
5. **Testing**: Add unit and integration tests
6. **Authentication**: Add user authentication (Supabase Auth)
7. **Multi-tenant Support**: Add support for multiple users/organizations
8. **CI/CD Integration**: Add GitHub Actions for automated testing

## File Structure

```
conductor/
├── app/
│   ├── api/
│   │   ├── job/
│   │   │   ├── route.ts          # Create/list jobs
│   │   │   └── [id]/
│   │   │       ├── route.ts       # Get job details
│   │   │       ├── tasks/route.ts # Get tasks
│   │   │       └── run/route.ts   # Start job
│   │   └── webhook/
│   │       └── cursor/route.ts   # Cursor webhook
│   ├── job/[id]/page.tsx         # Job detail page
│   ├── layout.tsx
│   ├── page.tsx                   # Home page
│   └── globals.css
├── lib/
│   ├── supabase.ts               # Supabase client & types
│   ├── planner.ts                # Planner service
│   ├── orchestrator.ts           # Orchestrator state machine
│   ├── cursor-adapter.ts         # Cursor API adapter
│   └── github-adapter.ts         # GitHub API adapter
├── supabase/
│   └── migrations/
│       └── 001_initial_schema.sql
├── package.json
├── tsconfig.json
├── tailwind.config.js
├── next.config.js
└── README.md
```

## Notes

- The application follows the plan from the ChatGPT conversation closely
- All core components are implemented
- The UI is functional but can be enhanced with Square UI components if desired
- Cursor API integration is placeholder - needs actual API documentation
- The orchestrator uses polling - can be enhanced with Supabase Realtime subscriptions

