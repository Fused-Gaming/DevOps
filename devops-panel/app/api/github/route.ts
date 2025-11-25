import { NextResponse } from "next/server";
import { getSession } from "@/lib/auth/session";

// Allowlist of valid repositories to prevent SSRF attacks
const ALLOWED_REPOS = [
  "Fused-Gaming/DevOps",
  "Fused-Gaming/vln",
  "Fused-Gaming/wallet",
  "Fused-Gaming/attorney-finder-bot",
  "Fused-Gaming/BetCartel",
  "Fused-Gaming/GrindOS",
  "Fused-Gaming/vise",
  "Fused-Gaming/.github",
] as const;

export async function GET(request: Request) {
  try {
    const session = await getSession();

    if (!session.isLoggedIn) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const githubToken = process.env.GITHUB_TOKEN;
    const { searchParams } = new URL(request.url);
    const requestedRepo = searchParams.get("repo") || "Fused-Gaming/DevOps";

    // Validate repo against allowlist to prevent SSRF
    if (!ALLOWED_REPOS.includes(requestedRepo as any)) {
      return NextResponse.json(
        {
          error: "Invalid repository. Repository must be in the allowed list.",
          allowedRepos: ALLOWED_REPOS
        },
        { status: 400 }
      );
    }

    const repo = requestedRepo; // Safe to use after validation

    if (!githubToken) {
      return NextResponse.json({
        error: "GitHub token not configured",
        workflows: []
      });
    }

    // Fetch workflow runs from GitHub Actions
    // Safe: repo is validated against allowlist
    const response = await fetch(
      `https://api.github.com/repos/${repo}/actions/runs?per_page=10`,
      {
        headers: {
          Authorization: `Bearer ${githubToken}`,
          Accept: "application/vnd.github.v3+json",
        },
      }
    );

    if (!response.ok) {
      throw new Error("Failed to fetch GitHub Actions");
    }

    const data = await response.json();

    return NextResponse.json({
      success: true,
      workflows: data.workflow_runs || []
    });
  } catch (error) {
    console.error("GitHub API error:", error);
    return NextResponse.json(
      { error: "Failed to fetch GitHub data", workflows: [] },
      { status: 500 }
    );
  }
}
