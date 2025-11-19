"use client";

import { useState, useEffect } from "react";
import Card, { CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Rocket, CheckCircle, XCircle, Clock } from "lucide-react";

interface Deployment {
  uid: string;
  name: string;
  state: string;
  created: number;
  url: string;
}

export default function DeploymentList() {
  const [deployments, setDeployments] = useState<Deployment[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchDeployments();
  }, []);

  const fetchDeployments = async () => {
    try {
      const response = await fetch("/api/deployments");
      const data = await response.json();
      setDeployments(data.deployments || []);
    } catch (error) {
      console.error("Failed to fetch deployments:", error);
    } finally {
      setLoading(false);
    }
  };

  const getStatusIcon = (state: string) => {
    switch (state) {
      case "READY":
        return <CheckCircle className="w-5 h-5 text-vln-success" />;
      case "ERROR":
        return <XCircle className="w-5 h-5 text-vln-error" />;
      default:
        return <Clock className="w-5 h-5 text-vln-warning" />;
    }
  };

  return (
    <Card hover={false}>
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <Rocket className="w-5 h-5" />
          Recent Deployments
        </CardTitle>
      </CardHeader>
      <CardContent>
        {loading ? (
          <p className="text-vln-gray">Loading deployments...</p>
        ) : deployments.length === 0 ? (
          <p className="text-vln-gray">No deployments found</p>
        ) : (
          <div className="space-y-3">
            {deployments.slice(0, 5).map((deployment) => (
              <div
                key={deployment.uid}
                className="flex items-center justify-between p-3 bg-vln-bg-lighter rounded-lg"
              >
                <div className="flex items-center gap-3">
                  {getStatusIcon(deployment.state)}
                  <div>
                    <p className="font-medium text-vln-white">{deployment.name}</p>
                    <p className="text-sm text-vln-gray">
                      {new Date(deployment.created).toLocaleString()}
                    </p>
                  </div>
                </div>
                <span className="text-xs px-2 py-1 bg-vln-sage/20 text-vln-sage rounded">
                  {deployment.state}
                </span>
              </div>
            ))}
          </div>
        )}
      </CardContent>
    </Card>
  );
}
