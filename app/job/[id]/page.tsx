'use client'

import { useState, useEffect, useCallback } from 'react'
import { useParams } from 'next/navigation'
import Link from 'next/link'

interface Job {
  id: string
  repo_url: string
  base_branch: string
  goal: string
  status: string
  github_pr_url: string | null
  github_branch: string | null
  created_at: string
  updated_at: string
  completed_at: string | null
  error_message: string | null
}

interface Task {
  id: string
  job_id: string
  title: string
  objective: string
  role: string
  status: string
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

export default function JobPage() {
  const params = useParams()
  const jobId = params.id as string
  const [job, setJob] = useState<Job | null>(null)
  const [tasks, setTasks] = useState<Task[]>([])
  const [loading, setLoading] = useState(true)

  const fetchJob = useCallback(async () => {
    try {
      const response = await fetch(`/api/job/${jobId}`)
      const data = await response.json()
      setJob(data.job)
    } catch (error) {
      console.error('Error fetching job:', error)
    } finally {
      setLoading(false)
    }
  }, [jobId])

  const fetchTasks = useCallback(async () => {
    try {
      const response = await fetch(`/api/job/${jobId}/tasks`)
      const data = await response.json()
      setTasks(data.tasks || [])
    } catch (error) {
      console.error('Error fetching tasks:', error)
    }
  }, [jobId])

  useEffect(() => {
    fetchJob()
    fetchTasks()
    // Poll for updates every 5 seconds
    const interval = setInterval(() => {
      fetchJob()
      fetchTasks()
    }, 5000)
    return () => clearInterval(interval)
  }, [jobId, fetchJob, fetchTasks])

  const handleRunJob = async () => {
    try {
      const response = await fetch(`/api/job/${jobId}/run`, {
        method: 'POST',
      })

      if (response.ok) {
        fetchJob()
        fetchTasks()
      } else {
        const error = await response.json()
        alert(`Error: ${error.error}`)
      }
    } catch (error) {
      console.error('Error running job:', error)
      alert('Failed to start job')
    }
  }

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'succeeded':
        return 'bg-green-100 text-green-800'
      case 'failed':
        return 'bg-red-100 text-red-800'
      case 'running':
        return 'bg-blue-100 text-blue-800'
      case 'ready':
        return 'bg-yellow-100 text-yellow-800'
      case 'retrying':
        return 'bg-orange-100 text-orange-800'
      default:
        return 'bg-gray-100 text-gray-800'
    }
  }

  const getRoleColor = (role: string) => {
    switch (role) {
      case 'CODER':
        return 'bg-blue-100 text-blue-800'
      case 'TESTER':
        return 'bg-purple-100 text-purple-800'
      case 'REVIEWER':
        return 'bg-yellow-100 text-yellow-800'
      case 'DOCS':
        return 'bg-green-100 text-green-800'
      case 'FIXER':
        return 'bg-red-100 text-red-800'
      default:
        return 'bg-gray-100 text-gray-800'
    }
  }

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <p className="text-gray-600">Loading job...</p>
      </div>
    )
  }

  if (!job) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <p className="text-gray-600 mb-4">Job not found</p>
          <Link href="/" className="text-blue-600 hover:underline">
            Back to Jobs
          </Link>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-6">
          <Link href="/" className="text-blue-600 hover:underline mb-4 inline-block">
            ← Back to Jobs
          </Link>
        </div>

        <div className="bg-white p-6 rounded-lg shadow mb-6">
          <div className="flex justify-between items-start mb-4">
            <div className="flex-1">
              <h1 className="text-3xl font-bold text-gray-900 mb-2">{job.goal}</h1>
              <div className="flex items-center gap-3 mb-4">
                <span className={`px-3 py-1 rounded text-sm font-medium ${getStatusColor(job.status)}`}>
                  {job.status}
                </span>
                {job.status === 'pending' && (
                  <button
                    onClick={handleRunJob}
                    className="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700"
                  >
                    Start Job
                  </button>
                )}
              </div>
              <div className="space-y-2 text-sm text-gray-600">
                <p><strong>Repository:</strong> {job.repo_url}</p>
                <p><strong>Base Branch:</strong> {job.base_branch}</p>
                {job.github_branch && (
                  <p><strong>Branch:</strong> {job.github_branch}</p>
                )}
                {job.github_pr_url && (
                  <p>
                    <strong>PR:</strong>{' '}
                    <a
                      href={job.github_pr_url}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="text-blue-600 hover:underline"
                    >
                      {job.github_pr_url}
                    </a>
                  </p>
                )}
                <p><strong>Created:</strong> {new Date(job.created_at).toLocaleString()}</p>
                {job.completed_at && (
                  <p><strong>Completed:</strong> {new Date(job.completed_at).toLocaleString()}</p>
                )}
                {job.error_message && (
                  <p className="text-red-600"><strong>Error:</strong> {job.error_message}</p>
                )}
              </div>
            </div>
          </div>
        </div>

        <div className="mb-4">
          <h2 className="text-2xl font-semibold text-gray-800">Tasks ({tasks.length})</h2>
        </div>

        {tasks.length === 0 ? (
          <div className="bg-white p-12 rounded-lg shadow text-center">
            <p className="text-gray-600">No tasks yet. Tasks will appear after planning completes.</p>
          </div>
        ) : (
          <div className="space-y-4">
            {tasks.map((task) => (
              <div key={task.id} className="bg-white p-6 rounded-lg shadow">
                <div className="flex justify-between items-start mb-3">
                  <div className="flex-1">
                    <div className="flex items-center gap-3 mb-2">
                      <h3 className="text-lg font-semibold text-gray-900">{task.title}</h3>
                      <span className={`px-2 py-1 rounded text-xs font-medium ${getStatusColor(task.status)}`}>
                        {task.status}
                      </span>
                      <span className={`px-2 py-1 rounded text-xs font-medium ${getRoleColor(task.role)}`}>
                        {task.role}
                      </span>
                    </div>
                    <p className="text-sm text-gray-700 mb-2">{task.objective}</p>
                    {task.definition_of_done && (
                      <p className="text-xs text-gray-600 mb-2">
                        <strong>Definition of Done:</strong> {task.definition_of_done}
                      </p>
                    )}
                    {task.files.length > 0 && (
                      <p className="text-xs text-gray-600 mb-2">
                        <strong>Files:</strong> {task.files.join(', ')}
                      </p>
                    )}
                    {task.dependencies.length > 0 && (
                      <p className="text-xs text-gray-600 mb-2">
                        <strong>Dependencies:</strong> {task.dependencies.length} task(s)
                      </p>
                    )}
                    {task.cursor_run_id && (
                      <p className="text-xs text-gray-500">
                        <strong>Cursor Run ID:</strong> {task.cursor_run_id}
                      </p>
                    )}
                    {task.attempt_count > 0 && (
                      <p className="text-xs text-gray-500">
                        <strong>Attempts:</strong> {task.attempt_count}/{task.max_attempts}
                      </p>
                    )}
                    {task.error_message && (
                      <p className="text-xs text-red-600 mt-2">
                        <strong>Error:</strong> {task.error_message}
                      </p>
                    )}
                  </div>
                </div>
                <div className="text-xs text-gray-500">
                  Created: {new Date(task.created_at).toLocaleString()}
                  {task.completed_at && (
                    <> • Completed: {new Date(task.completed_at).toLocaleString()}</>
                  )}
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  )
}


