"use client";

import { useState, useEffect } from "react";
import Card, { CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import Button from "@/components/ui/button";
import { FileImage, Download, ExternalLink, RefreshCw } from "lucide-react";
import { motion } from "framer-motion";

interface DesignFile {
  id: string;
  name: string;
  "modified-at": string;
  "created-at": string;
}

export default function DesignFiles() {
  const [files, setFiles] = useState<DesignFile[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [exporting, setExporting] = useState<string | null>(null);

  useEffect(() => {
    fetchFiles();
  }, []);

  const fetchFiles = async () => {
    setLoading(true);
    try {
      const response = await fetch("/api/penpot/files");
      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || "Failed to fetch files");
      }

      setFiles(data.files || []);
      setError(null);
    } catch (err: any) {
      console.error("Failed to fetch design files:", err);
      setError(err.message || "Failed to load files");
    } finally {
      setLoading(false);
    }
  };

  const handleExport = async (fileId: string, fileName: string) => {
    setExporting(fileId);
    try {
      const response = await fetch("/api/penpot/export", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ fileId, fileName }),
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || "Export failed");
      }

      // Open export URL in new tab
      if (data.exportUrl) {
        // Construct full download URL
        const penpotToken = process.env.NEXT_PUBLIC_PENPOT_ACCESS_TOKEN;
        window.open(data.exportUrl, "_blank");
      }
    } catch (err: any) {
      console.error("Export error:", err);
      alert(`Export failed: ${err.message}`);
    } finally {
      setExporting(null);
    }
  };

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString("en-US", {
      month: "short",
      day: "numeric",
      hour: "2-digit",
      minute: "2-digit",
    });
  };

  return (
    <Card hover={false}>
      <CardHeader>
        <div className="flex items-center justify-between">
          <CardTitle className="flex items-center gap-2">
            <FileImage className="w-5 h-5 text-vln-sky" />
            Design Files
          </CardTitle>
          <Button
            variant="ghost"
            size="sm"
            icon={<RefreshCw />}
            onClick={fetchFiles}
            disabled={loading}
          >
            Refresh
          </Button>
        </div>
      </CardHeader>
      <CardContent>
        {loading ? (
          <div className="flex items-center justify-center py-8">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-vln-sky"></div>
          </div>
        ) : error ? (
          <div className="text-center py-8">
            <p className="text-red-500 mb-2">{error}</p>
            <p className="text-sm text-gray-400">
              Make sure PENPOT_PROJECT_ID is configured
            </p>
          </div>
        ) : files.length === 0 ? (
          <div className="text-center py-8">
            <FileImage className="w-12 h-12 text-gray-600 mx-auto mb-3" />
            <p className="text-gray-400">No design files found</p>
            <p className="text-sm text-gray-500 mt-1">
              Create files in your Penpot project
            </p>
          </div>
        ) : (
          <div className="space-y-3">
            {files.slice(0, 10).map((file, index) => (
              <motion.div
                key={file.id}
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: index * 0.05 }}
                className="flex items-center justify-between p-4 bg-vln-bg-lighter rounded-lg hover:bg-vln-bg-light transition-colors"
              >
                <div className="flex items-center gap-3 flex-1">
                  <div className="p-2 bg-vln-sky/20 rounded-lg">
                    <FileImage className="w-5 h-5 text-vln-sky" />
                  </div>
                  <div className="flex-1">
                    <p className="font-medium text-white">{file.name}</p>
                    <p className="text-sm text-gray-400">
                      Modified {formatDate(file["modified-at"])}
                    </p>
                  </div>
                </div>
                <div className="flex items-center gap-2">
                  <button
                    onClick={() => handleExport(file.id, file.name)}
                    disabled={exporting === file.id}
                    className="p-2 hover:bg-vln-bg rounded-lg transition-colors disabled:opacity-50"
                    title="Export file"
                  >
                    {exporting === file.id ? (
                      <RefreshCw className="w-5 h-5 text-vln-amber animate-spin" />
                    ) : (
                      <Download className="w-5 h-5 text-vln-amber" />
                    )}
                  </button>
                  <a
                    href={`https://design.penpot.app/#/workspace/${file.id}`}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="p-2 hover:bg-vln-bg rounded-lg transition-colors"
                    title="Open in Penpot"
                  >
                    <ExternalLink className="w-5 h-5 text-vln-sage" />
                  </a>
                </div>
              </motion.div>
            ))}
            {files.length > 10 && (
              <p className="text-center text-sm text-gray-400 pt-2">
                Showing 10 of {files.length} files
              </p>
            )}
          </div>
        )}
      </CardContent>
    </Card>
  );
}
