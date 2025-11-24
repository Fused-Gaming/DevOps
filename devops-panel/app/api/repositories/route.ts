import { NextResponse } from 'next/server'

interface Repository {
  name: string
  url: string
  version: string | null
  status: 'production' | 'development' | 'archived'
  deployment?: string
  lastPush: string
  isPrivate: boolean
  languages: string[]
  hasReleases: boolean
}

// Repository inventory data
const REPOSITORIES: Repository[] = [
  {
    name: 'DevOps',
    url: 'https://github.com/Fused-Gaming/DevOps',
    version: 'v2.3.0',
    status: 'production',
    deployment: 'https://dev-ops-omega.vercel.app',
    lastPush: '2025-11-22',
    isPrivate: false,
    languages: ['Shell', 'TypeScript', 'Python', 'JavaScript'],
    hasReleases: true,
  },
  {
    name: 'vln',
    url: 'https://github.com/Fused-Gaming/vln',
    version: 'v0.1.0',
    status: 'development',
    deployment: 'https://vln.gg',
    lastPush: '2025-11-24',
    isPrivate: false,
    languages: ['TypeScript', 'CSS', 'JavaScript'],
    hasReleases: false,
  },
  {
    name: 'wallet',
    url: 'https://github.com/Fused-Gaming/wallet',
    version: 'v1.0.0',
    status: 'development',
    deployment: 'wallet.vln.gg (planned)',
    lastPush: '2025-11-23',
    isPrivate: true,
    languages: ['Solidity', 'TypeScript', 'HTML', 'CSS'],
    hasReleases: false,
  },
  {
    name: 'attorney-finder-bot',
    url: 'https://github.com/Fused-Gaming/attorney-finder-bot',
    version: null,
    status: 'production',
    deployment: 'https://attorney-finder-bot.vercel.app',
    lastPush: '2025-11-20',
    isPrivate: false,
    languages: ['Python', 'JavaScript'],
    hasReleases: false,
  },
  {
    name: 'GrindOS',
    url: 'https://github.com/Fused-Gaming/GrindOS',
    version: null,
    status: 'development',
    lastPush: '2025-11-24',
    isPrivate: true,
    languages: ['Python', 'TypeScript', 'Mako', 'Dockerfile'],
    hasReleases: false,
  },
  {
    name: 'BetCartel',
    url: 'https://github.com/Fused-Gaming/BetCartel',
    version: null,
    status: 'development',
    lastPush: '2025-11-23',
    isPrivate: true,
    languages: ['Solidity', 'TypeScript', 'Python', 'JavaScript'],
    hasReleases: false,
  },
  {
    name: 'vise',
    url: 'https://github.com/Fused-Gaming/vise',
    version: null,
    status: 'development',
    lastPush: '2025-11-24',
    isPrivate: false,
    languages: ['Makefile', 'Shell'],
    hasReleases: false,
  },
  {
    name: '.github',
    url: 'https://github.com/Fused-Gaming/.github',
    version: null,
    status: 'production',
    lastPush: '2025-11-24',
    isPrivate: false,
    languages: ['Python', 'Shell'],
    hasReleases: false,
  },
  {
    name: 'Smart-Contract-Vulnerabilities',
    url: 'https://github.com/Fused-Gaming/Smart-Contract-Vulnerabilities',
    version: null,
    status: 'development',
    lastPush: '2025-11-23',
    isPrivate: true,
    languages: ['Makefile', 'Solidity', 'Python', 'Shell'],
    hasReleases: false,
  },
  {
    name: 'GambaRewards',
    url: 'https://github.com/Fused-Gaming/GambaRewards',
    version: null,
    status: 'development',
    lastPush: '2025-11-23',
    isPrivate: true,
    languages: ['Shell', 'TypeScript'],
    hasReleases: false,
  },
  {
    name: 'Leaderboards-S1',
    url: 'https://github.com/Fused-Gaming/Leaderboards-S1',
    version: null,
    status: 'development',
    lastPush: '2025-11-23',
    isPrivate: true,
    languages: ['TypeScript', 'CSS', 'JavaScript'],
    hasReleases: false,
  },
]

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url)
    const filter = searchParams.get('filter')

    let filteredRepos = REPOSITORIES

    // Filter by status
    if (filter && filter !== 'all') {
      filteredRepos = REPOSITORIES.filter((repo) => repo.status === filter)
    }

    // Calculate summary stats
    const stats = {
      total: REPOSITORIES.length,
      production: REPOSITORIES.filter((r) => r.status === 'production').length,
      development: REPOSITORIES.filter((r) => r.status === 'development').length,
      archived: REPOSITORIES.filter((r) => r.status === 'archived').length,
      withReleases: REPOSITORIES.filter((r) => r.hasReleases).length,
      withVersions: REPOSITORIES.filter((r) => r.version !== null).length,
    }

    return NextResponse.json({
      success: true,
      repositories: filteredRepos,
      stats,
      lastUpdated: '2025-11-23T00:00:00Z',
    })
  } catch (error) {
    console.error('Repository API error:', error)
    return NextResponse.json(
      { success: false, error: 'Failed to fetch repositories' },
      { status: 500 }
    )
  }
}

// POST endpoint for updating repository data (future use)
export async function POST(request: Request) {
  try {
    const body = await request.json()
    const { action, repository } = body

    // This would integrate with GitHub API to perform actions
    // For now, return success for demonstration
    return NextResponse.json({
      success: true,
      message: `Action "${action}" queued for repository "${repository}"`,
    })
  } catch (error) {
    console.error('Repository update error:', error)
    return NextResponse.json(
      { success: false, error: 'Failed to update repository' },
      { status: 500 }
    )
  }
}
