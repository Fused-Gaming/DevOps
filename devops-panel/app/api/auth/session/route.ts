import { NextResponse } from "next/server";
import { getSession } from "@/lib/auth/session";

export async function GET() {
  try {
    const session = await getSession();

    return NextResponse.json({
      isLoggedIn: session.isLoggedIn || false,
      username: session.username || null,
    });
  } catch (error) {
    console.error("Session error:", error);
    return NextResponse.json(
      { isLoggedIn: false, username: null },
      { status: 500 }
    );
  }
}
