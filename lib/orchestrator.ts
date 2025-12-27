import { supabaseAdmin, type Job, type Task, type TaskStatus, type JobStatus } from './supabase'
import { cursorAgentAdapter } from './cursor-adapter'

export interface OrchestratorState {
  jobId: string
  status: JobStatus
  tasks: Task[]
}

/**
 * Orchestrator: State machine that manages task execution
 * Responsibilities:
 * - Resolve dependencies
 * - Transition task states
 * - Launch Cursor agents
 * - Handle retries
 * - Finalize jobs
 */
export class Orchestrator {
  private jobId: string
  private pollInterval: number = 5000 // 5 seconds

  constructor(jobId: string) {
    this.jobId = jobId
  }

  /**
   * Start orchestrating a job
   */
  async start(): Promise<void> {
    // Update job status to running
    await this.updateJobStatus('running')

    // Start orchestration loop
    await this.orchestrate()
  }

  /**
   * Main orchestration loop
   */
  private async orchestrate(): Promise<void> {
    while (true) {
      const job = await this.getJob()
      if (!job) break

      // Check if job is complete or failed
      if (job.status === 'succeeded' || job.status === 'failed') {
        break
      }

      // Get all tasks for this job
      const tasks = await this.getTasks()

      // Mark tasks as READY when dependencies are satisfied
      await this.updateReadyTasks(tasks)

      // Launch READY tasks (respect concurrency limits)
      await this.launchReadyTasks(tasks)

      // Check for completion
      const allComplete = tasks.every(t => 
        t.status === 'succeeded' || t.status === 'failed'
      )

      if (allComplete && tasks.length > 0) {
        const hasFailures = tasks.some(t => t.status === 'failed')
        await this.updateJobStatus(hasFailures ? 'failed' : 'succeeded')
        break
      }

      // Wait before next iteration
      await this.sleep(this.pollInterval)
    }
  }

  /**
   * Update tasks to READY when dependencies are satisfied
   */
  private async updateReadyTasks(tasks: Task[]): Promise<void> {
    for (const task of tasks) {
      if (task.status !== 'pending') continue

      // Check if all dependencies are satisfied
      const dependenciesSatisfied = task.dependencies.every(depId => {
        const depTask = tasks.find(t => t.id === depId)
        return depTask?.status === 'succeeded'
      })

      if (dependenciesSatisfied) {
        await this.updateTaskStatus(task.id, 'ready')
      }
    }
  }

  /**
   * Launch tasks that are ready
   */
  private async launchReadyTasks(tasks: Task[]): Promise<void> {
    const readyTasks = tasks.filter(t => t.status === 'ready')
    const maxConcurrency = 3 // Limit concurrent tasks

    // Launch up to maxConcurrency tasks
    const tasksToLaunch = readyTasks.slice(0, maxConcurrency)

    for (const task of tasksToLaunch) {
      await this.launchTask(task)
    }
  }

  /**
   * Launch a single task via Cursor Background Agent
   */
  private async launchTask(task: Task): Promise<void> {
    // Update task status to running
    await this.updateTaskStatus(task.id, 'running')

    // Create task event
    await this.createTaskEvent(task.id, 'started', { task })

    try {
      // Launch Cursor agent
      const cursorRunId = await cursorAgentAdapter.launchTask({
        taskId: task.id,
        title: task.title,
        objective: task.objective,
        role: task.role,
        files: task.files,
        definitionOfDone: task.definition_of_done || '',
        jobId: this.jobId,
      })

      // Store cursor run ID
      await supabaseAdmin
        .from('conductor_tasks')
        .update({ cursor_run_id: cursorRunId })
        .eq('id', task.id)

      // Note: In a real implementation, we'd poll Cursor API or use webhooks
      // to get updates. For now, we'll simulate completion after a delay.
      // This should be replaced with actual webhook handling.

    } catch (error: any) {
      await this.handleTaskFailure(task, error.message)
    }
  }

  /**
   * Handle task failure with retry logic
   */
  private async handleTaskFailure(task: Task, errorMessage: string): Promise<void> {
    const newAttemptCount = task.attempt_count + 1

    if (newAttemptCount >= task.max_attempts) {
      // Max attempts reached, mark as failed
      await this.updateTaskStatus(task.id, 'failed', errorMessage)
      await this.createTaskEvent(task.id, 'failed', { error: errorMessage })
    } else {
      // Retry
      await supabaseAdmin
        .from('conductor_tasks')
        .update({ 
          attempt_count: newAttemptCount,
          status: 'retrying' as TaskStatus,
          error_message: errorMessage
        })
        .eq('id', task.id)

      await this.createTaskEvent(task.id, 'retrying', { 
        attempt: newAttemptCount,
        error: errorMessage 
      })

      // Reset to pending for retry
      await this.sleep(2000) // Brief delay before retry
      await this.updateTaskStatus(task.id, 'pending')
    }
  }

  /**
   * Update task status (called from webhook when Cursor agent completes)
   */
  async updateTaskCompletion(taskId: string, succeeded: boolean, errorMessage?: string): Promise<void> {
    const status: TaskStatus = succeeded ? 'succeeded' : 'failed'
    await this.updateTaskStatus(taskId, status, errorMessage)
    
    const eventType = succeeded ? 'completed' : 'failed'
    await this.createTaskEvent(taskId, eventType, { 
      succeeded,
      error: errorMessage 
    })
  }

  /**
   * Helper methods
   */
  private async getJob(): Promise<Job | null> {
    const { data, error } = await supabaseAdmin
      .from('conductor_jobs')
      .select('*')
      .eq('id', this.jobId)
      .single()

    if (error) throw error
    return data
  }

  private async getTasks(): Promise<Task[]> {
    const { data, error } = await supabaseAdmin
      .from('conductor_tasks')
      .select('*')
      .eq('job_id', this.jobId)
      .order('created_at', { ascending: true })

    if (error) throw error
    return data || []
  }

  private async updateJobStatus(status: JobStatus, errorMessage?: string): Promise<void> {
    const update: any = { status }
    if (status === 'succeeded' || status === 'failed') {
      update.completed_at = new Date().toISOString()
    }
    if (errorMessage) {
      update.error_message = errorMessage
    }

    await supabaseAdmin
      .from('conductor_jobs')
      .update(update)
      .eq('id', this.jobId)
  }

  private async updateTaskStatus(taskId: string, status: TaskStatus, errorMessage?: string): Promise<void> {
    const update: any = { status }
    if (status === 'succeeded' || status === 'failed') {
      update.completed_at = new Date().toISOString()
    }
    if (errorMessage) {
      update.error_message = errorMessage
    }

    await supabaseAdmin
      .from('conductor_tasks')
      .update(update)
      .eq('id', taskId)
  }

  private async createTaskEvent(taskId: string, eventType: string, metadata?: any): Promise<void> {
    await supabaseAdmin
      .from('conductor_task_events')
      .insert({
        task_id: taskId,
        event_type: eventType,
        metadata: metadata || null,
      })
  }

  private sleep(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms))
  }
}

