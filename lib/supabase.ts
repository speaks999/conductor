import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
const supabaseServiceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY

// Validate environment variables
if (!supabaseUrl) {
  throw new Error(
    'Missing NEXT_PUBLIC_SUPABASE_URL environment variable. ' +
    'Please create a .env.local file with your Supabase credentials. ' +
    'See SETUP.md or SUPABASE_SETUP.md for instructions.'
  )
}

if (!supabaseAnonKey) {
  throw new Error(
    'Missing NEXT_PUBLIC_SUPABASE_ANON_KEY environment variable. ' +
    'Please create a .env.local file with your Supabase credentials. ' +
    'See SETUP.md or SUPABASE_SETUP.md for instructions.'
  )
}

if (!supabaseServiceRoleKey) {
  throw new Error(
    'Missing SUPABASE_SERVICE_ROLE_KEY environment variable. ' +
    'Please create a .env.local file with your Supabase credentials. ' +
    'See SETUP.md or SUPABASE_SETUP.md for instructions.'
  )
}

// Client for client-side operations
export const supabase = createClient(supabaseUrl, supabaseAnonKey)

// Admin client for server-side operations
export const supabaseAdmin = createClient(supabaseUrl, supabaseServiceRoleKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
})

// Database types
export type JobStatus = 'pending' | 'planning' | 'running' | 'paused' | 'succeeded' | 'failed'
export type TaskStatus = 'pending' | 'ready' | 'running' | 'succeeded' | 'failed' | 'retrying'
export type TaskRole = 'PLANNER' | 'CODER' | 'TESTER' | 'REVIEWER' | 'DOCS' | 'FIXER'
export type TaskEventType = 'created' | 'started' | 'completed' | 'failed' | 'retrying' | 'paused'

export interface Job {
  id: string
  repo_url: string
  base_branch: string
  goal: string
  status: JobStatus
  github_pr_url: string | null
  github_branch: string | null
  created_at: string
  updated_at: string
  completed_at: string | null
  error_message: string | null
}

export interface Task {
  id: string
  job_id: string
  title: string
  objective: string
  role: TaskRole
  status: TaskStatus
  dependencies: string[]
  files: string[]
  definition_of_done: string | null
  cursor_run_id: string | null
  attempt_count: number
  max_attempts: number
  created_at: string
  updated_at: string
  completed_at: string | null
  error_message: string | null
}

export interface TaskEvent {
  id: string
  task_id: string
  event_type: TaskEventType
  metadata: Record<string, any> | null
  created_at: string
}


