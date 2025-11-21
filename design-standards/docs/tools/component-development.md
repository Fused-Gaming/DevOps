---
id: component-development
title: Component Development
sidebar_position: 6
---

# Component Development

Build components following VLN design standards.

## Component Template

```tsx
// components/ui/my-component.tsx
import { HTMLAttributes, forwardRef } from 'react';
import { cn } from '@/lib/utils';

interface MyComponentProps extends HTMLAttributes<HTMLDivElement> {
  variant?: 'primary' | 'secondary';
}

export const MyComponent = forwardRef<HTMLDivElement, MyComponentProps>(
  ({ className, variant = 'primary', children, ...props }, ref) => {
    return (
      <div
        ref={ref}
        className={cn(
          'rounded-vln p-4',
          variant === 'primary' && 'bg-vln-sage',
          variant === 'secondary' && 'bg-vln-sky',
          className
        )}
        {...props}
      >
        {children}
      </div>
    );
  }
);

MyComponent.displayName = 'MyComponent';
```

## Best Practices

- Use TypeScript
- Support ref forwarding
- Accept className for customization
- Use `cn()` utility for class merging
- Document props with JSDoc
- Add animations with Framer Motion

See [Components](/design-system/components) for examples.
