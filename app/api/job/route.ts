import { NextRequest, NextResponse } from 'next/server'
import { supabaseAdmin } from '@/lib/supabase'
import { createPlan, generateTaskId } from '@/lib/planner'
import { Orchestrator } from '@/lib/orchestrator'
import { githubAdapter, GitHubAdapter } from '@/lib/github-adapter'

/**
 * POST /api/job - Create a new job
 */
export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const { repo_url, base_branch = 'main', goal } = body

    if (!repo_url || !goal) {
      return NextResponse.json(
        { error: 'repo_url and goal are required' },
        { status: 400 }
      )
    }

    // Create job record
    const { data: job, error: jobError } = await supabaseAdmin
      .from('conductor_jobs')
      .insert({
        repo_url,
        base_branch,
        goal,
        status: 'planning',
      })
      .select()
      .single()

    if (jobError) {
      throw jobError
    }

    // Create GitHub branch
    let githubBranch: string | null = null
    try {
      const { owner, repo } = GitHubAdapter.parseRepoUrl(repo_url)
      githubAdapter['config'] = {
        token: process.env.GITHUB_TOKEN!,
        owner,
        repo,
      }
      githubBranch = await githubAdapter.createJobBranch(job.id)
    } catch (error: any) {
      console.error('Failed to create GitHub branch:', error.message)
      // Continue without branch - job can still proceed
    }

    // Update job with branch
    if (githubBranch) {
      await supabaseAdmin
        .from('conductor_jobs')
        .update({ github_branch: githubBranch })
        .eq('id', job.id)
    }

    // Generate plan using Planner
    const plan = await createPlan({
      repoUrl: repo_url,
      baseBranch: base_branch,
      goal,
    })

    // Create tasks from plan
    const taskInserts = []
    const taskIdMap = new Map<string, string>()

    for (const phase of plan.phases) {
      for (const taskPlan of phase.tasks) {
        const taskId = generateTaskId()
        taskIdMap.set(taskPlan.id, taskId)

        taskInserts.push({
          id: taskId,
          job_id: job.id,
          title: taskPlan.title,
          objective: taskPlan.objective,
          role: taskPlan.role,
          dependencies: taskPlan.dependencies.map(depId => taskIdMap.get(depId)).filter(Boolean) as string[],
          files: taskPlan.files,
          definition_of_done: taskPlan.definition_of_done,
          status: 'pending',
        })
      }
    }

    // Insert all tasks
    if (taskInserts.length > 0) {
      const { error: tasksError } = await supabaseAdmin
        .from('conductor_tasks')
        .insert(taskInserts)

      if (tasksError) {
        throw tasksError
      }
    }

    // Update job status to pending (ready to run)
    await supabaseAdmin
      .from('conductor_jobs')
      .update({ status: 'pending' })
      .eq('id', job.id)

    return NextResponse.json({ job: { ...job, github_branch: githubBranch } })
  } catch (error: any) {
    console.error('Error creating job:', error)
    return NextResponse.json(
      { error: error.message || 'Failed to create job' },
      { status: 500 }
    )
  }
}

/**
 * GET /api/job - List all jobs
 */
export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const status = searchParams.get('status')

    let query = supabaseAdmin
      .from('conductor_jobs')
      .select('*')
      .order('created_at', { ascending: false })

    if (status) {
      query = query.eq('status', status)
    }

    const { data: jobs, error } = await query

    if (error) {
      throw error
    }

    return NextResponse.json({ jobs })
  } catch (error: any) {
    console.error('Error fetching jobs:', error)
    return NextResponse.json(
      { error: error.message || 'Failed to fetch jobs' },
      { status: 500 }
    )
  }
}

