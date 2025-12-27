-- Conductor Database Schema
-- This migration creates the core tables for job orchestration
-- Using conductor_ prefix to avoid conflicts with existing tables

-- Jobs table: Top-level job records
CREATE TABLE IF NOT EXISTS conductor_jobs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  repo_url TEXT NOT NULL,
  base_branch TEXT NOT NULL DEFAULT 'main',
  goal TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'planning', 'running', 'paused', 'succeeded', 'failed')),
  github_pr_url TEXT,
  github_branch TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  error_message TEXT
);

-- Tasks table: Individual tasks within jobs
CREATE TABLE IF NOT EXISTS conductor_tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  job_id UUID NOT NULL REFERENCES conductor_jobs(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  objective TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('PLANNER', 'CODER', 'TESTER', 'REVIEWER', 'DOCS', 'FIXER')),
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'ready', 'running', 'succeeded', 'failed', 'retrying')),
  dependencies UUID[] DEFAULT ARRAY[]::UUID[],
  files TEXT[],
  definition_of_done TEXT,
  cursor_run_id TEXT,
  attempt_count INTEGER DEFAULT 0,
  max_attempts INTEGER DEFAULT 2,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  error_message TEXT
);

-- Task events table: Event log for task state changes
CREATE TABLE IF NOT EXISTS conductor_task_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id UUID NOT NULL REFERENCES conductor_tasks(id) ON DELETE CASCADE,
  event_type TEXT NOT NULL CHECK (event_type IN ('created', 'started', 'completed', 'failed', 'retrying', 'paused')),
  metadata JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_conductor_tasks_job_id ON conductor_tasks(job_id);
CREATE INDEX IF NOT EXISTS idx_conductor_tasks_status ON conductor_tasks(status);
CREATE INDEX IF NOT EXISTS idx_conductor_tasks_role ON conductor_tasks(role);
CREATE INDEX IF NOT EXISTS idx_conductor_task_events_task_id ON conductor_task_events(task_id);
CREATE INDEX IF NOT EXISTS idx_conductor_jobs_status ON conductor_jobs(status);

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers to auto-update updated_at
DROP TRIGGER IF EXISTS update_conductor_jobs_updated_at ON conductor_jobs;
CREATE TRIGGER update_conductor_jobs_updated_at BEFORE UPDATE ON conductor_jobs
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_conductor_tasks_updated_at ON conductor_tasks;
CREATE TRIGGER update_conductor_tasks_updated_at BEFORE UPDATE ON conductor_tasks
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Row Level Security (RLS)
ALTER TABLE conductor_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE conductor_tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE conductor_task_events ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Service role can manage conductor_jobs" ON conductor_jobs;
DROP POLICY IF EXISTS "Service role can manage conductor_tasks" ON conductor_tasks;
DROP POLICY IF EXISTS "Service role can manage conductor_task_events" ON conductor_task_events;

-- Allow service role full access
CREATE POLICY "Service role can manage conductor_jobs" ON conductor_jobs
  FOR ALL USING (true);

CREATE POLICY "Service role can manage conductor_tasks" ON conductor_tasks
  FOR ALL USING (true);

CREATE POLICY "Service role can manage conductor_task_events" ON conductor_task_events
  FOR ALL USING (true);

