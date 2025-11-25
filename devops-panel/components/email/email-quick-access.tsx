"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import Card from "@/components/ui/card";
import Button from "@/components/ui/button";
import { Mail, Settings, MailPlus, AlertCircle } from "lucide-react";

interface EmailStats {
  totalTemplates: number;
  pendingEmails: number;
  failedEmails: number;
  isConfigured: boolean;
}

export default function EmailQuickAccess() {
  const [stats, setStats] = useState<EmailStats>({
    totalTemplates: 0,
    pendingEmails: 0,
    failedEmails: 0,
    isConfigured: false,
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchEmailStats();
  }, []);

  const fetchEmailStats = async () => {
    try {
      const response = await fetch("/api/email/stats");
      const data = await response.json();
      setStats(data);
    } catch (error) {
      console.error("Failed to fetch email stats:", error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Card className="glow-lift">
      <Card.Header>
        <Card.Title className="flex items-center gap-2">
          <Mail className="w-5 h-5 text-vln-sage" />
          Email System
        </Card.Title>
      </Card.Header>

      <Card.Content className="space-y-4">
        {!stats.isConfigured && (
          <div className="flex items-start gap-2 p-3 bg-amber-500/10 border border-amber-500/30 rounded-lg">
            <AlertCircle className="w-5 h-5 text-amber-500 flex-shrink-0 mt-0.5" />
            <p className="text-sm text-amber-100">Email service not configured. Add credentials in settings.</p>
          </div>
        )}

        <div className="space-y-2">
          <div className="flex justify-between items-center">
            <span className="text-sm text-vln-gray">Email Templates</span>
            <span className="text-lg font-semibold text-vln-sage">
              {stats.totalTemplates}
            </span>
          </div>
          <div className="flex justify-between items-center">
            <span className="text-sm text-vln-gray">Pending Emails</span>
            <span className="text-lg font-semibold text-vln-blue">
              {stats.pendingEmails}
            </span>
          </div>
          {stats.failedEmails > 0 && (
            <div className="flex justify-between items-center">
              <span className="text-sm text-vln-gray">Failed Emails</span>
              <span className="text-lg font-semibold text-red-500">
                {stats.failedEmails}
              </span>
            </div>
          )}
        </div>

        <div className="flex gap-2 pt-2">
          <Link href="/email" className="flex-1">
            <Button variant="primary" size="sm" className="w-full justify-center">
              <Mail className="w-4 h-4" />
              Manage
            </Button>
          </Link>
          <Link href="/email?tab=settings" className="flex-1">
            <Button variant="secondary" size="sm" className="w-full justify-center">
              <Settings className="w-4 h-4" />
              Config
            </Button>
          </Link>
        </div>
      </Card.Content>
    </Card>
  );
}
