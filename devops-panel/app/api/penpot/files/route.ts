import { NextResponse } from "next/server";
import { getSession } from "@/lib/auth/session";

export async function GET(request: Request) {
  try {
    const session = await getSession();

    if (!session.isLoggedIn) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { searchParams } = new URL(request.url);
    const projectId = searchParams.get("projectId") || process.env.PENPOT_PROJECT_ID;

    const penpotToken = process.env.PENPOT_ACCESS_TOKEN;
    const penpotApiUrl = process.env.PENPOT_API_URL || "https://design.penpot.app/api";

    if (!penpotToken) {
      return NextResponse.json({
        error: "Penpot token not configured",
        files: []
      });
    }

    if (!projectId) {
      return NextResponse.json({
        error: "Project ID not specified",
        files: []
      });
    }

    // Fetch files from Penpot API
    const response = await fetch(
      `${penpotApiUrl}/rpc/command/get-project-files?project-id=${projectId}`,
      {
        headers: {
          Authorization: `Token ${penpotToken}`,
        },
      }
    );

    if (!response.ok) {
      throw new Error(`Penpot API error: ${response.status}`);
    }

    const files = await response.json();

    return NextResponse.json({
      success: true,
      files: files || [],
      projectId,
    });
  } catch (error) {
    console.error("Penpot files API error:", error);
    return NextResponse.json(
      {
        error: "Failed to fetch design files",
        files: [],
        message: error instanceof Error ? error.message : "Unknown error"
      },
      { status: 500 }
    );
  }
}
