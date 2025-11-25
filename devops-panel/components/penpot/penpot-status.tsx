"use client";

import { useState, useEffect } from "react";
import Card, { CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import Button from "@/components/ui/button";
import { Palette, CheckCircle, XCircle, ExternalLink, Download } from "lucide-react";

export default function PenpotStatus() {
  const [status, setStatus] = useState<{
    configured: boolean;
    connected: boolean;
    projectCount: number;
    fileCount: number;
  }>({
    configured: false,
    connected: false,
    projectCount: 0,
    fileCount: 0,
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    checkStatus();
  }, []);

  const checkStatus = async () => {
    try {
      // Check if Penpot is configured and connected
      const [projectsRes, filesRes] = await Promise.all([
        fetch("/api/penpot/projects"),
        fetch("/api/penpot/files"),
      ]);

      const projectsData = await projectsRes.json();
      const filesData = await filesRes.json();

      const configured = !projectsData.error?.includes("not configured");
      const connected = projectsRes.ok && configured;

      setStatus({
        configured,
        connected,
        projectCount: projectsData.projects?.length || 0,
        fileCount: filesData.files?.length || 0,
      });
    } catch (error) {
      console.error("Failed to check Penpot status:", error);
      setStatus({
        configured: false,
        connected: false,
        projectCount: 0,
        fileCount: 0,
      });
    } finally {
      setLoading(false);
    }
  };

  const handleExportAll = async () => {
    // Navigate to design standards export
    window.open("/design-standards", "_blank");
  };

  return (
    <Card hover={false}>
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <Palette className="w-5 h-5 text-vln-purple" />
          Penpot Integration
        </CardTitle>
      </CardHeader>
      <CardContent>
        {loading ? (
          <div className="flex items-center justify-center py-4">
            <div className="animate-spin rounded-full h-6 w-6 border-b-2 border-vln-purple"></div>
          </div>
        ) : (
          <div className="space-y-4">
            {/* Status indicators */}
            <div className="space-y-2">
              <div className="flex items-center justify-between">
                <span className="text-sm text-gray-400">Configuration</span>
                <div className="flex items-center gap-2">
                  {status.configured ? (
                    <>
                      <CheckCircle className="w-4 h-4 text-vln-sage" />
                      <span className="text-sm text-vln-sage">Configured</span>
                    </>
                  ) : (
                    <>
                      <XCircle className="w-4 h-4 text-red-500" />
                      <span className="text-sm text-red-500">Not configured</span>
                    </>
                  )}
                </div>
              </div>

              <div className="flex items-center justify-between">
                <span className="text-sm text-gray-400">Connection</span>
                <div className="flex items-center gap-2">
                  {status.connected ? (
                    <>
                      <CheckCircle className="w-4 h-4 text-vln-sage" />
                      <span className="text-sm text-vln-sage">Connected</span>
                    </>
                  ) : (
                    <>
                      <XCircle className="w-4 h-4 text-red-500" />
                      <span className="text-sm text-red-500">Disconnected</span>
                    </>
                  )}
                </div>
              </div>
            </div>

            {status.connected && (
              <>
                {/* Stats */}
                <div className="grid grid-cols-2 gap-3">
                  <div className="bg-vln-bg-lighter p-3 rounded-lg">
                    <p className="text-2xl font-bold text-vln-purple">
                      {status.projectCount}
                    </p>
                    <p className="text-xs text-gray-400">Projects</p>
                  </div>
                  <div className="bg-vln-bg-lighter p-3 rounded-lg">
                    <p className="text-2xl font-bold text-vln-sky">
                      {status.fileCount}
                    </p>
                    <p className="text-xs text-gray-400">Files</p>
                  </div>
                </div>

                {/* Quick actions */}
                <div className="space-y-2">
                  <a
                    href="https://design.penpot.app"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="flex items-center justify-center gap-2 w-full px-4 py-2 bg-vln-purple/20 hover:bg-vln-purple/30 text-vln-purple rounded-lg transition-colors"
                  >
                    <ExternalLink className="w-4 h-4" />
                    <span className="text-sm font-medium">Open Penpot</span>
                  </a>
                  <a
                    href="https://design.vln.gg"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="flex items-center justify-center gap-2 w-full px-4 py-2 bg-vln-sky/20 hover:bg-vln-sky/30 text-vln-sky rounded-lg transition-colors"
                  >
                    <ExternalLink className="w-4 h-4" />
                    <span className="text-sm font-medium">Design Standards</span>
                  </a>
                </div>
              </>
            )}

            {!status.configured && (
              <div className="bg-vln-amber/10 border border-vln-amber/30 rounded-lg p-3">
                <p className="text-sm text-vln-amber">
                  Add PENPOT_ACCESS_TOKEN to .env.local to enable Penpot integration
                </p>
              </div>
            )}
          </div>
        )}
      </CardContent>
    </Card>
  );
}
