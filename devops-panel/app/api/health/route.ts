import { NextRequest, NextResponse } from "next/server";
import { getSession } from "@/lib/auth/session";

interface ServiceStatus {
  name: string;
  url: string;
  status: "healthy" | "degraded" | "down" | "checking";
  responseTime?: number;
  statusCode?: number;
  error?: string;
  lastChecked: string;
}

// Define all services to monitor
const SERVICES = [
  {
    name: "Attorney Finder Bot (Production)",
    url: "https://attorney-finder-bot.vercel.app",
    type: "production",
  },
  {
    name: "Attorney Finder Bot (Preview)",
    url: "https://attorney-finder-bot-git-main-team-4eckd.vercel.app",
    type: "preview",
  },
  {
    name: "DevOps Panel (Production)",
    url: "https://dev-ops-omega.vercel.app",
    type: "production",
  },
  {
    name: "Design Standards (VLN)",
    url: "https://design.vln.gg",
    type: "subdomain",
  },
  {
    name: "Preview Environment (VLN)",
    url: "https://preview.vln.gg",
    type: "subdomain",
  },
  {
    name: "Dev Environment (VLN)",
    url: "https://dev.vln.gg",
    type: "subdomain",
  },
  {
    name: "Staging Environment (VLN)",
    url: "https://staging.vln.gg",
    type: "subdomain",
  },
];

async function checkServiceHealth(
  service: typeof SERVICES[0]
): Promise<ServiceStatus> {
  const startTime = Date.now();

  try {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 10000); // 10s timeout

    const response = await fetch(service.url, {
      method: "HEAD",
      signal: controller.signal,
      headers: {
        "User-Agent": "VLN-HealthCheck/1.0",
      },
    });

    clearTimeout(timeoutId);

    const responseTime = Date.now() - startTime;
    const statusCode = response.status;

    let status: ServiceStatus["status"] = "healthy";
    if (statusCode >= 500) {
      status = "down";
    } else if (statusCode >= 400) {
      status = "degraded";
    } else if (responseTime > 3000) {
      status = "degraded";
    }

    return {
      name: service.name,
      url: service.url,
      status,
      responseTime,
      statusCode,
      lastChecked: new Date().toISOString(),
    };
  } catch (error: any) {
    return {
      name: service.name,
      url: service.url,
      status: "down",
      error: error.message || "Connection failed",
      lastChecked: new Date().toISOString(),
    };
  }
}

export async function GET(request: NextRequest) {
  try {
    // Check authentication
    const session = await getSession();
    if (!session.isLoggedIn) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    // Check all services in parallel
    const healthChecks = await Promise.all(
      SERVICES.map((service) => checkServiceHealth(service))
    );

    // Calculate overall system health
    const healthyCount = healthChecks.filter(
      (check) => check.status === "healthy"
    ).length;
    const degradedCount = healthChecks.filter(
      (check) => check.status === "degraded"
    ).length;
    const downCount = healthChecks.filter(
      (check) => check.status === "down"
    ).length;

    let overallStatus: "healthy" | "degraded" | "down" = "healthy";
    if (downCount > 0) {
      overallStatus = downCount >= SERVICES.length / 2 ? "down" : "degraded";
    } else if (degradedCount > 0) {
      overallStatus = "degraded";
    }

    return NextResponse.json({
      overall: {
        status: overallStatus,
        healthy: healthyCount,
        degraded: degradedCount,
        down: downCount,
        total: SERVICES.length,
        lastChecked: new Date().toISOString(),
      },
      services: healthChecks,
    });
  } catch (error: any) {
    console.error("Health check error:", error);
    return NextResponse.json(
      { error: "Failed to perform health checks" },
      { status: 500 }
    );
  }
}
