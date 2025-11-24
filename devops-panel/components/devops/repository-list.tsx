'use client'

import { useState, useEffect } from 'react'
import { motion } from 'framer-motion'
import {
  GitBranch,
  Lock,
  Globe,
  Tag,
  Clock,
  ExternalLink,
  Filter,
  RefreshCw
} from 'lucide-react'

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

interface RepositoryStats {
  total: number
  production: number
  development: number
  archived: number
  withReleases: number
  withVersions: number
}

interface RepositoryData {
  success: boolean
  repositories: Repository[]
  stats: RepositoryStats
  lastUpdated: string
}

export default function RepositoryList() {
  const [data, setData] = useState<RepositoryData | null>(null)
  const [filter, setFilter] = useState<'all' | 'production' | 'development'>('all')
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  const fetchRepositories = async () => {
    try {
      setLoading(true)
      setError(null)
      const response = await fetch(`/api/repositories?filter=${filter}`)
      if (!response.ok) throw new Error('Failed to fetch repositories')
      const data = await response.json()
      setData(data)
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Unknown error')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    fetchRepositories()
  }, [filter])

  const getStatusColor = (status: Repository['status']) => {
    switch (status) {
      case 'production':
        return 'text-vln-sage'
      case 'development':
        return 'text-vln-amber'
      case 'archived':
        return 'text-vln-gray-dark'
      default:
        return 'text-vln-gray'
    }
  }

  const getStatusBg = (status: Repository['status']) => {
    switch (status) {
      case 'production':
        return 'bg-vln-sage/10 border-vln-sage/30'
      case 'development':
        return 'bg-vln-amber/10 border-vln-amber/30'
      case 'archived':
        return 'bg-vln-gray-dark/10 border-vln-gray-dark/30'
      default:
        return 'bg-vln-bg-lighter border-vln-gray-dark/30'
    }
  }

  if (loading && !data) {
    return (
      <div className="flex items-center justify-center py-12">
        <RefreshCw className="w-8 h-8 text-vln-sage animate-spin" />
      </div>
    )
  }

  if (error) {
    return (
      <div className="text-center py-12">
        <p className="text-vln-error mb-4">Error: {error}</p>
        <button
          onClick={fetchRepositories}
          className="px-4 py-2 bg-vln-sage/20 hover:bg-vln-sage/30 text-vln-sage rounded-lg transition-colors"
        >
          Retry
        </button>
      </div>
    )
  }

  if (!data) return null

  return (
    <div className="space-y-6">
      {/* Stats Cards */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="bg-vln-bg-lighter border border-vln-sage/30 rounded-vln p-4"
        >
          <div className="text-vln-gray text-sm mb-1">Total Repositories</div>
          <div className="text-vln-white text-2xl font-bold">{data.stats.total}</div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
          className="bg-vln-bg-lighter border border-vln-sage/30 rounded-vln p-4"
        >
          <div className="text-vln-gray text-sm mb-1">Production</div>
          <div className="text-vln-sage text-2xl font-bold">{data.stats.production}</div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
          className="bg-vln-bg-lighter border border-vln-amber/30 rounded-vln p-4"
        >
          <div className="text-vln-gray text-sm mb-1">In Development</div>
          <div className="text-vln-amber text-2xl font-bold">{data.stats.development}</div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 }}
          className="bg-vln-bg-lighter border border-vln-bluegray/30 rounded-vln p-4"
        >
          <div className="text-vln-gray text-sm mb-1">With Releases</div>
          <div className="text-vln-bluegray text-2xl font-bold">{data.stats.withReleases}</div>
        </motion.div>
      </div>

      {/* Filter Buttons */}
      <div className="flex items-center gap-3">
        <Filter className="w-5 h-5 text-vln-gray" />
        <div className="flex gap-2">
          {(['all', 'production', 'development'] as const).map((f) => (
            <button
              key={f}
              onClick={() => setFilter(f)}
              className={`px-4 py-2 rounded-lg text-sm font-medium transition-all ${
                filter === f
                  ? 'bg-vln-sage text-vln-bg shadow-vln-glow'
                  : 'bg-vln-bg-lighter text-vln-gray hover:bg-vln-bg-lighter/80'
              }`}
            >
              {f.charAt(0).toUpperCase() + f.slice(1)}
            </button>
          ))}
        </div>
        <button
          onClick={fetchRepositories}
          className="ml-auto p-2 hover:bg-vln-bg-lighter rounded-lg transition-colors"
          title="Refresh"
        >
          <RefreshCw className={`w-5 h-5 text-vln-gray ${loading ? 'animate-spin' : ''}`} />
        </button>
      </div>

      {/* Repository Cards */}
      <div className="grid gap-4">
        {data.repositories.map((repo, index) => (
          <motion.div
            key={repo.name}
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: index * 0.05 }}
            className={`p-4 rounded-vln border ${getStatusBg(repo.status)} hover:border-vln-sage/50 transition-all`}
          >
            <div className="flex items-start justify-between mb-3">
              <div className="flex-1">
                <div className="flex items-center gap-3 mb-2">
                  <h3 className="text-vln-white font-semibold text-lg">{repo.name}</h3>
                  {repo.isPrivate ? (
                    <Lock className="w-4 h-4 text-vln-gray" />
                  ) : (
                    <Globe className="w-4 h-4 text-vln-bluegray" />
                  )}
                  {repo.version && (
                    <span className="flex items-center gap-1 px-2 py-1 bg-vln-sage/20 text-vln-sage text-xs rounded-md">
                      <Tag className="w-3 h-3" />
                      {repo.version}
                    </span>
                  )}
                  <span className={`px-2 py-1 text-xs rounded-md ${getStatusColor(repo.status)} bg-opacity-10`}>
                    {repo.status}
                  </span>
                </div>

                <div className="flex items-center gap-4 text-sm text-vln-gray mb-2">
                  <span className="flex items-center gap-1">
                    <Clock className="w-4 h-4" />
                    {new Date(repo.lastPush).toLocaleDateString()}
                  </span>
                  {repo.hasReleases && (
                    <span className="flex items-center gap-1 text-vln-sage">
                      <GitBranch className="w-4 h-4" />
                      Has Releases
                    </span>
                  )}
                </div>

                <div className="flex flex-wrap gap-2 mb-3">
                  {repo.languages.slice(0, 4).map((lang) => (
                    <span
                      key={lang}
                      className="px-2 py-1 bg-vln-bg text-vln-gray text-xs rounded-md"
                    >
                      {lang}
                    </span>
                  ))}
                  {repo.languages.length > 4 && (
                    <span className="px-2 py-1 bg-vln-bg text-vln-gray text-xs rounded-md">
                      +{repo.languages.length - 4} more
                    </span>
                  )}
                </div>

                {repo.deployment && (
                  <div className="flex items-center gap-2 text-sm">
                    <span className="text-vln-gray">Deployment:</span>
                    <a
                      href={repo.deployment.startsWith('http') ? repo.deployment : `https://${repo.deployment}`}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="text-vln-bluegray hover:text-vln-bluegray-light flex items-center gap-1"
                    >
                      {repo.deployment}
                      <ExternalLink className="w-3 h-3" />
                    </a>
                  </div>
                )}
              </div>

              <a
                href={repo.url}
                target="_blank"
                rel="noopener noreferrer"
                className="px-4 py-2 bg-vln-sage/20 hover:bg-vln-sage/30 text-vln-sage rounded-lg transition-colors flex items-center gap-2"
              >
                View Repo
                <ExternalLink className="w-4 h-4" />
              </a>
            </div>
          </motion.div>
        ))}
      </div>

      {/* Last Updated */}
      <div className="text-center text-sm text-vln-gray-dark">
        Last updated: {new Date(data.lastUpdated).toLocaleString()}
      </div>
    </div>
  )
}
