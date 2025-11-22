"use client";

import { useEffect, useState } from "react";
import { motion } from "framer-motion";
import {
  Activity,
  CheckCircle,
  AlertTriangle,
  XCircle,
  RefreshCw,
  Clock,
  Globe,
} from "lucide-react";
import Button from "@/components/ui/button";
import Card from "@/components/ui/card";

interface ServiceStatus {
  name: string;
  url: string;
  status: "healthy" | "degraded" | "down" | "checking";
  responseTime?: number;
  statusCode?: number;
  error?: string;
  lastChecked: string;
}

interface HealthData {
  overall: {
    status: "healthy" | "degraded" | "down";
    healthy: number;
    degraded: number;
    down: number;
    total: number;
    lastChecked: string;
  };
  services: ServiceStatus[];
}

export default function HealthStatus() {
  const [healthData, setHealthData] = useState<HealthData | null>(null);
  const [loading, setLoading] = useState(true);
  const [lastUpdate, setLastUpdate] = useState<Date>(new Date());
  const [autoRefresh, setAutoRefresh] = useState(true);

  const fetchHealthData = async () => {
    setLoading(true);
    try {
      const response = await fetch("/api/health");
      if (response.ok) {
        const data = await response.json();
        setHealthData(data);
        setLastUpdate(new Date());
      }
    } catch (error) {
      console.error("Failed to fetch health data:", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchHealthData();
  }, []);

  useEffect(() => {
    if (autoRefresh) {
      const interval = setInterval(fetchHealthData, 30000); // Refresh every 30s
      return () => clearInterval(interval);
    }
  }, [autoRefresh]);

  const getStatusIcon = (status: string) => {
    switch (status) {
      case "healthy":
        return <CheckCircle className="text-vln-sage" size={24} />;
      case "degraded":
        return <AlertTriangle className="text-vln-amber" size={24} />;
      case "down":
        return <XCircle className="text-red-500" size={24} />;
      default:
        return <Activity className="text-vln-sky animate-pulse" size={24} />;
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case "healthy":
        return "border-vln-sage";
      case "degraded":
        return "border-vln-amber";
      case "down":
        return "border-red-500";
      default:
        return "border-vln-sky";
    }
  };

  const getStatusText = (status: string) => {
    switch (status) {
      case "healthy":
        return "text-vln-sage";
      case "degraded":
        return "text-vln-amber";
      case "down":
        return "text-red-500";
      default:
        return "text-vln-sky";
    }
  };

  const formatResponseTime = (ms?: number) => {
    if (!ms) return "N/A";
    if (ms < 1000) return `${ms}ms`;
    return `${(ms / 1000).toFixed(2)}s`;
  };

  const formatLastChecked = (timestamp: string) => {
    const date = new Date(timestamp);
    const now = new Date();
    const diffMs = now.getTime() - date.getTime();
    const diffSec = Math.floor(diffMs / 1000);
    const diffMin = Math.floor(diffSec / 60);

    if (diffSec < 60) return `${diffSec}s ago`;
    if (diffMin < 60) return `${diffMin}m ago`;
    return date.toLocaleTimeString();
  };

  if (loading && !healthData) {
    return (
      <div className="flex items-center justify-center p-12">
        <RefreshCw className="animate-spin text-vln-sage" size={32} />
        <span className="ml-3 text-vln-gray">Checking service health...</span>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header with Controls */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-3xl font-bold text-gradient-sage mb-2">
            System Health
          </h2>
          <p className="text-vln-gray">
            Real-time monitoring of all services and deployments
          </p>
        </div>
        <div className="flex items-center gap-3">
          <button
            onClick={() => setAutoRefresh(!autoRefresh)}
            className={`px-4 py-2 rounded-lg text-sm transition-colors ${
              autoRefresh
                ? "bg-vln-sage/20 text-vln-sage"
                : "bg-vln-bg-lighter text-vln-gray hover:bg-vln-bg-light"
            }`}
          >
            {autoRefresh ? "Auto-refresh ON" : "Auto-refresh OFF"}
          </button>
          <Button
            onClick={fetchHealthData}
            disabled={loading}
            icon={
              <RefreshCw
                className={loading ? "animate-spin" : ""}
                size={18}
              />
            }
          >
            Refresh
          </Button>
        </div>
      </div>

      {/* Overall Status Card */}
      {healthData && (
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className={`bg-vln-bg-lighter rounded-vln p-6 border-l-4 ${getStatusColor(
            healthData.overall.status
          )} glow-lift`}
        >
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-4">
              {getStatusIcon(healthData.overall.status)}
              <div>
                <h3 className="text-2xl font-bold">Overall System Status</h3>
                <p
                  className={`text-lg font-semibold capitalize ${getStatusText(
                    healthData.overall.status
                  )}`}
                >
                  {healthData.overall.status}
                </p>
              </div>
            </div>
            <div className="text-right">
              <div className="flex items-center gap-6">
                <div>
                  <p className="text-2xl font-bold text-vln-sage">
                    {healthData.overall.healthy}
                  </p>
                  <p className="text-sm text-vln-gray">Healthy</p>
                </div>
                {healthData.overall.degraded > 0 && (
                  <div>
                    <p className="text-2xl font-bold text-vln-amber">
                      {healthData.overall.degraded}
                    </p>
                    <p className="text-sm text-vln-gray">Degraded</p>
                  </div>
                )}
                {healthData.overall.down > 0 && (
                  <div>
                    <p className="text-2xl font-bold text-red-500">
                      {healthData.overall.down}
                    </p>
                    <p className="text-sm text-vln-gray">Down</p>
                  </div>
                )}
              </div>
              <p className="text-xs text-vln-gray mt-2 flex items-center gap-1">
                <Clock size={12} />
                Last checked: {formatLastChecked(healthData.overall.lastChecked)}
              </p>
            </div>
          </div>
        </motion.div>
      )}

      {/* Services Grid */}
      {healthData && (
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
          {healthData.services.map((service, index) => (
            <motion.div
              key={service.url}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: index * 0.05 }}
            >
              <Card
                hover
                glow
                className={`border-l-4 ${getStatusColor(service.status)}`}
              >
                <div className="flex items-start justify-between mb-3">
                  <div className="flex items-center gap-3">
                    {getStatusIcon(service.status)}
                    <div>
                      <h4 className="font-semibold text-lg">{service.name}</h4>
                      <a
                        href={service.url}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-sm text-vln-sky hover:text-vln-sky-light transition-colors flex items-center gap-1"
                      >
                        <Globe size={12} />
                        {service.url.replace("https://", "")}
                      </a>
                    </div>
                  </div>
                  <span
                    className={`px-3 py-1 rounded-full text-xs font-semibold uppercase ${
                      service.status === "healthy"
                        ? "bg-vln-sage/20 text-vln-sage"
                        : service.status === "degraded"
                        ? "bg-vln-amber/20 text-vln-amber"
                        : "bg-red-500/20 text-red-500"
                    }`}
                  >
                    {service.status}
                  </span>
                </div>

                <div className="grid grid-cols-2 gap-4 mt-4 pt-4 border-t border-vln-bg-light">
                  <div>
                    <p className="text-xs text-vln-gray mb-1">Response Time</p>
                    <p className="font-mono text-sm font-semibold">
                      {formatResponseTime(service.responseTime)}
                    </p>
                  </div>
                  <div>
                    <p className="text-xs text-vln-gray mb-1">Status Code</p>
                    <p className="font-mono text-sm font-semibold">
                      {service.statusCode || "N/A"}
                    </p>
                  </div>
                </div>

                {service.error && (
                  <div className="mt-3 p-2 bg-red-500/10 rounded text-xs text-red-400">
                    <strong>Error:</strong> {service.error}
                  </div>
                )}

                <p className="text-xs text-vln-gray mt-3 flex items-center gap-1">
                  <Clock size={10} />
                  {formatLastChecked(service.lastChecked)}
                </p>
              </Card>
            </motion.div>
          ))}
        </div>
      )}
    </div>
  );
}
