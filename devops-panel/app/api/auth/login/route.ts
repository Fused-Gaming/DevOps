import { NextRequest, NextResponse } from "next/server";
import { getSession } from "@/lib/auth/session";
import { verifyCredentials } from "@/lib/auth/credentials";
import { loginRateLimiter, getClientIP } from "@/lib/auth/rate-limit";

export async function POST(request: NextRequest) {
  try {
    const { username, password } = await request.json();

    if (!username || !password) {
      return NextResponse.json(
        { error: "Username and password are required" },
        { status: 400 }
      );
    }

    // Get client IP for rate limiting
    const clientIP = getClientIP(request);
    const identifier = `${clientIP}:${username}`;

    // Check rate limit
    const rateLimitStatus = loginRateLimiter.check(identifier);

    if (rateLimitStatus.isLimited) {
      return NextResponse.json(
        {
          error: "Too many login attempts. Please try again later.",
          retryAfter: rateLimitStatus.retryAfter
        },
        {
          status: 429,
          headers: {
            'Retry-After': rateLimitStatus.retryAfter?.toString() || '1800',
            'X-RateLimit-Limit': '5',
            'X-RateLimit-Remaining': '0',
            'X-RateLimit-Reset': new Date(rateLimitStatus.resetTime).toISOString(),
          }
        }
      );
    }

    // Apply progressive delay based on previous failed attempts
    const delay = loginRateLimiter.getProgressiveDelay(identifier);
    if (delay > 0) {
      await new Promise(resolve => setTimeout(resolve, delay));
    }

    const isValid = await verifyCredentials(username, password);

    if (!isValid) {
      // Record failed attempt
      loginRateLimiter.recordAttempt(identifier);

      const updatedStatus = loginRateLimiter.check(identifier);

      return NextResponse.json(
        {
          error: "Invalid credentials",
          attemptsRemaining: updatedStatus.remaining
        },
        {
          status: 401,
          headers: {
            'X-RateLimit-Limit': '5',
            'X-RateLimit-Remaining': updatedStatus.remaining.toString(),
            'X-RateLimit-Reset': new Date(updatedStatus.resetTime).toISOString(),
          }
        }
      );
    }

    // Successful login - reset rate limit for this identifier
    loginRateLimiter.reset(identifier);

    const session = await getSession();
    session.userId = username;
    session.username = username;
    session.isLoggedIn = true;
    await session.save();

    return NextResponse.json({ success: true, username });
  } catch (error) {
    console.error("Login error:", error);
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}
