import { NextRequest, NextResponse } from 'next/server'
import { supabaseAdmin } from '@/lib/supabase'
import { Orchestrator } from '@/lib/orchestrator'

/**
 * GET /api/job/:id - Get job details
 */
export async function GET(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const { data: job, error } = await supabaseAdmin
      .from('jobs')
      .select('*')
      .eq('id', params.id)
      .single()

    if (error) {
      throw error
    }

    if (!job) {
      return NextResponse.json(
        { error: 'Job not found' },
        { status: 404 }
      )
    }

    return NextResponse.json({ job })
  } catch (error: any) {
    console.error('Error fetching job:', error)
    return NextResponse.json(
      { error: error.message || 'Failed to fetch job' },
      { status: 500 }
    )
  }
}

