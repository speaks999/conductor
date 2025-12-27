import { NextRequest, NextResponse } from 'next/server'
import { supabaseAdmin } from '@/lib/supabase'
import { Orchestrator } from '@/lib/orchestrator'
import { githubAdapter, GitHubAdapter } from '@/lib/github-adapter'

/**
 * POST /api/job/:id/run - Start job execution
 */
export async function POST(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    // Get job
    const { data: job, error: jobError } = await supabaseAdmin
      .from('conductor_jobs')
      .select('*')
      .eq('id', params.id)
      .single()

    if (jobError || !job) {
      return NextResponse.json(
        { error: 'Job not found' },
        { status: 404 }
      )
    }

    if (job.status !== 'pending') {
      return NextResponse.json(
        { error: `Job is not in pending state (current: ${job.status})` },
        { status: 400 }
      )
    }

    // Create PR if branch exists and PR doesn't exist yet
    if (job.github_branch && !job.github_pr_url) {
      try {
        const { owner, repo } = GitHubAdapter.parseRepoUrl(job.repo_url)
        githubAdapter['config'] = {
          token: process.env.GITHUB_TOKEN!,
          owner,
          repo,
        }

        const prUrl = await githubAdapter.createPR({
          jobId: job.id,
          title: `Conductor: ${job.goal.substring(0, 100)}`,
          body: `This PR was created by Conductor to implement: ${job.goal}`,
          baseBranch: job.base_branch,
          headBranch: job.github_branch,
        })

        await supabaseAdmin
          .from('conductor_jobs')
          .update({ github_pr_url: prUrl })
          .eq('id', job.id)
      } catch (error: any) {
        console.error('Failed to create PR:', error.message)
        // Continue without PR
      }
    }

    // Start orchestrator (non-blocking)
    const orchestrator = new Orchestrator(params.id)
    orchestrator.start().catch(error => {
      console.error('Orchestrator error:', error)
    })

    return NextResponse.json({ 
      message: 'Job started',
      job_id: params.id 
    })
  } catch (error: any) {
    console.error('Error starting job:', error)
    return NextResponse.json(
      { error: error.message || 'Failed to start job' },
      { status: 500 }
    )
  }
}

