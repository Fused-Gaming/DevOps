"use client";

import { useState } from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { motion, AnimatePresence } from "framer-motion";
import {
  LayoutDashboard,
  GitBranch,
  Palette,
  Bug,
  Menu,
  X,
  LogOut,
} from "lucide-react";
import { cn } from "@/lib/utils";
import Button from "@/components/ui/button";

interface NavShellProps {
  children: React.ReactNode;
  user?: { username: string } | null;
  onLogout?: () => void;
}

interface NavItem {
  href: string;
  label: string;
  icon: React.ElementType;
}

const navItems: NavItem[] = [
  { href: "/", label: "Dashboard", icon: LayoutDashboard },
  { href: "/repositories", label: "Repositories", icon: GitBranch },
  { href: "/penpot", label: "Design", icon: Palette },
  { href: "/bugzilla", label: "Bugs", icon: Bug },
];

export default function NavShell({ children, user, onLogout }: NavShellProps) {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const pathname = usePathname();

  // Don't show nav on login page
  if (pathname === "/login") {
    return <>{children}</>;
  }

  return (
    <div className="min-h-screen bg-vln-bg">
      {/* Desktop Sidebar */}
      <aside className="hidden lg:fixed lg:inset-y-0 lg:flex lg:w-64 lg:flex-col">
        <div className="flex flex-col flex-grow border-r border-vln-sage/20 bg-vln-bg-light px-6 py-8">
          {/* Logo/Brand */}
          <div className="flex items-center gap-3 mb-8">
            <div className="w-10 h-10 rounded-vln bg-gradient-to-br from-vln-sage to-vln-bluegray flex items-center justify-center">
              <span className="text-xl font-bold text-vln-bg">V</span>
            </div>
            <div>
              <h2 className="text-lg font-bold text-vln-white">VLN DevOps</h2>
              <p className="text-xs text-vln-gray">Control Panel</p>
            </div>
          </div>

          {/* Navigation */}
          <nav className="flex-1 space-y-2">
            {navItems.map((item) => {
              const isActive = pathname === item.href;
              const Icon = item.icon;

              return (
                <Link
                  key={item.href}
                  href={item.href}
                  className={cn(
                    "flex items-center gap-3 px-4 py-3 rounded-vln transition-all",
                    isActive
                      ? "bg-vln-sage/20 text-vln-sage border border-vln-sage/30"
                      : "text-vln-gray hover:bg-vln-bg-lighter hover:text-vln-white"
                  )}
                >
                  <Icon className="w-5 h-5" />
                  <span className="font-medium">{item.label}</span>
                </Link>
              );
            })}
          </nav>

          {/* User info & Logout */}
          {user && (
            <div className="pt-6 border-t border-vln-sage/20">
              <div className="mb-4">
                <p className="text-xs text-vln-gray mb-1">Logged in as</p>
                <p className="text-sm font-semibold text-vln-white">
                  {user.username}
                </p>
              </div>
              {onLogout && (
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={onLogout}
                  icon={<LogOut className="w-4 h-4" />}
                  className="w-full justify-start"
                >
                  Logout
                </Button>
              )}
            </div>
          )}
        </div>
      </aside>

      {/* Mobile Header */}
      <div className="lg:hidden sticky top-0 z-40 flex items-center justify-between px-4 py-4 bg-vln-bg-light border-b border-vln-sage/20">
        <div className="flex items-center gap-3">
          <div className="w-8 h-8 rounded-vln bg-gradient-to-br from-vln-sage to-vln-bluegray flex items-center justify-center">
            <span className="text-sm font-bold text-vln-bg">V</span>
          </div>
          <h2 className="text-base font-bold text-vln-white">VLN DevOps</h2>
        </div>
        <button
          onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
          className="text-vln-sage p-2 hover:bg-vln-bg rounded-vln transition-colors"
        >
          {mobileMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
        </button>
      </div>

      {/* Mobile Menu */}
      <AnimatePresence>
        {mobileMenuOpen && (
          <motion.div
            initial={{ opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: "auto" }}
            exit={{ opacity: 0, height: 0 }}
            transition={{ duration: 0.2 }}
            className="lg:hidden bg-vln-bg-light border-b border-vln-sage/20 overflow-hidden"
          >
            <nav className="px-4 py-4 space-y-2">
              {navItems.map((item) => {
                const isActive = pathname === item.href;
                const Icon = item.icon;

                return (
                  <Link
                    key={item.href}
                    href={item.href}
                    onClick={() => setMobileMenuOpen(false)}
                    className={cn(
                      "flex items-center gap-3 px-4 py-3 rounded-vln transition-all",
                      isActive
                        ? "bg-vln-sage/20 text-vln-sage border border-vln-sage/30"
                        : "text-vln-gray hover:bg-vln-bg-lighter hover:text-vln-white"
                    )}
                  >
                    <Icon className="w-5 h-5" />
                    <span className="font-medium">{item.label}</span>
                  </Link>
                );
              })}
            </nav>
            {user && (
              <div className="px-4 pb-4 pt-2 border-t border-vln-sage/20">
                <p className="text-xs text-vln-gray mb-2">
                  Logged in as <span className="text-vln-white font-semibold">{user.username}</span>
                </p>
                {onLogout && (
                  <Button
                    variant="ghost"
                    size="sm"
                    onClick={() => {
                      setMobileMenuOpen(false);
                      onLogout();
                    }}
                    icon={<LogOut className="w-4 h-4" />}
                    className="w-full justify-start"
                  >
                    Logout
                  </Button>
                )}
              </div>
            )}
          </motion.div>
        )}
      </AnimatePresence>

      {/* Main Content */}
      <main className="lg:pl-64">
        <div className="min-h-screen">{children}</div>
      </main>
    </div>
  );
}
