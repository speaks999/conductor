import { NextRequest, NextResponse } from 'next/server'
import { supabaseAdmin } from '@/lib/supabase'
import { Orchestrator } from '@/lib/orchestrator'

/**
 * POST /api/webhook/cursor - Webhook for Cursor agent updates
 */
export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const { taskId, runId, status, result, error } = body

    if (!taskId || !runId) {
      return NextResponse.json(
        { error: 'taskId and runId are required' },
        { status: 400 }
      )
    }

    // Get task to find job
    const { data: task, error: taskError } = await supabaseAdmin
      .from('conductor_tasks')
      .select('*, job_id')
      .eq('id', taskId)
      .single()

    if (taskError || !task) {
      return NextResponse.json(
        { error: 'Task not found' },
        { status: 404 }
      )
    }

    // Update task based on status
    if (status === 'completed') {
      const orchestrator = new Orchestrator(task.job_id)
      await orchestrator.updateTaskCompletion(taskId, true)
    } else if (status === 'failed') {
      const orchestrator = new Orchestrator(task.job_id)
      await orchestrator.updateTaskCompletion(taskId, false, error)
    }

    return NextResponse.json({ 
      message: 'Webhook processed',
      taskId 
    })
  } catch (error: any) {
    console.error('Error processing webhook:', error)
    return NextResponse.json(
      { error: error.message || 'Failed to process webhook' },
      { status: 500 }
    )
  }
}

