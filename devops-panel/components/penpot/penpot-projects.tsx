"use client";

import { useState, useEffect } from "react";
import Card, { CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Palette, Folder, ExternalLink } from "lucide-react";
import { motion } from "framer-motion";

interface PenpotProject {
  id: string;
  name: string;
  "modified-at": string;
  "is-pinned": boolean;
}

export default function PenpotProjects() {
  const [projects, setProjects] = useState<PenpotProject[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetchProjects();
  }, []);

  const fetchProjects = async () => {
    try {
      const response = await fetch("/api/penpot/projects");
      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || "Failed to fetch projects");
      }

      setProjects(data.projects || []);
      setError(null);
    } catch (err: any) {
      console.error("Failed to fetch Penpot projects:", err);
      setError(err.message || "Failed to load projects");
    } finally {
      setLoading(false);
    }
  };

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString("en-US", {
      month: "short",
      day: "numeric",
      year: "numeric",
    });
  };

  return (
    <Card hover={false}>
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <Palette className="w-5 h-5 text-vln-purple" />
          Penpot Projects
        </CardTitle>
      </CardHeader>
      <CardContent>
        {loading ? (
          <div className="flex items-center justify-center py-8">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-vln-sage"></div>
          </div>
        ) : error ? (
          <div className="text-center py-8">
            <p className="text-red-500 mb-2">{error}</p>
            <p className="text-sm text-gray-400">
              Make sure PENPOT_ACCESS_TOKEN is configured in .env.local
            </p>
          </div>
        ) : projects.length === 0 ? (
          <div className="text-center py-8">
            <Palette className="w-12 h-12 text-gray-600 mx-auto mb-3" />
            <p className="text-gray-400">No Penpot projects found</p>
            <p className="text-sm text-gray-500 mt-1">
              Create a project in Penpot to get started
            </p>
          </div>
        ) : (
          <div className="space-y-3">
            {projects.map((project, index) => (
              <motion.div
                key={project.id}
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: index * 0.05 }}
                className="flex items-center justify-between p-4 bg-vln-bg-lighter rounded-lg hover:bg-vln-bg-light transition-colors"
              >
                <div className="flex items-center gap-3">
                  <div className="p-2 bg-vln-purple/20 rounded-lg">
                    <Folder className="w-5 h-5 text-vln-purple" />
                  </div>
                  <div>
                    <p className="font-medium text-white">{project.name}</p>
                    <p className="text-sm text-gray-400">
                      Updated {formatDate(project["modified-at"])}
                    </p>
                  </div>
                </div>
                <a
                  href={`https://design.penpot.app/#/workspace/${project.id}`}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="p-2 hover:bg-vln-bg rounded-lg transition-colors"
                  title="Open in Penpot"
                >
                  <ExternalLink className="w-5 h-5 text-vln-sage" />
                </a>
              </motion.div>
            ))}
          </div>
        )}
      </CardContent>
    </Card>
  );
}
