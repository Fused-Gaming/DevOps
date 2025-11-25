import { getSession } from "@/lib/auth/session";
import { NextResponse } from "next/server";

export async function GET() {
  const session = await getSession();

  if (!session.isLoggedIn) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    // Mock data - replace with actual database queries
    // In production, query your email service or database
    const now = new Date();
    const startOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate());

    return NextResponse.json({
      sentToday: 24,
      failedToday: 0,
      pendingToday: 3,
      successRate: 100,
      lastUpdated: new Date().toISOString(),
    });
  } catch (error) {
    console.error("Failed to fetch email status:", error);
    return NextResponse.json(
      { error: "Failed to fetch email status" },
      { status: 500 }
    );
  }
}
