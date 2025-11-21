"use client";

import { useState } from "react";
import Button from "@/components/ui/button";
import Card, { CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { X, Rocket, AlertCircle, CheckCircle, Loader2, ExternalLink } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";

interface DeploymentDialogProps {
  isOpen: boolean;
  onClose: () => void;
}

type DeploymentStatus = "idle" | "deploying" | "success" | "error";

export default function DeploymentDialog({ isOpen, onClose }: DeploymentDialogProps) {
  const [selectedProject, setSelectedProject] = useState<string>("design-standards");
  const [selectedSubdomain, setSelectedSubdomain] = useState<string>("design");
  const [deploymentStatus, setDeploymentStatus] = useState<DeploymentStatus>("idle");
  const [deploymentUrl, setDeploymentUrl] = useState<string | null>(null);
  const [deploymentLogs, setDeploymentLogs] = useState<string>("");
  const [error, setError] = useState<string | null>(null);

  const projects = [
    { id: "design-standards", name: "Design Standards", subdomain: "design.vln.gg" },
    { id: "devops-panel", name: "DevOps Panel", subdomain: "Variable" },
  ];

  const subdomains = [
    { id: "design", name: "Design (design.vln.gg)", project: "design-standards" },
    { id: "preview", name: "Preview (preview.vln.gg)", project: "devops-panel" },
    { id: "dev", name: "Dev (dev.vln.gg)", project: "devops-panel" },
    { id: "staging", name: "Staging (staging.vln.gg)", project: "devops-panel" },
  ];

  const filteredSubdomains = subdomains.filter(
    (sub) => sub.project === selectedProject
  );

  const handleDeploy = async () => {
    setDeploymentStatus("deploying");
    setError(null);
    setDeploymentLogs("");
    setDeploymentUrl(null);

    try {
      const response = await fetch("/api/deployments/subdomain", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          project: selectedProject,
          subdomain: selectedSubdomain,
        }),
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || data.message || "Deployment failed");
      }

      setDeploymentStatus("success");
      setDeploymentUrl(data.deploymentUrl);
      setDeploymentLogs(data.logs || "Deployment completed successfully");
    } catch (err: any) {
      console.error("Deployment error:", err);
      setDeploymentStatus("error");
      setError(err.message || "Failed to deploy");
      setDeploymentLogs(err.details || "");
    }
  };

  const handleClose = () => {
    // Only allow closing if not deploying
    if (deploymentStatus !== "deploying") {
      onClose();
      // Reset state after animation
      setTimeout(() => {
        setDeploymentStatus("idle");
        setError(null);
        setDeploymentLogs("");
        setDeploymentUrl(null);
      }, 300);
    }
  };

  return (
    <AnimatePresence>
      {isOpen && (
        <>
          {/* Backdrop */}
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            onClick={handleClose}
            className="fixed inset-0 bg-black/50 backdrop-blur-sm z-40"
          />

          {/* Dialog */}
          <div className="fixed inset-0 flex items-center justify-center z-50 p-4">
            <motion.div
              initial={{ opacity: 0, scale: 0.95, y: 20 }}
              animate={{ opacity: 1, scale: 1, y: 0 }}
              exit={{ opacity: 0, scale: 0.95, y: 20 }}
              transition={{ duration: 0.2 }}
              className="w-full max-w-2xl"
            >
              <Card hover={false} className="relative">
                {/* Close button */}
                {deploymentStatus !== "deploying" && (
                  <button
                    onClick={handleClose}
                    className="absolute top-4 right-4 p-2 hover:bg-vln-bg-light rounded-lg transition-colors"
                  >
                    <X className="w-5 h-5" />
                  </button>
                )}

                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Rocket className="w-6 h-6 text-vln-sage" />
                    Deploy to Subdomain
                  </CardTitle>
                </CardHeader>

                <CardContent className="space-y-6">
                  {/* Project Selection */}
                  <div>
                    <label className="block text-sm font-medium mb-2">
                      Select Project
                    </label>
                    <div className="grid grid-cols-2 gap-3">
                      {projects.map((project) => (
                        <button
                          key={project.id}
                          onClick={() => {
                            setSelectedProject(project.id);
                            // Auto-select first subdomain for this project
                            const firstSubdomain = subdomains.find(
                              (s) => s.project === project.id
                            );
                            if (firstSubdomain) {
                              setSelectedSubdomain(firstSubdomain.id);
                            }
                          }}
                          disabled={deploymentStatus === "deploying"}
                          className={`p-4 rounded-lg border-2 transition-all ${
                            selectedProject === project.id
                              ? "border-vln-sage bg-vln-sage/10"
                              : "border-vln-bg-light hover:border-vln-sage/50"
                          } ${
                            deploymentStatus === "deploying"
                              ? "opacity-50 cursor-not-allowed"
                              : ""
                          }`}
                        >
                          <div className="font-medium">{project.name}</div>
                          <div className="text-sm text-gray-400 mt-1">
                            {project.subdomain}
                          </div>
                        </button>
                      ))}
                    </div>
                  </div>

                  {/* Subdomain Selection */}
                  <div>
                    <label className="block text-sm font-medium mb-2">
                      Select Subdomain
                    </label>
                    <div className="space-y-2">
                      {filteredSubdomains.map((subdomain) => (
                        <button
                          key={subdomain.id}
                          onClick={() => setSelectedSubdomain(subdomain.id)}
                          disabled={deploymentStatus === "deploying"}
                          className={`w-full p-3 rounded-lg border-2 transition-all text-left ${
                            selectedSubdomain === subdomain.id
                              ? "border-vln-sage bg-vln-sage/10"
                              : "border-vln-bg-light hover:border-vln-sage/50"
                          } ${
                            deploymentStatus === "deploying"
                              ? "opacity-50 cursor-not-allowed"
                              : ""
                          }`}
                        >
                          <div className="font-medium">{subdomain.name}</div>
                        </button>
                      ))}
                    </div>
                  </div>

                  {/* Status Messages */}
                  <AnimatePresence mode="wait">
                    {deploymentStatus === "deploying" && (
                      <motion.div
                        initial={{ opacity: 0, y: 10 }}
                        animate={{ opacity: 1, y: 0 }}
                        exit={{ opacity: 0, y: -10 }}
                        className="flex items-center gap-3 p-4 bg-vln-sky/10 border border-vln-sky/30 rounded-lg"
                      >
                        <Loader2 className="w-5 h-5 text-vln-sky animate-spin" />
                        <div>
                          <div className="font-medium text-vln-sky">
                            Deploying...
                          </div>
                          <div className="text-sm text-gray-400 mt-1">
                            This may take a few minutes
                          </div>
                        </div>
                      </motion.div>
                    )}

                    {deploymentStatus === "success" && (
                      <motion.div
                        initial={{ opacity: 0, y: 10 }}
                        animate={{ opacity: 1, y: 0 }}
                        exit={{ opacity: 0, y: -10 }}
                        className="space-y-3"
                      >
                        <div className="flex items-center gap-3 p-4 bg-vln-sage/10 border border-vln-sage/30 rounded-lg">
                          <CheckCircle className="w-5 h-5 text-vln-sage" />
                          <div className="flex-1">
                            <div className="font-medium text-vln-sage">
                              Deployment Successful!
                            </div>
                            <div className="text-sm text-gray-400 mt-1">
                              Your project has been deployed
                            </div>
                          </div>
                        </div>

                        {deploymentUrl && (
                          <a
                            href={deploymentUrl}
                            target="_blank"
                            rel="noopener noreferrer"
                            className="flex items-center gap-2 p-3 bg-vln-bg-light rounded-lg hover:bg-vln-bg transition-colors"
                          >
                            <ExternalLink className="w-4 h-4 text-vln-sage" />
                            <span className="flex-1 text-sm font-mono">
                              {deploymentUrl}
                            </span>
                          </a>
                        )}

                        {deploymentLogs && (
                          <details className="text-sm">
                            <summary className="cursor-pointer text-gray-400 hover:text-white">
                              View deployment logs
                            </summary>
                            <pre className="mt-2 p-3 bg-vln-bg rounded-lg overflow-x-auto text-xs">
                              {deploymentLogs}
                            </pre>
                          </details>
                        )}
                      </motion.div>
                    )}

                    {deploymentStatus === "error" && (
                      <motion.div
                        initial={{ opacity: 0, y: 10 }}
                        animate={{ opacity: 1, y: 0 }}
                        exit={{ opacity: 0, y: -10 }}
                        className="space-y-3"
                      >
                        <div className="flex items-center gap-3 p-4 bg-red-500/10 border border-red-500/30 rounded-lg">
                          <AlertCircle className="w-5 h-5 text-red-500" />
                          <div className="flex-1">
                            <div className="font-medium text-red-500">
                              Deployment Failed
                            </div>
                            <div className="text-sm text-gray-400 mt-1">
                              {error || "An error occurred during deployment"}
                            </div>
                          </div>
                        </div>

                        {deploymentLogs && (
                          <details className="text-sm" open>
                            <summary className="cursor-pointer text-gray-400 hover:text-white">
                              View error details
                            </summary>
                            <pre className="mt-2 p-3 bg-vln-bg rounded-lg overflow-x-auto text-xs text-red-400">
                              {deploymentLogs}
                            </pre>
                          </details>
                        )}
                      </motion.div>
                    )}
                  </AnimatePresence>

                  {/* Action Buttons */}
                  <div className="flex gap-3">
                    {deploymentStatus === "idle" && (
                      <>
                        <Button
                          variant="secondary"
                          onClick={handleClose}
                          className="flex-1"
                        >
                          Cancel
                        </Button>
                        <Button
                          variant="primary"
                          onClick={handleDeploy}
                          icon={<Rocket />}
                          className="flex-1"
                        >
                          Deploy Now
                        </Button>
                      </>
                    )}

                    {deploymentStatus === "deploying" && (
                      <div className="flex-1 text-center text-sm text-gray-400">
                        Deployment in progress... Please wait.
                      </div>
                    )}

                    {(deploymentStatus === "success" ||
                      deploymentStatus === "error") && (
                      <>
                        <Button
                          variant="secondary"
                          onClick={handleClose}
                          className="flex-1"
                        >
                          Close
                        </Button>
                        {deploymentStatus === "error" && (
                          <Button
                            variant="primary"
                            onClick={handleDeploy}
                            icon={<Rocket />}
                            className="flex-1"
                          >
                            Try Again
                          </Button>
                        )}
                      </>
                    )}
                  </div>
                </CardContent>
              </Card>
            </motion.div>
          </div>
        </>
      )}
    </AnimatePresence>
  );
}
