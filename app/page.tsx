'use client'

import { useState, useEffect } from 'react'
import Link from 'next/link'

interface Job {
  id: string
  repo_url: string
  goal: string
  status: string
  github_pr_url: string | null
  created_at: string
  updated_at: string
}

export default function Home() {
  const [jobs, setJobs] = useState<Job[]>([])
  const [loading, setLoading] = useState(true)
  const [showCreateForm, setShowCreateForm] = useState(false)
  const [formData, setFormData] = useState({
    repo_url: '',
    base_branch: 'main',
    goal: '',
  })

  useEffect(() => {
    fetchJobs()
  }, [])

  const fetchJobs = async () => {
    try {
      const response = await fetch('/api/job')
      const data = await response.json()
      setJobs(data.jobs || [])
    } catch (error) {
      console.error('Error fetching jobs:', error)
    } finally {
      setLoading(false)
    }
  }

  const handleCreateJob = async (e: React.FormEvent) => {
    e.preventDefault()
    try {
      const response = await fetch('/api/job', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData),
      })

      if (response.ok) {
        const data = await response.json()
        setShowCreateForm(false)
        setFormData({ repo_url: '', base_branch: 'main', goal: '' })
        fetchJobs()
      } else {
        const error = await response.json()
        alert(`Error: ${error.error}`)
      }
    } catch (error) {
      console.error('Error creating job:', error)
      alert('Failed to create job')
    }
  }

  const handleRunJob = async (jobId: string) => {
    try {
      const response = await fetch(`/api/job/${jobId}/run`, {
        method: 'POST',
      })

      if (response.ok) {
        fetchJobs()
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
      case 'planning':
        return 'bg-yellow-100 text-yellow-800'
      default:
        return 'bg-gray-100 text-gray-800'
    }
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-8">
          <h1 className="text-4xl font-bold text-gray-900 mb-2">
            Conductor
          </h1>
          <p className="text-lg text-gray-600">
            The control plane for AI-native software delivery
          </p>
        </div>

        <div className="mb-6 flex justify-between items-center">
          <h2 className="text-2xl font-semibold text-gray-800">Jobs</h2>
          <button
            onClick={() => setShowCreateForm(!showCreateForm)}
            className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"
          >
            {showCreateForm ? 'Cancel' : 'Create Job'}
          </button>
        </div>

        {showCreateForm && (
          <div className="mb-6 bg-white p-6 rounded-lg shadow">
            <h3 className="text-xl font-semibold mb-4">Create New Job</h3>
            <form onSubmit={handleCreateJob}>
              <div className="mb-4">
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Repository URL
                </label>
                <input
                  type="text"
                  value={formData.repo_url}
                  onChange={(e) => setFormData({ ...formData, repo_url: e.target.value })}
                  placeholder="https://github.com/owner/repo"
                  className="w-full px-3 py-2 border border-gray-300 rounded-md"
                  required
                />
              </div>
              <div className="mb-4">
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Base Branch
                </label>
                <input
                  type="text"
                  value={formData.base_branch}
                  onChange={(e) => setFormData({ ...formData, base_branch: e.target.value })}
                  placeholder="main"
                  className="w-full px-3 py-2 border border-gray-300 rounded-md"
                />
              </div>
              <div className="mb-4">
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Goal
                </label>
                <textarea
                  value={formData.goal}
                  onChange={(e) => setFormData({ ...formData, goal: e.target.value })}
                  placeholder="Describe what you want to accomplish..."
                  rows={4}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md"
                  required
                />
              </div>
              <button
                type="submit"
                className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"
              >
                Create Job
              </button>
            </form>
          </div>
        )}

        {loading ? (
          <div className="text-center py-12">
            <p className="text-gray-600">Loading jobs...</p>
          </div>
        ) : jobs.length === 0 ? (
          <div className="bg-white p-12 rounded-lg shadow text-center">
            <p className="text-gray-600 mb-4">No jobs yet. Create your first job to get started.</p>
          </div>
        ) : (
          <div className="space-y-4">
            {jobs.map((job) => (
              <div key={job.id} className="bg-white p-6 rounded-lg shadow">
                <div className="flex justify-between items-start mb-4">
                  <div className="flex-1">
                    <div className="flex items-center gap-3 mb-2">
                      <h3 className="text-xl font-semibold text-gray-900">
                        {job.goal.substring(0, 100)}
                        {job.goal.length > 100 && '...'}
                      </h3>
                      <span className={`px-2 py-1 rounded text-sm font-medium ${getStatusColor(job.status)}`}>
                        {job.status}
                      </span>
                    </div>
                    <p className="text-sm text-gray-600 mb-2">
                      <strong>Repo:</strong> {job.repo_url}
                    </p>
                    {job.github_pr_url && (
                      <p className="text-sm text-gray-600 mb-2">
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
                    <p className="text-xs text-gray-500">
                      Created: {new Date(job.created_at).toLocaleString()}
                    </p>
                  </div>
                  <div className="flex gap-2">
                    {job.status === 'pending' && (
                      <button
                        onClick={() => handleRunJob(job.id)}
                        className="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700"
                      >
                        Run
                      </button>
                    )}
                    <Link
                      href={`/job/${job.id}`}
                      className="px-4 py-2 bg-gray-600 text-white rounded-lg hover:bg-gray-700"
                    >
                      View
                    </Link>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  )
}


