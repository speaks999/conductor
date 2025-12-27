/**
 * GitHub Adapter
 * Manages branches, PRs, and commits for job execution
 */

export interface GitHubConfig {
  token: string
  owner: string
  repo: string
}

export interface CreatePRParams {
  jobId: string
  title: string
  body: string
  baseBranch: string
  headBranch: string
}

class GitHubAdapter {
  private config: GitHubConfig | null = null

  constructor() {
    const token = process.env.GITHUB_TOKEN
    if (token) {
      // Parse repo URL to get owner/repo
      // For now, we'll require these to be set via environment or passed in
      this.config = {
        token,
        owner: process.env.GITHUB_OWNER || '',
        repo: process.env.GITHUB_REPO || '',
      }
    }
  }

  /**
   * Create a job branch
   */
  async createJobBranch(jobId: string, baseBranch: string = 'main'): Promise<string> {
    if (!this.config) {
      throw new Error('GitHub configuration not set')
    }

    const branchName = `conductor/${jobId}`
    const apiUrl = `https://api.github.com/repos/${this.config.owner}/${this.config.repo}/git/refs`

    // Get the SHA of the base branch
    const baseRefResponse = await fetch(
      `https://api.github.com/repos/${this.config.owner}/${this.config.repo}/git/ref/heads/${baseBranch}`,
      {
        headers: {
          'Authorization': `token ${this.config.token}`,
          'Accept': 'application/vnd.github.v3+json',
        },
      }
    )

    if (!baseRefResponse.ok) {
      throw new Error(`Failed to get base branch: ${baseRefResponse.statusText}`)
    }

    const baseRef = await baseRefResponse.json()
    const baseSha = baseRef.object.sha

    // Create the new branch
    const response = await fetch(apiUrl, {
      method: 'POST',
      headers: {
        'Authorization': `token ${this.config.token}`,
        'Accept': 'application/vnd.github.v3+json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        ref: `refs/heads/${branchName}`,
        sha: baseSha,
      }),
    })

    if (!response.ok) {
      const error = await response.text()
      throw new Error(`Failed to create branch: ${error}`)
    }

    return branchName
  }

  /**
   * Create a PR for a job
   */
  async createPR(params: CreatePRParams): Promise<string> {
    if (!this.config) {
      throw new Error('GitHub configuration not set')
    }

    const apiUrl = `https://api.github.com/repos/${this.config.owner}/${this.config.repo}/pulls`

    const response = await fetch(apiUrl, {
      method: 'POST',
      headers: {
        'Authorization': `token ${this.config.token}`,
        'Accept': 'application/vnd.github.v3+json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        title: params.title,
        body: params.body,
        head: params.headBranch,
        base: params.baseBranch,
      }),
    })

    if (!response.ok) {
      const error = await response.text()
      throw new Error(`Failed to create PR: ${error}`)
    }

    const pr = await response.json()
    return pr.html_url
  }

  /**
   * Add a comment to a PR
   */
  async addPRComment(prUrl: string, comment: string): Promise<void> {
    if (!this.config) {
      throw new Error('GitHub configuration not set')
    }

    // Extract PR number from URL
    const prNumber = prUrl.match(/\/pull\/(\d+)/)?.[1]
    if (!prNumber) {
      throw new Error('Invalid PR URL')
    }

    const apiUrl = `https://api.github.com/repos/${this.config.owner}/${this.config.repo}/issues/${prNumber}/comments`

    const response = await fetch(apiUrl, {
      method: 'POST',
      headers: {
        'Authorization': `token ${this.config.token}`,
        'Accept': 'application/vnd.github.v3+json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        body: comment,
      }),
    })

    if (!response.ok) {
      const error = await response.text()
      throw new Error(`Failed to add comment: ${error}`)
    }
  }

  /**
   * Parse repo URL to get owner and repo
   */
  static parseRepoUrl(repoUrl: string): { owner: string; repo: string } {
    // Handle various formats: https://github.com/owner/repo, git@github.com:owner/repo.git, etc.
    const match = repoUrl.match(/(?:github\.com[/:])([^/]+)\/([^/]+?)(?:\.git)?$/)
    if (!match) {
      throw new Error(`Invalid GitHub repo URL: ${repoUrl}`)
    }

    return {
      owner: match[1],
      repo: match[2].replace(/\.git$/, ''),
    }
  }
}

export const githubAdapter = new GitHubAdapter()


