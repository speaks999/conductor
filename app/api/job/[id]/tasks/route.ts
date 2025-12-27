import { NextRequest, NextResponse } from 'next/server'
import { supabaseAdmin } from '@/lib/supabase'

/**
 * GET /api/job/:id/tasks - Get tasks for a job
 */
export async function GET(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const { data: tasks, error } = await supabaseAdmin
      .from('conductor_tasks')
      .select('*')
      .eq('job_id', params.id)
      .order('created_at', { ascending: true })

    if (error) {
      throw error
    }

    return NextResponse.json({ tasks })
  } catch (error: any) {
    console.error('Error fetching tasks:', error)
    return NextResponse.json(
      { error: error.message || 'Failed to fetch tasks' },
      { status: 500 }
    )
  }
}

