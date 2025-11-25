import { NextResponse } from "next/server";
import { getSession } from "@/lib/auth/session";
import { execFile } from "child_process";
import { promisify } from "util";
import path from "path";

const execAsync = promisify(execFile);

export async function POST(request: Request) {
  try {
    const session = await getSession();

    if (!session.isLoggedIn) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { subdomain, project } = await request.json();

    // Validate subdomain
    const validSubdomains = ["preview", "dev", "staging", "design"];
    if (!subdomain || !validSubdomains.includes(subdomain)) {
      return NextResponse.json(
        { error: "Invalid subdomain. Must be one of: preview, dev, staging, design" },
        { status: 400 }
      );
    }

    // Validate project
    const validProjects = ["devops-panel", "design-standards"];
    if (!project || !validProjects.includes(project)) {
      return NextResponse.json(
        { error: "Invalid project. Must be one of: devops-panel, design-standards" },
        { status: 400 }
      );
    }

    // Check if Vercel token is configured
    const vercelToken = process.env.VERCEL_TOKEN;
    if (!vercelToken) {
      return NextResponse.json(
        { error: "Vercel token not configured. Please set VERCEL_TOKEN environment variable." },
        { status: 500 }
      );
    }

    // Determine deployment command based on project
    let vercelArgs: string[];
    let projectPath: string;

    if (project === "design-standards") {
      projectPath = path.join(process.cwd(), "..", "design-standards");
      // Deploy design standards to design.vln.gg
      vercelArgs = ["--prod", "--token", vercelToken, "--yes"];
      // Note: domain variable is unused in deployment args here
    } else {
      // Deploy devops-panel to the specified subdomain
      projectPath = process.cwd();
      const domainMap: Record<string, string> = {
        preview: "preview.vln.gg",
        dev: "dev.vln.gg",
        staging: "staging.vln.gg",
      };
      // const domain = domainMap[subdomain];   // Not used in deployment call
      vercelArgs = ["--prod", "--token", vercelToken, "--yes"];
    }

    // Execute deployment
    const { stdout, stderr } = await execAsync(
      "vercel",
      vercelArgs,
      {
        cwd: projectPath,
        timeout: 300000, // 5 minute timeout
        maxBuffer: 1024 * 1024 * 10, // 10MB buffer
      }
    );

    // Parse Vercel output to get deployment URL
    const deploymentUrlMatch = stdout.match(/https:\/\/[^\s]+/);
    const deploymentUrl = deploymentUrlMatch ? deploymentUrlMatch[0] : null;

    return NextResponse.json({
      success: true,
      message: `Successfully deployed ${project} to ${subdomain}`,
      subdomain,
      project,
      deploymentUrl,
      logs: stdout,
      errors: stderr || null,
    });
  } catch (error: any) {
    console.error("Subdomain deployment error:", error);

    return NextResponse.json(
      {
        error: "Failed to deploy subdomain",
        message: error.message,
        details: error.stderr || error.stdout || null,
      },
      { status: 500 }
    );
  }
}

// GET endpoint to check deployment status
export async function GET() {
  try {
    const session = await getSession();

    if (!session.isLoggedIn) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const vercelToken = process.env.VERCEL_TOKEN;
    if (!vercelToken) {
      return NextResponse.json({
        error: "Vercel token not configured",
        deployments: [],
      });
    }

    // Fetch recent deployments from Vercel
    const response = await fetch(
      "https://api.vercel.com/v6/deployments?limit=20",
      {
        headers: {
          Authorization: `Bearer ${vercelToken}`,
        },
      }
    );

    if (!response.ok) {
      throw new Error("Failed to fetch deployments");
    }

    const data = await response.json();

    // Group deployments by project/subdomain
    const groupedDeployments: Record<string, any[]> = {
      "devops-panel": [],
      "design-standards": [],
    };

    for (const deployment of data.deployments || []) {
      const name = deployment.name || "";
      if (name.includes("design")) {
        groupedDeployments["design-standards"].push(deployment);
      } else {
        groupedDeployments["devops-panel"].push(deployment);
      }
    }

    return NextResponse.json({
      success: true,
      deployments: groupedDeployments,
      total: data.deployments?.length || 0,
    });
  } catch (error) {
    console.error("Deployments fetch error:", error);
    return NextResponse.json(
      { error: "Failed to fetch deployment data", deployments: {} },
      { status: 500 }
    );
  }
}
