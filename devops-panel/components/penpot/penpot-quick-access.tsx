"use client";

import { useState, useEffect } from "react";
import Card, { CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import Button from "@/components/ui/button";
import { Palette, ExternalLink, ArrowRight } from "lucide-react";
import Link from "next/link";

export default function PenpotQuickAccess() {
  const [fileCount, setFileCount] = useState<number>(0);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchFileCount();
  }, []);

  const fetchFileCount = async () => {
    try {
      const response = await fetch("/api/penpot/files");
      const data = await response.json();
      setFileCount(data.files?.length || 0);
    } catch (error) {
      console.error("Failed to fetch file count:", error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Card hover={false}>
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <Palette className="w-5 h-5 text-vln-purple" />
          Design System
        </CardTitle>
      </CardHeader>
      <CardContent>
        <div className="space-y-4">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-400">Design Files</p>
              <p className="text-2xl font-bold text-vln-purple">
                {loading ? "..." : fileCount}
              </p>
            </div>
            <Link href="/penpot">
              <button className="p-3 bg-vln-purple/20 hover:bg-vln-purple/30 rounded-lg transition-colors">
                <ArrowRight className="w-5 h-5 text-vln-purple" />
              </button>
            </Link>
          </div>

          <div className="space-y-2">
            <Link href="/penpot" className="block">
              <div className="flex items-center justify-between p-3 bg-vln-bg-lighter hover:bg-vln-bg-light rounded-lg transition-colors cursor-pointer">
                <span className="text-sm font-medium">Manage Designs</span>
                <ArrowRight className="w-4 h-4 text-gray-400" />
              </div>
            </Link>

            <a
              href="https://design.vln.gg"
              target="_blank"
              rel="noopener noreferrer"
              className="block"
            >
              <div className="flex items-center justify-between p-3 bg-vln-bg-lighter hover:bg-vln-bg-light rounded-lg transition-colors cursor-pointer">
                <span className="text-sm font-medium">Design Standards</span>
                <ExternalLink className="w-4 h-4 text-gray-400" />
              </div>
            </a>

            <a
              href="https://design.penpot.app"
              target="_blank"
              rel="noopener noreferrer"
              className="block"
            >
              <div className="flex items-center justify-between p-3 bg-vln-bg-lighter hover:bg-vln-bg-light rounded-lg transition-colors cursor-pointer">
                <span className="text-sm font-medium">Open Penpot</span>
                <ExternalLink className="w-4 h-4 text-gray-400" />
              </div>
            </a>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}
