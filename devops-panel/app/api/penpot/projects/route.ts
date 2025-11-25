import { NextResponse } from "next/server";
import { getSession } from "@/lib/auth/session";

export async function GET() {
  try {
    const session = await getSession();

    if (!session.isLoggedIn) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const penpotToken = process.env.PENPOT_ACCESS_TOKEN;
    const penpotApiUrl = process.env.PENPOT_API_URL || "https://design.penpot.app/api";
    const teamId = process.env.PENPOT_TEAM_ID;

    if (!penpotToken) {
      return NextResponse.json({
        error: "Penpot token not configured",
        projects: []
      });
    }

    if (!teamId) {
      return NextResponse.json({
        error: "Penpot team ID not configured",
        projects: []
      });
    }

    // Fetch projects from Penpot API
    const response = await fetch(
      `${penpotApiUrl}/rpc/command/get-projects?team-id=${teamId}`,
      {
        headers: {
          Authorization: `Token ${penpotToken}`,
        },
      }
    );

    if (!response.ok) {
      throw new Error(`Penpot API error: ${response.status}`);
    }

    const projects = await response.json();

    return NextResponse.json({
      success: true,
      projects: projects || [],
      teamId,
    });
  } catch (error) {
    console.error("Penpot projects API error:", error);
    return NextResponse.json(
      {
        error: "Failed to fetch Penpot projects",
        projects: [],
        message: error instanceof Error ? error.message : "Unknown error"
      },
      { status: 500 }
    );
  }
}
