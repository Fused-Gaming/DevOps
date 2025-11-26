// Rate limiting for authentication endpoints
// Provides in-memory rate limiting to prevent brute force attacks

interface RateLimitEntry {
  count: number;
  resetTime: number;
  lastAttempt: number;
}

class RateLimiter {
  private attempts = new Map<string, RateLimitEntry>();
  private readonly maxAttempts: number;
  private readonly windowMs: number;
  private readonly blockDurationMs: number;

  constructor(
    maxAttempts: number = 5,
    windowMs: number = 15 * 60 * 1000, // 15 minutes
    blockDurationMs: number = 30 * 60 * 1000 // 30 minutes
  ) {
    this.maxAttempts = maxAttempts;
    this.windowMs = windowMs;
    this.blockDurationMs = blockDurationMs;

    // Cleanup old entries every 5 minutes
    setInterval(() => this.cleanup(), 5 * 60 * 1000);
  }

  /**
   * Check if an IP is rate limited
   * @param identifier - Usually IP address or username
   * @returns Object with isLimited flag and retry info
   */
  check(identifier: string): {
    isLimited: boolean;
    remaining: number;
    resetTime: number;
    retryAfter?: number;
  } {
    const now = Date.now();
    const entry = this.attempts.get(identifier);

    // No previous attempts
    if (!entry) {
      return {
        isLimited: false,
        remaining: this.maxAttempts,
        resetTime: now + this.windowMs,
      };
    }

    // Reset window has passed
    if (now > entry.resetTime) {
      this.attempts.delete(identifier);
      return {
        isLimited: false,
        remaining: this.maxAttempts,
        resetTime: now + this.windowMs,
      };
    }

    // Check if blocked
    if (entry.count >= this.maxAttempts) {
      const retryAfter = Math.ceil((entry.resetTime - now) / 1000);
      return {
        isLimited: true,
        remaining: 0,
        resetTime: entry.resetTime,
        retryAfter,
      };
    }

    // Still within limits
    return {
      isLimited: false,
      remaining: this.maxAttempts - entry.count,
      resetTime: entry.resetTime,
    };
  }

  /**
   * Record a failed attempt
   * @param identifier - Usually IP address or username
   */
  recordAttempt(identifier: string): void {
    const now = Date.now();
    const entry = this.attempts.get(identifier);

    if (!entry || now > entry.resetTime) {
      // First attempt or window reset
      this.attempts.set(identifier, {
        count: 1,
        resetTime: now + this.windowMs,
        lastAttempt: now,
      });
    } else {
      // Increment existing count
      entry.count++;
      entry.lastAttempt = now;

      // If max attempts reached, extend block time
      if (entry.count >= this.maxAttempts) {
        entry.resetTime = now + this.blockDurationMs;
      }

      this.attempts.set(identifier, entry);
    }
  }

  /**
   * Reset attempts for an identifier (e.g., on successful login)
   * @param identifier - Usually IP address or username
   */
  reset(identifier: string): void {
    this.attempts.delete(identifier);
  }

  /**
   * Get progressive delay based on attempt count
   * Implements exponential backoff
   * @param identifier - Usually IP address or username
   * @returns Delay in milliseconds
   */
  getProgressiveDelay(identifier: string): number {
    const entry = this.attempts.get(identifier);
    if (!entry) return 0;

    // Exponential backoff: 0ms, 1s, 2s, 4s, 8s...
    const delay = Math.min(
      Math.pow(2, entry.count - 1) * 1000,
      10000 // Max 10 seconds
    );

    return delay;
  }

  /**
   * Cleanup expired entries
   */
  private cleanup(): void {
    const now = Date.now();
    for (const [key, entry] of this.attempts.entries()) {
      if (now > entry.resetTime) {
        this.attempts.delete(key);
      }
    }
  }

  /**
   * Get current stats (for monitoring/debugging)
   */
  getStats(): {
    totalTracked: number;
    blockedCount: number;
  } {
    const now = Date.now();
    let blockedCount = 0;

    for (const entry of this.attempts.values()) {
      if (entry.count >= this.maxAttempts && now <= entry.resetTime) {
        blockedCount++;
      }
    }

    return {
      totalTracked: this.attempts.size,
      blockedCount,
    };
  }
}

// Export singleton instance
export const loginRateLimiter = new RateLimiter(
  5, // 5 attempts
  15 * 60 * 1000, // 15 minute window
  30 * 60 * 1000 // 30 minute block
);

/**
 * Extract client IP from request
 * Handles Vercel, Cloudflare, and other proxy headers
 */
export function getClientIP(request: Request): string {
  const headers = request.headers;

  // Check common proxy headers in order of preference
  const forwardedFor = headers.get('x-forwarded-for');
  if (forwardedFor) {
    // x-forwarded-for can contain multiple IPs, use the first one
    return forwardedFor.split(',')[0].trim();
  }

  const realIP = headers.get('x-real-ip');
  if (realIP) {
    return realIP;
  }

  // Cloudflare specific
  const cfConnectingIP = headers.get('cf-connecting-ip');
  if (cfConnectingIP) {
    return cfConnectingIP;
  }

  // Vercel specific
  const vercelForwardedFor = headers.get('x-vercel-forwarded-for');
  if (vercelForwardedFor) {
    return vercelForwardedFor.split(',')[0].trim();
  }

  // Fallback
  return 'unknown';
}
