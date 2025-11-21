---
id: components
title: Components
sidebar_position: 4
---

# Components

VLN component library with examples and usage guidelines. All components are built with Next.js, Tailwind CSS, and Framer Motion.

## Button Component

### Variants

```tsx
import { Button } from '@/components/ui/button';

// Primary button (default)
<Button variant="primary">
  Get Started
</Button>

// Secondary button
<Button variant="secondary">
  Learn More
</Button>

// Ghost button
<Button variant="ghost">
  Cancel
</Button>

// Danger button
<Button variant="danger">
  Delete
</Button>
```

### Sizes

```tsx
<Button size="sm">Small</Button>
<Button size="md">Medium (default)</Button>
<Button size="lg">Large</Button>
```

### With Icons

```tsx
import { Rocket, Download } from 'lucide-react';

<Button>
  <Rocket className="mr-2" size={20} />
  Deploy
</Button>

<Button>
  Download
  <Download className="ml-2" size={20} />
</Button>
```

### Implementation

```tsx
// components/ui/button.tsx
import { ButtonHTMLAttributes, forwardRef } from 'react';
import { cva, type VariantProps } from 'class-variance-authority';
import { cn } from '@/lib/utils';

const buttonVariants = cva(
  // Base styles
  'inline-flex items-center justify-center rounded-vln font-medium transition-all focus:outline-none focus:ring-2 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed',
  {
    variants: {
      variant: {
        primary: 'bg-vln-sage hover:bg-vln-sage-light text-vln-bg glow-lift',
        secondary: 'bg-vln-sky hover:bg-vln-sky-light text-vln-bg glow-lift-blue',
        ghost: 'bg-transparent hover:bg-vln-bg-lighter text-white',
        danger: 'bg-red-600 hover:bg-red-700 text-white',
      },
      size: {
        sm: 'px-4 py-2 text-sm',
        md: 'px-6 py-3 text-base',
        lg: 'px-8 py-4 text-lg',
      },
    },
    defaultVariants: {
      variant: 'primary',
      size: 'md',
    },
  }
);

interface ButtonProps
  extends ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {}

const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, ...props }, ref) => {
    return (
      <button
        className={cn(buttonVariants({ variant, size, className }))}
        ref={ref}
        {...props}
      />
    );
  }
);

Button.displayName = 'Button';

export { Button, buttonVariants };
```

## Card Component

### Basic Card

```tsx
import { Card } from '@/components/ui/card';

<Card>
  <h3 className="text-xl font-semibold mb-2">Card Title</h3>
  <p className="text-gray-400">Card content goes here</p>
</Card>
```

### Card with Hover Effect

```tsx
<Card hover glow>
  Content with lift and glow on hover
</Card>
```

### Implementation

```tsx
// components/ui/card.tsx
import { HTMLAttributes } from 'react';
import { motion } from 'framer-motion';
import { cn } from '@/lib/utils';

interface CardProps extends HTMLAttributes<HTMLDivElement> {
  hover?: boolean;
  glow?: boolean;
}

export function Card({
  children,
  className,
  hover = false,
  glow = false,
  ...props
}: CardProps) {
  const Component = hover ? motion.div : 'div';

  return (
    <Component
      className={cn(
        'bg-vln-bg-lighter rounded-vln p-6 border border-vln-bg-light',
        glow && 'glow-lift',
        className
      )}
      {...(hover && {
        whileHover: { y: -4 },
        transition: { duration: 0.2 }
      })}
      {...props}
    >
      {children}
    </Component>
  );
}
```

## Status Card

Specialized card for showing deployment or system status.

```tsx
import { StatusCard } from '@/components/devops/status-card';
import { Rocket } from 'lucide-react';

<StatusCard
  icon={Rocket}
  title="Production"
  status="Live"
  statusColor="sage"
  description="Last deployed 2 hours ago"
/>
```

### Implementation

```tsx
// components/devops/status-card.tsx
import { LucideIcon } from 'lucide-react';
import { motion } from 'framer-motion';
import { cn } from '@/lib/utils';

interface StatusCardProps {
  icon: LucideIcon;
  title: string;
  status: string;
  statusColor: 'sage' | 'sky' | 'amber' | 'red';
  description?: string;
}

export function StatusCard({
  icon: Icon,
  title,
  status,
  statusColor,
  description,
}: StatusCardProps) {
  const colorMap = {
    sage: 'text-vln-sage border-vln-sage',
    sky: 'text-vln-sky border-vln-sky',
    amber: 'text-vln-amber border-vln-amber',
    red: 'text-red-500 border-red-500',
  };

  return (
    <motion.div
      className="bg-vln-bg-lighter rounded-vln p-6 border-l-4 glow-lift"
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      whileHover={{ y: -4 }}
    >
      <div className="flex items-center gap-4 mb-4">
        <Icon className={colorMap[statusColor]} size={32} />
        <div>
          <h3 className="text-xl font-semibold">{title}</h3>
          <p className={cn('font-medium', colorMap[statusColor])}>
            {status}
          </p>
        </div>
      </div>
      {description && (
        <p className="text-sm text-gray-400">{description}</p>
      )}
    </motion.div>
  );
}
```

## Input Component

```tsx
import { Input } from '@/components/ui/input';

// Basic input
<Input
  type="email"
  placeholder="Enter your email"
  value={email}
  onChange={(e) => setEmail(e.target.value)}
/>

// With error state
<Input
  type="password"
  placeholder="Password"
  error="Password is required"
/>
```

