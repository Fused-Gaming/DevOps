"use client";

import PenpotProjects from "@/components/penpot/penpot-projects";
import DesignFiles from "@/components/penpot/design-files";
import PenpotStatus from "@/components/penpot/penpot-status";
import NavShell from "@/components/layout/nav-shell";

export default function PenpotPage() {
  return (
    <NavShell>
      <div className="p-6">
        <div className="max-w-7xl mx-auto space-y-6">
        {/* Header */}
        <div>
          <h1 className="text-3xl font-bold text-white mb-2">
            Penpot Design Management
          </h1>
          <p className="text-gray-400">
            Manage your design files, export assets, and collaborate with your team
          </p>
        </div>

        {/* Status and overview */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div className="lg:col-span-1">
            <PenpotStatus />
          </div>
          <div className="lg:col-span-2">
            <PenpotProjects />
          </div>
        </div>

        {/* Design files */}
        <div>
          <DesignFiles />
        </div>

        {/* Quick links and resources */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <a
            href="https://design.vln.gg/tools/penpot-setup"
            target="_blank"
            rel="noopener noreferrer"
            className="p-6 bg-vln-bg-lighter hover:bg-vln-bg-light rounded-lg border border-vln-bg-light transition-colors"
          >
            <h3 className="text-lg font-semibold text-white mb-2">
              Setup Guide
            </h3>
            <p className="text-sm text-gray-400">
              Learn how to set up Penpot with VLN design system
            </p>
          </a>

          <a
            href="https://design.vln.gg/tools/penpot-integration"
            target="_blank"
            rel="noopener noreferrer"
            className="p-6 bg-vln-bg-lighter hover:bg-vln-bg-light rounded-lg border border-vln-bg-light transition-colors"
          >
            <h3 className="text-lg font-semibold text-white mb-2">
              API Integration
            </h3>
            <p className="text-sm text-gray-400">
              Automate exports and sync designs with CI/CD
            </p>
          </a>

          <a
            href="https://design.vln.gg/design-system/colors"
            target="_blank"
            rel="noopener noreferrer"
            className="p-6 bg-vln-bg-lighter hover:bg-vln-bg-light rounded-lg border border-vln-bg-light transition-colors"
          >
            <h3 className="text-lg font-semibold text-white mb-2">
              VLN Colors
            </h3>
            <p className="text-sm text-gray-400">
              WCAG AAA accessible color palette for your designs
            </p>
          </a>
        </div>
        </div>
      </div>
    </NavShell>
  );
}
