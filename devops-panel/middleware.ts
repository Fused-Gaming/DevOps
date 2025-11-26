import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';
import { getIronSession } from 'iron-session';

export interface SessionData {
  userId?: string;
  username?: string;
  isLoggedIn: boolean;
}

// Session configuration
const sessionOptions = {
  password: process.env.SESSION_SECRET || 'complex_password_at_least_32_characters_long_change_this_in_production',
  cookieName: 'devops_panel_session',
  cookieOptions: {
    secure: process.env.NODE_ENV === 'production',
  },
};

// Public routes that don't require authentication
const publicRoutes = ['/login', '/api/auth/login'];

// API routes that should be protected
const protectedApiRoutes = [
  '/api/deployments',
  '/api/milestones',
  '/api/github',
  '/api/auth/logout',
  '/api/auth/session',
];

export async function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;

  // Allow public routes
  if (publicRoutes.includes(pathname)) {
    return NextResponse.next();
  }

  // Allow static files and Next.js internals
  if (
    pathname.startsWith('/_next') ||
    pathname.startsWith('/favicon') ||
    pathname.includes('.')
  ) {
    return NextResponse.next();
  }

  try {
    // Get session from cookie
    const response = NextResponse.next();
    const session = await getIronSession<SessionData>(request, response, sessionOptions);

    // Check if user is logged in
    if (!session.isLoggedIn) {
      // Redirect to login for protected routes
      if (pathname === '/' || protectedApiRoutes.some(route => pathname.startsWith(route))) {
        const url = request.nextUrl.clone();
        url.pathname = '/login';
        return NextResponse.redirect(url);
      }
    }

    return response;
  } catch (error) {
    console.error('Middleware error:', error);
    // On error, redirect to login for safety
    const url = request.nextUrl.clone();
    url.pathname = '/login';
    return NextResponse.redirect(url);
  }
}

// Configure which routes use this middleware
export const config = {
  matcher: [
    /*
     * Match all request paths except for the ones starting with:
     * - _next/static (static files)
     * - _next/image (image optimization files)
     * - favicon.ico (favicon file)
     */
    '/((?!_next/static|_next/image|favicon.ico).*)',
  ],
};
