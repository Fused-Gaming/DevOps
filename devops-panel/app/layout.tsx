import type { Metadata } from "next";
import { Inter, JetBrains_Mono } from "next/font/google";
import "./globals.css";
import { Analytics } from "@vercel/analytics/react";

const inter = Inter({
  subsets: ["latin"],
  variable: "--font-inter",
  display: "swap",
});

const jetbrainsMono = JetBrains_Mono({
  subsets: ["latin"],
  variable: "--font-jetbrains-mono",
  display: "swap",
});

export const metadata: Metadata = {
  title: {
    default: "DevOps Control Panel",
    template: "%s | DevOps Panel",
  },
  description:
    "Comprehensive DevOps control panel for managing deployments, milestones, and GitHub Actions",
  robots: {
    index: false,
    follow: false,
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className={`${inter.variable} ${jetbrainsMono.variable}`}>
      <body className="antialiased bg-vln-bg text-vln-white min-h-screen">
        <div className="bg-gradient-subtle min-h-screen">
          {children}
        </div>
        <Analytics />
      </body>
    </html>
  );
}
