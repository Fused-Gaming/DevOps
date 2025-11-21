import { NextResponse } from "next/server";
import { getSession } from "@/lib/auth/session";
import { exec } from "child_process";
import { promisify } from "util";
import path from "path";

const execAsync = promisify(exec);

export async function POST(request: Request) {
  try {
    const session = await getSession();

    if (!session.isLoggedIn) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { fileId, fileName } = await request.json();

    if (!fileId) {
      return NextResponse.json(
        { error: "File ID is required" },
        { status: 400 }
      );
    }

    const penpotToken = process.env.PENPOT_ACCESS_TOKEN;
    const penpotApiUrl = process.env.PENPOT_API_URL || "https://design.penpot.app/api";

    if (!penpotToken) {
      return NextResponse.json(
        { error: "Penpot token not configured" },
        { status: 500 }
      );
    }

    // Export file from Penpot
    const exportUrl = `${penpotApiUrl}/export/file/${fileId}.zip`;

    // For now, return the export URL
    // In production, you might want to download and process the file
    return NextResponse.json({
      success: true,
      message: `Export initiated for ${fileName || 'file'}`,
      exportUrl,
      fileId,
      // Note: Actual download requires client-side implementation
      // or server-side file processing
    });
  } catch (error: any) {
    console.error("Penpot export error:", error);

    return NextResponse.json(
      {
        error: "Failed to export design file",
        message: error.message,
      },
      { status: 500 }
    );
  }
}
