"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import Button from "@/components/ui/button";
import StatusCard from "@/components/devops/status-card";
import MilestoneCard from "@/components/devops/milestone-card";
import DeploymentList from "@/components/devops/deployment-list";
import QuickActions from "@/components/devops/quick-actions";
import {
  Activity,
  GitBranch,
  Rocket,
  CheckCircle,
  LogOut,
  Shield,
  ExternalLink
} from "lucide-react";

interface HealthData {
  overall: {
    status: "healthy" | "degraded" | "down";
    healthy: number;
    degraded: number;
    down: number;
    total: number;
  };
}

export default function DashboardPage() {
  const [loading, setLoading] = useState(true);
  const [user, setUser] = useState<{ username: string } | null>(null);
  const [healthData, setHealthData] = useState<HealthData | null>(null);
  const router = useRouter();

  useEffect(() => {
    checkAuth();
  }, []);

  useEffect(() => {
    if (user) {
      fetchHealthData();
      const interval = setInterval(fetchHealthData, 60000); // Refresh every 60s
      return () => clearInterval(interval);
    }
  }, [user]);

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

  const fetchHealthData = async () => {
    try {
      const response = await fetch("/api/health");
      if (response.ok) {
        const data = await response.json();
        setHealthData(data);
      }
    } catch (error) {
      console.error("Failed to fetch health data:", error);
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
            <p className="text-vln-gray flex items-center gap-2">
              <Shield className="text-vln-sage" size={16} />
              Welcome back, {user?.username || "Admin"} - Password Protected
            </p>
          </div>
          <div className="flex items-center gap-3">
            <Link href="/health">
              <Button variant="secondary" icon={<Activity />}>
                Health Monitor
                <ExternalLink className="ml-2" size={16} />
              </Button>
            </Link>
            <Button
              variant="ghost"
              onClick={handleLogout}
              icon={<LogOut />}
            >
              Logout
            </Button>
          </div>
        </div>

        {/* Status Overview */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <StatusCard
            title="System Health"
            description={
              healthData
                ? `${healthData.overall.healthy}/${healthData.overall.total} services healthy`
                : "Checking services..."
            }
            icon={Activity}
            status={
              healthData?.overall.status === "healthy"
                ? "success"
                : healthData?.overall.status === "degraded"
                ? "warning"
                : "error"
            }
            value={
              healthData
                ? healthData.overall.status.charAt(0).toUpperCase() +
                  healthData.overall.status.slice(1)
                : "Checking..."
            }
          />
          <StatusCard
            title="Services Online"
            description="Production deployments"
            icon={Rocket}
            status="info"
            value={healthData?.overall.healthy.toString() || "..."}
          />
          <StatusCard
            title="GitHub Actions"
            description="Workflow status"
            icon={GitBranch}
            status="success"
            value="Passing"
          />
          <StatusCard
            title="Response Time"
            description="Average across services"
            icon={CheckCircle}
            status="success"
            value="<1s"
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

        {/* Deployments & Actions */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <DeploymentList />
          <QuickActions />
        </div>
      </div>
    </div>
  );
}
