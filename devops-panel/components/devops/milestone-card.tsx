"use client";

import Card, { CardHeader, CardTitle, CardDescription, CardContent } from "@/components/ui/card";
import { Target } from "lucide-react";

interface MilestoneCardProps {
  title: string;
  description: string;
  progress: number;
  total: number;
}

export default function MilestoneCard({ title, description, progress, total }: MilestoneCardProps) {
  const percentage = total > 0 ? Math.round((progress / total) * 100) : 0;

  return (
    <Card hover={false}>
      <CardHeader>
        <div className="flex items-center justify-between">
          <CardTitle className="flex items-center gap-2">
            <Target className="w-5 h-5" />
            {title}
          </CardTitle>
          <span className="text-vln-sage font-bold">{percentage}%</span>
        </div>
        <CardDescription>{description}</CardDescription>
      </CardHeader>
      <CardContent>
        <div className="space-y-2">
          <div className="w-full bg-vln-bg-lighter rounded-full h-2">
            <div
              className="bg-vln-sage h-2 rounded-full transition-all duration-500"
              style={{ width: `${percentage}%` }}
            />
          </div>
          <p className="text-sm text-vln-gray">
            {progress} of {total} completed
          </p>
        </div>
      </CardContent>
    </Card>
  );
}
