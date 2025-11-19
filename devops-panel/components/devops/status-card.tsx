"use client";

import Card, { CardHeader, CardTitle, CardDescription, CardContent } from "@/components/ui/card";
import { LucideIcon } from "lucide-react";

interface StatusCardProps {
  title: string;
  description: string;
  icon: LucideIcon;
  status: "success" | "warning" | "error" | "info";
  value?: string | number;
  onClick?: () => void;
}

export default function StatusCard({
  title,
  description,
  icon: Icon,
  status,
  value,
  onClick,
}: StatusCardProps) {
  const statusColors = {
    success: "text-vln-success",
    warning: "text-vln-warning",
    error: "text-vln-error",
    info: "text-vln-info",
  };

  return (
    <Card onClick={onClick} hover={!!onClick}>
      <CardHeader>
        <div className="flex items-center justify-between">
          <CardTitle>{title}</CardTitle>
          <Icon className={`w-6 h-6 ${statusColors[status]}`} />
        </div>
        <CardDescription>{description}</CardDescription>
      </CardHeader>
      {value !== undefined && (
        <CardContent>
          <p className={`text-3xl font-bold ${statusColors[status]}`}>{value}</p>
        </CardContent>
      )}
    </Card>
  );
}
