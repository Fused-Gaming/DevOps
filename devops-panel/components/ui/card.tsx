"use client";

import { motion } from "framer-motion";
import { ReactNode } from "react";
import { cn } from "@/lib/utils";

interface CardProps {
  children: ReactNode;
  className?: string;
  hover?: boolean;
  glow?: boolean;
  onClick?: () => void;
}

export default function Card({
  children,
  className,
  hover = true,
  glow = true,
  onClick,
}: CardProps) {
  const baseStyles = "p-6 border border-vln-sage/20 rounded-vln transition-all bg-vln-bg-light";

  return (
    <motion.div
      whileHover={hover ? { scale: 1.02, y: -4 } : {}}
      className={cn(
        baseStyles,
        glow && "glow-lift",
        hover && "card-lift cursor-pointer",
        className
      )}
      onClick={onClick}
    >
      {children}
    </motion.div>
  );
}

export function CardHeader({ children, className }: { children: ReactNode; className?: string }) {
  return <div className={cn("mb-4", className)}>{children}</div>;
}

export function CardTitle({ children, className }: { children: ReactNode; className?: string }) {
  return <h3 className={cn("text-xl font-bold text-vln-sage", className)}>{children}</h3>;
}

export function CardDescription({
  children,
  className,
}: {
  children: ReactNode;
  className?: string;
}) {
  return <p className={cn("text-vln-gray text-sm", className)}>{children}</p>;
}

export function CardContent({ children, className }: { children: ReactNode; className?: string }) {
  return <div className={cn(className)}>{children}</div>;
}

export function CardFooter({ children, className }: { children: ReactNode; className?: string }) {
  return <div className={cn("mt-4 pt-4 border-t border-vln-sage/20", className)}>{children}</div>;
}
