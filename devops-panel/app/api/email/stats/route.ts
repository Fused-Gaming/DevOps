import { getSession } from "@/lib/auth/session";
import { NextResponse } from "next/server";

export async function GET() {
  const session = await getSession();

  if (!session.isLoggedIn) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    // Mock data - replace with actual database queries
    const emailToken = process.env.EMAIL_SERVICE_TOKEN;
    const isConfigured = !!emailToken;

    return NextResponse.json({
      totalTemplates: 5,
      pendingEmails: 3,
      failedEmails: 0,
      isConfigured,
    });
  } catch (error) {
    console.error("Failed to fetch email stats:", error);
    return NextResponse.json(
      { error: "Failed to fetch email stats" },
      { status: 500 }
    );
  }
}
