import { getSession } from "@/lib/auth/session";
import { NextResponse } from "next/server";

export async function POST(request: Request) {
  const session = await getSession();

  if (!session.isLoggedIn) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const body = await request.json();

    // Validate required fields
    if (!body.to || !body.subject || !body.html) {
      return NextResponse.json(
        { error: "Recipient, subject, and content are required" },
        { status: 400 }
      );
    }

    // Check if email service is configured
    const emailToken = process.env.EMAIL_SERVICE_TOKEN;
    if (!emailToken) {
      return NextResponse.json(
        { error: "Email service not configured" },
        { status: 503 }
      );
    }

    // In production, integrate with your email service (SendGrid, Resend, Mailgun, etc.)
    // Example with generic email service:
    // const response = await fetch("https://api.emailservice.com/send", {
    //   method: "POST",
    //   headers: {
    //     "Authorization": `Bearer ${emailToken}`,
    //     "Content-Type": "application/json",
    //   },
    //   body: JSON.stringify({
    //     to: body.to,
    //     subject: body.subject,
    //     html: body.html,
    //     from: process.env.EMAIL_FROM || "noreply@example.com",
    //   }),
    // });

    // Mock response for development
    const emailId = `email_${Date.now()}`;

    return NextResponse.json(
      {
        success: true,
        emailId,
        message: "Email queued for sending",
        to: body.to,
        subject: body.subject,
        sentAt: new Date().toISOString(),
      },
      { status: 202 }
    );
  } catch (error) {
    console.error("Failed to send email:", error);
    return NextResponse.json(
      { error: "Failed to send email" },
      { status: 500 }
    );
  }
}
