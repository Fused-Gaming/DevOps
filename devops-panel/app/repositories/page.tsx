import { Metadata } from 'next'
import RepositoryList from '@/components/devops/repository-list'
import { GitBranch } from 'lucide-react'

export const metadata: Metadata = {
  title: 'Repository Management - DevOps Panel',
  description: 'Manage and track all Fused-Gaming repositories',
}

export default function RepositoriesPage() {
  return (
    <div className="min-h-screen bg-vln-bg text-vln-white p-6">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <div className="mb-8">
          <div className="flex items-center gap-3 mb-2">
            <GitBranch className="w-8 h-8 text-vln-sage" />
            <h1 className="text-3xl font-bold">Repository Management</h1>
          </div>
          <p className="text-vln-gray">
            Track versions, deployments, and status across all Fused-Gaming repositories
          </p>
        </div>

        {/* Repository List Component */}
        <RepositoryList />

        {/* Documentation Links */}
        <div className="mt-8 p-6 bg-vln-bg-lighter border border-vln-sage/30 rounded-vln">
          <h2 className="text-xl font-semibold mb-4 text-vln-sage">Documentation</h2>
          <div className="grid md:grid-cols-2 gap-4 text-sm">
            <a
              href="https://github.com/Fused-Gaming/DevOps/blob/main/docs/REPOSITORY-INVENTORY.md"
              target="_blank"
              rel="noopener noreferrer"
              className="p-4 bg-vln-bg rounded-lg hover:bg-vln-bg-lighter transition-colors"
            >
              <div className="font-semibold text-vln-sage mb-1">Repository Inventory</div>
              <div className="text-vln-gray">Complete inventory of all Fused-Gaming repositories</div>
            </a>
            <a
              href="https://github.com/Fused-Gaming/DevOps/blob/main/agent-prompts/AUTOMATION.md#repository-tracking--version-management"
              target="_blank"
              rel="noopener noreferrer"
              className="p-4 bg-vln-bg rounded-lg hover:bg-vln-bg-lighter transition-colors"
            >
              <div className="font-semibold text-vln-bluegray mb-1">Version Tracking Guide</div>
              <div className="text-vln-gray">Learn about our version management strategy</div>
            </a>
          </div>
        </div>
      </div>
    </div>
  )
}
