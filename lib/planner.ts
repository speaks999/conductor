import { generateObject } from 'ai'
import { createOpenAI } from '@ai-sdk/openai'
import { z } from 'zod'

// Create OpenAI instance
const openaiModel = createOpenAI({
  apiKey: process.env.OPENAI_API_KEY || '',
})

// Planner output schema - structured DAG of tasks
const TaskSchema = z.object({
  id: z.string().describe('Unique identifier for the task'),
  title: z.string().describe('Short title of the task'),
  objective: z.string().describe('Clear objective of what this task should accomplish'),
  role: z.enum(['PLANNER', 'CODER', 'TESTER', 'REVIEWER', 'DOCS', 'FIXER']).describe('Agent role for this task'),
  dependencies: z.array(z.string()).default([]).describe('IDs of tasks that must complete before this one'),
  files: z.array(z.string()).default([]).describe('Files or areas this task should focus on'),
  definition_of_done: z.string().describe('Clear criteria for when this task is complete'),
})

const PlanSchema = z.object({
  phases: z.array(z.object({
    name: z.string().describe('Name of the phase (e.g., "Planning", "Implementation", "Testing")'),
    tasks: z.array(TaskSchema),
  })),
})

export type Plan = z.infer<typeof PlanSchema>
export type TaskPlan = z.infer<typeof TaskSchema>

export interface PlannerInput {
  repoUrl: string
  baseBranch: string
  goal: string
  repoContext?: string // Optional: repo structure, existing code context
}

/**
 * Planner: Uses Vercel AI SDK v6 to generate structured task DAG
 * The planner only creates structure, never writes code.
 */
export async function createPlan(input: PlannerInput): Promise<Plan> {
  const prompt = `You are Conductor's Planner. Your role is to break down a high-level software development goal into a structured plan of tasks.

REPO: ${input.repoUrl}
BRANCH: ${input.baseBranch}
GOAL: ${input.goal}

${input.repoContext ? `\nREPO CONTEXT:\n${input.repoContext}` : ''}

CRITICAL RULES:
1. You ONLY create structure (tasks, dependencies, phases). You NEVER write code.
2. Each task must have a clear objective and definition of done.
3. Tasks should be assigned appropriate roles (CODER, TESTER, REVIEWER, DOCS, FIXER).
4. Dependencies must form a valid DAG (no cycles).
5. Include at least one TESTER task to validate the work.
6. Tasks should be specific and actionable.

Create a plan that breaks this goal into phases and tasks. Each task should be independent enough to be executed by a Cursor Background Agent.`

  const { object } = await generateObject({
    model: openaiModel('gpt-4-turbo'),
    schema: PlanSchema,
    prompt,
  })

  return object
}

/**
 * Generate a unique ID for a task (used when creating tasks from plan)
 */
export function generateTaskId(): string {
  return `task_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`
}

