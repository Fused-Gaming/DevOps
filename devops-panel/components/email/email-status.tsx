"use client";

import { useEffect, useState } from "react";
import Card from "@/components/ui/card";
import { MailCheck, AlertTriangle, Clock, CheckCircle } from "lucide-react";

interface EmailStatusData {
  sentToday: number;
  failedToday: number;
  pendingToday: number;
  successRate: number;
}

export default function EmailStatus() {
  const [status, setStatus] = useState<EmailStatusData>({
    sentToday: 0,
    failedToday: 0,
    pendingToday: 0,
    successRate: 0,
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchStatus();
  }, []);

  const fetchStatus = async () => {
    try {
      const response = await fetch("/api/email/status");
      const data = await response.json();
      setStatus(data);
    } catch (error) {
      console.error("Failed to fetch email status:", error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Card className="glow-lift-blue">
      <Card.Header>
        <Card.Title className="flex items-center gap-2">
          <MailCheck className="w-5 h-5 text-vln-blue" />
          Today&apos;s Email Activity
        </Card.Title>
      </Card.Header>

      <Card.Content>
        <div className="space-y-4">
          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-1">
              <div className="flex items-center gap-2">
                <CheckCircle className="w-4 h-4 text-green-500" />
                <span className="text-sm text-vln-gray">Sent</span>
              </div>
              <p className="text-2xl font-bold text-green-500">{status.sentToday}</p>
            </div>

            <div className="space-y-1">
              <div className="flex items-center gap-2">
                <Clock className="w-4 h-4 text-vln-blue" />
                <span className="text-sm text-vln-gray">Pending</span>
              </div>
              <p className="text-2xl font-bold text-vln-blue">{status.pendingToday}</p>
            </div>

            {status.failedToday > 0 && (
              <div className="space-y-1">
                <div className="flex items-center gap-2">
                  <AlertTriangle className="w-4 h-4 text-red-500" />
                  <span className="text-sm text-vln-gray">Failed</span>
                </div>
                <p className="text-2xl font-bold text-red-500">{status.failedToday}</p>
              </div>
            )}
          </div>

          <div className="pt-2 border-t border-vln-border">
            <div className="flex items-center justify-between">
              <span className="text-sm text-vln-gray">Success Rate</span>
              <span className="text-sm font-semibold text-vln-sage">
                {status.successRate}%
              </span>
            </div>
            <div className="mt-2 h-2 bg-vln-border rounded-full overflow-hidden">
              <div
                className="h-full bg-gradient-to-r from-vln-sage to-vln-blue transition-all duration-300"
                style={{ width: `${status.successRate}%` }}
              />
            </div>
          </div>
        </div>
      </Card.Content>
    </Card>
  );
}
