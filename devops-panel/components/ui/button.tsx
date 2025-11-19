"use client";

import { motion } from "framer-motion";
import Link from "next/link";
import { ReactNode } from "react";
import { cn } from "@/lib/utils";

interface BaseButtonProps {
  children: ReactNode;
  variant?: "primary" | "secondary" | "ghost" | "danger";
  size?: "sm" | "md" | "lg";
  icon?: ReactNode;
  loading?: boolean;
}

interface ButtonAsButton extends BaseButtonProps {
  href?: never;
  className?: string;
  disabled?: boolean;
  onClick?: React.MouseEventHandler<HTMLButtonElement>;
  type?: "button" | "submit" | "reset";
}

interface ButtonAsLink extends BaseButtonProps {
  href: string;
  className?: string;
}

type ButtonProps = ButtonAsButton | ButtonAsLink;

export default function Button({
  children,
  variant = "primary",
  size = "md",
  icon,
  loading = false,
  className,
  ...props
}: ButtonProps) {
  const baseStyles = "font-semibold rounded-vln transition-all inline-flex items-center justify-center gap-2";

  const variants = {
    primary: "bg-vln-sage text-vln-bg hover:shadow-vln-glow disabled:opacity-50 disabled:cursor-not-allowed",
    secondary: "border-2 border-vln-sage text-vln-sage hover:bg-vln-sage hover:text-vln-bg disabled:opacity-50 disabled:cursor-not-allowed",
    ghost: "text-vln-sage hover:bg-vln-sage/10 disabled:opacity-50 disabled:cursor-not-allowed",
    danger: "bg-red-600 text-white hover:bg-red-700 disabled:opacity-50 disabled:cursor-not-allowed",
  };

  const sizes = {
    sm: "px-4 py-2 text-sm",
    md: "px-6 py-3 text-base",
    lg: "px-8 py-4 text-lg",
  };

  const content = (
    <>
      {loading && (
        <motion.div
          className="w-4 h-4 border-2 border-current border-t-transparent rounded-full"
          animate={{ rotate: 360 }}
          transition={{ duration: 1, repeat: Infinity, ease: "linear" }}
        />
      )}
      {icon && !loading && <span>{icon}</span>}
      {children}
    </>
  );

  const combinedClassName = cn(baseStyles, variants[variant], sizes[size], className);

  // If href is provided, render as Link
  if ("href" in props && props.href) {
    return (
      <Link href={props.href} className={combinedClassName}>
        <motion.div
          className="w-full h-full flex items-center justify-center gap-2"
          whileHover={{ scale: 1.02 }}
          whileTap={{ scale: 0.98 }}
        >
          {content}
        </motion.div>
      </Link>
    );
  }

  // Otherwise render as button
  const buttonProps = props as ButtonAsButton;
  const disabled = buttonProps.disabled || loading;

  return (
    <motion.button
      whileHover={!disabled ? { scale: 1.02 } : {}}
      whileTap={!disabled ? { scale: 0.98 } : {}}
      className={combinedClassName}
      disabled={disabled}
      onClick={buttonProps.onClick}
      type={buttonProps.type}
    >
      {content}
    </motion.button>
  );
}
