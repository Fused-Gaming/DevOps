"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Button from "@/components/ui/button";
import StatusCard from "@/components/devops/status-card";
import MilestoneCard from "@/components/devops/milestone-card";
import DeploymentList from "@/components/devops/deployment-list";
import QuickActions from "@/components/devops/quick-actions";
import PenpotQuickAccess from "@/components/penpot/penpot-quick-access";
import {
  Activity,
  GitBranch,
  Rocket,
  CheckCircle,
  LogOut
} from "lucide-react";

export default function DashboardPage() {
  const [loading, setLoading] = useState(true);
  const [user, setUser] = useState<{ username: string } | null>(null);
  const router = useRouter();

  useEffect(() => {
    checkAuth();
  }, []);

  const checkAuth = async () => {
    try {
      const response = await fetch("/api/auth/session");
      const data = await response.json();

      if (!data.isLoggedIn) {
        router.push("/login");
      } else {
        setUser({ username: data.username });
      }
    } catch (error) {
      router.push("/login");
    } finally {
      setLoading(false);
    }
  };

  const handleLogout = async () => {
    await fetch("/api/auth/logout", { method: "POST" });
    router.push("/login");
    router.refresh();
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <p className="text-vln-gray">Loading...</p>
      </div>
    );
  }

  return (
    <div className="min-h-screen p-6">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <div className="mb-8 flex items-center justify-between">
          <div>
            <h1 className="text-4xl font-bold text-gradient-sage mb-2">
              DevOps Control Panel
            </h1>
            <p className="text-vln-gray">
              Welcome back, {user?.username || "Admin"}
            </p>
          </div>
          <Button
            variant="ghost"
            onClick={handleLogout}
            icon={<LogOut />}
          >
            Logout
          </Button>
        </div>

        {/* Status Overview */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <StatusCard
            title="System Status"
            description="All systems operational"
            icon={Activity}
            status="success"
            value="Healthy"
          />
          <StatusCard
            title="Active Deploys"
            description="Running deployments"
            icon={Rocket}
            status="info"
            value="3"
          />
          <StatusCard
            title="GitHub Actions"
            description="Workflow status"
            icon={GitBranch}
            status="success"
            value="Passing"
          />
          <StatusCard
            title="Milestones"
            description="Completion rate"
            icon={CheckCircle}
            status="warning"
            value="67%"
          />
        </div>

        {/* Milestones */}
        <div className="mb-8">
          <h2 className="text-2xl font-bold text-vln-sage mb-4">Active Milestones</h2>
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <MilestoneCard
              title="Q4 2024 Features"
              description="Core feature development"
              progress={8}
              total={12}
            />
            <MilestoneCard
              title="Infrastructure Updates"
              description="DevOps improvements"
              progress={5}
              total={8}
            />
          </div>
        </div>

        {/* Deployments, Actions & Design System */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <DeploymentList />
          <QuickActions />
          <PenpotQuickAccess />
        </div>
      </div>
    </div>
  );
}
