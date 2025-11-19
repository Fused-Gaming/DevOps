import { NextResponse } from "next/server";
import { getSession } from "@/lib/auth/session";

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
        deployments: []
      });
    }

    // Fetch deployments from Vercel API
    const response = await fetch("https://api.vercel.com/v6/deployments?limit=10", {
      headers: {
        Authorization: `Bearer ${vercelToken}`,
      },
    });

    if (!response.ok) {
      throw new Error("Failed to fetch deployments");
    }

    const data = await response.json();

    return NextResponse.json({
      success: true,
      deployments: data.deployments || []
    });
  } catch (error) {
    console.error("Deployments API error:", error);
    return NextResponse.json(
      { error: "Failed to fetch deployment data", deployments: [] },
      { status: 500 }
    );
  }
}
