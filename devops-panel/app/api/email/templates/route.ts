import { getSession } from "@/lib/auth/session";
import { NextResponse } from "next/server";

export async function GET() {
  const session = await getSession();

  if (!session.isLoggedIn) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    // Mock template data - replace with actual database queries
    const templates = [
      {
        id: "1",
        name: "Welcome Email",
        subject: "Welcome to our platform",
        description: "Sent to new users upon signup",
        createdAt: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString(),
      },
      {
        id: "2",
        name: "Password Reset",
        subject: "Reset your password",
        description: "Sent when user requests password reset",
        createdAt: new Date(Date.now() - 5 * 24 * 60 * 60 * 1000).toISOString(),
      },
      {
        id: "3",
        name: "Deployment Notification",
        subject: "Deployment completed",
        description: "Notifies about completed deployments",
        createdAt: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000).toISOString(),
      },
      {
        id: "4",
        name: "Weekly Report",
        subject: "Your weekly digest",
        description: "Weekly activity summary email",
        createdAt: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000).toISOString(),
      },
      {
        id: "5",
        name: "Alert Notification",
        subject: "Alert: System issue detected",
        description: "Notifies about system alerts",
        createdAt: new Date(Date.now() - 1 * 60 * 60 * 1000).toISOString(),
      },
    ];

    return NextResponse.json({ templates });
  } catch (error) {
    console.error("Failed to fetch email templates:", error);
    return NextResponse.json(
      { error: "Failed to fetch email templates" },
      { status: 500 }
    );
  }
}

export async function POST(request: Request) {
  const session = await getSession();

  if (!session.isLoggedIn) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const body = await request.json();

    // Validate required fields
    if (!body.name || !body.subject) {
      return NextResponse.json(
        { error: "Name and subject are required" },
        { status: 400 }
      );
    }

    // In production, save to database
    const newTemplate = {
      id: Date.now().toString(),
      name: body.name,
      subject: body.subject,
      description: body.description || "",
      content: body.content || "",
      createdAt: new Date().toISOString(),
    };

    return NextResponse.json(newTemplate, { status: 201 });
  } catch (error) {
    console.error("Failed to create email template:", error);
    return NextResponse.json(
      { error: "Failed to create email template" },
      { status: 500 }
    );
  }
}

export async function DELETE(request: Request) {
  const session = await getSession();

  if (!session.isLoggedIn) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const body = await request.json();

    if (!body.id) {
      return NextResponse.json(
        { error: "Template ID is required" },
        { status: 400 }
      );
    }

    // In production, delete from database
    return NextResponse.json({ success: true });
  } catch (error) {
    console.error("Failed to delete email template:", error);
    return NextResponse.json(
      { error: "Failed to delete email template" },
      { status: 500 }
    );
  }
}
