import { NextResponse } from "next/server";
import { getSession } from "@/lib/auth/session";
import { exec } from "child_process";
import { promisify } from "util";

const execAsync = promisify(exec);

export async function GET() {
  try {
    const session = await getSession();

    if (!session.isLoggedIn) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    // Execute the milestone status script
    const scriptPath = process.env.DEVOPS_SCRIPTS_PATH || "/k/git/DevOps/scripts";
    const { stdout } = await execAsync(`bash "${scriptPath}/milestone-status.sh"`);

    // Parse the output (you may need to adjust this based on script output)
    const lines = stdout.split('\n').filter(line => line.trim());

    return NextResponse.json({
      success: true,
      output: lines,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    console.error("Milestone API error:", error);
    return NextResponse.json(
      { error: "Failed to fetch milestone data" },
      { status: 500 }
    );
  }
}