### Implementation

```tsx
// components/ui/input.tsx
import { InputHTMLAttributes, forwardRef } from 'react';
import { cn } from '@/lib/utils';

interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
  error?: string;
}

const Input = forwardRef<HTMLInputElement, InputProps>(
  ({ className, error, ...props }, ref) => {
    return (
      <div className="w-full">
        <input
          className={cn(
            'w-full px-4 py-3 bg-vln-bg-lighter border rounded-vln',
            'text-white placeholder:text-gray-500',
            'focus:outline-none focus:ring-2 focus:ring-vln-sage',
            'transition-all',
            error
              ? 'border-red-500 focus:ring-red-500'
              : 'border-vln-bg-light focus:border-vln-sage',
            className
          )}
          ref={ref}
          {...props}
        />
        {error && (
          <p className="mt-2 text-sm text-red-500">{error}</p>
        )}
      </div>
    );
  }
);

Input.displayName = 'Input';

export { Input };
```

## Badge Component

```tsx
import { Badge } from '@/components/ui/badge';

<Badge variant="success">Active</Badge>
<Badge variant="warning">Pending</Badge>
<Badge variant="error">Failed</Badge>
<Badge variant="info">Info</Badge>
```

### Implementation

```tsx
// components/ui/badge.tsx
import { HTMLAttributes } from 'react';
import { cva, type VariantProps } from 'class-variance-authority';
import { cn } from '@/lib/utils';

const badgeVariants = cva(
  'inline-flex items-center rounded-full px-3 py-1 text-sm font-medium',
  {
    variants: {
      variant: {
        success: 'bg-vln-sage/20 text-vln-sage',
        warning: 'bg-vln-amber/20 text-vln-amber',
        error: 'bg-red-500/20 text-red-500',
        info: 'bg-vln-sky/20 text-vln-sky',
      },
    },
    defaultVariants: {
      variant: 'info',
    },
  }
);

interface BadgeProps
  extends HTMLAttributes<HTMLSpanElement>,
    VariantProps<typeof badgeVariants> {}

export function Badge({ className, variant, ...props }: BadgeProps) {
  return (
    <span className={cn(badgeVariants({ variant }), className)} {...props} />
  );
}
```

## Progress Bar

```tsx
import { ProgressBar } from '@/components/ui/progress-bar';

<ProgressBar value={75} max={100} color="sage" />
<ProgressBar value={50} max={100} color="sky" />
<ProgressBar value={25} max={100} color="amber" />
```

### Implementation

```tsx
// components/ui/progress-bar.tsx
interface ProgressBarProps {
  value: number;
  max: number;
  color?: 'sage' | 'sky' | 'amber' | 'purple';
  showLabel?: boolean;
}

export function ProgressBar({
  value,
  max,
  color = 'sage',
  showLabel = false,
}: ProgressBarProps) {
  const percentage = Math.round((value / max) * 100);

  const colorMap = {
    sage: 'bg-vln-sage',
    sky: 'bg-vln-sky',
    amber: 'bg-vln-amber',
    purple: 'bg-vln-purple',
  };

  return (
    <div className="w-full">
      <div className="w-full h-2 bg-vln-bg rounded-full overflow-hidden">
        <motion.div
          className={cn('h-full rounded-full', colorMap[color])}
          initial={{ width: 0 }}
          animate={{ width: `${percentage}%` }}
          transition={{ duration: 0.5 }}
        />
      </div>
      {showLabel && (
        <p className="mt-2 text-sm text-gray-400">{percentage}%</p>
      )}
    </div>
  );
}
```

## Component Guidelines

### Naming Conventions

```tsx
// ✅ Good: Clear, descriptive names
<StatusCard />
<DeploymentList />
<QuickActions />

// ❌ Bad: Vague or unclear
<Card1 />
<Widget />
<Thing />
```

### Props Interface

```tsx
// ✅ Good: Well-documented props
interface CardProps {
  /** Card title */
  title: string;
  /** Optional description */
  description?: string;
  /** Enable hover effect */
  hover?: boolean;
  /** Additional CSS classes */
  className?: string;
}

// ❌ Bad: No documentation
interface CardProps {
  title: string;
  desc?: string;
  h?: boolean;
  className?: string;
}
```

### Composition

```tsx
// ✅ Good: Composable components
<Card>
  <Card.Header>
    <Card.Title>Title</Card.Title>
  </Card.Header>
  <Card.Content>Content</Card.Content>
  <Card.Footer>Footer</Card.Footer>
</Card>

// Or use children
<Card>
  <h3>Custom content</h3>
  <p>Complete control</p>
</Card>
```

## Animation Guidelines

Use Framer Motion for consistent animations:

```tsx
import { motion } from 'framer-motion';

// Fade in
<motion.div
  initial={{ opacity: 0 }}
  animate={{ opacity: 1 }}
  transition={{ duration: 0.3 }}
>
  Content
</motion.div>

// Slide up
<motion.div
  initial={{ opacity: 0, y: 20 }}
  animate={{ opacity: 1, y: 0 }}
  transition={{ duration: 0.3 }}
>
  Content
</motion.div>

// Hover lift
<motion.div
  whileHover={{ y: -4 }}
  transition={{ duration: 0.2 }}
>
  Hover me
</motion.div>
```

## Related

- [Colors](/design-system/colors) - Color usage in components
- [Typography](/design-system/typography) - Text styles
- [Animations](/design-system/animations) - Animation patterns
- [Component Development](/tools/component-development) - Building components
