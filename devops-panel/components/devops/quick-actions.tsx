"use client";

import { useState } from "react";
import Button from "@/components/ui/button";
import Card, { CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Play, RefreshCw, GitBranch, Terminal, Rocket } from "lucide-react";
import DeploymentDialog from "./deployment-dialog";

export default function QuickActions() {
  const [isDeployDialogOpen, setIsDeployDialogOpen] = useState(false);

  const handleAction = async (action: string) => {
    console.log(`Executing action: ${action}`);
    // Add actual action handlers here
  };

  return (
    <>
      <Card hover={false}>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Terminal className="w-5 h-5" />
            Quick Actions
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-2 gap-3">
            {/* Deploy Button - Featured */}
            <Button
              variant="primary"
              size="sm"
              icon={<Rocket />}
              onClick={() => setIsDeployDialogOpen(true)}
              className="col-span-2"
            >
              Deploy to Subdomain
            </Button>

            <Button
              variant="secondary"
              size="sm"
              icon={<Play />}
              onClick={() => handleAction("milestone-check")}
            >
              Check Milestones
            </Button>
            <Button
              variant="secondary"
              size="sm"
              icon={<RefreshCw />}
              onClick={() => handleAction("update-changelog")}
            >
              Update Changelog
            </Button>
            <Button
              variant="secondary"
              size="sm"
              icon={<GitBranch />}
              onClick={() => handleAction("check-updates")}
            >
              Check Updates
            </Button>
            <Button
              variant="secondary"
              size="sm"
              icon={<Terminal />}
              onClick={() => handleAction("run-tests")}
            >
              Run Tests
            </Button>
          </div>
        </CardContent>
      </Card>

      {/* Deployment Dialog */}
      <DeploymentDialog
        isOpen={isDeployDialogOpen}
        onClose={() => setIsDeployDialogOpen(false)}
      />
    </>
  );
}
