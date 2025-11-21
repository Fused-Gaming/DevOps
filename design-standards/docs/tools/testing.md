---
id: testing
title: Testing
sidebar_position: 7
---

# Testing

Testing strategies for VLN components and applications.

## Unit Testing

```bash
# Run tests
pnpm test

# Watch mode
pnpm test:watch

# Coverage
pnpm test:coverage
```

## Component Testing

```tsx
import { render, screen } from '@testing-library/react';
import { Button } from '@/components/ui/button';

describe('Button', () => {
  it('renders with correct text', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByText('Click me')).toBeInTheDocument();
  });

  it('calls onClick handler', () => {
    const handleClick = jest.fn();
    render(<Button onClick={handleClick}>Click me</Button>);
    screen.getByText('Click me').click();
    expect(handleClick).toHaveBeenCalled();
  });
});
```

## E2E Testing

Use Playwright for end-to-end tests:

```bash
pnpm dlx playwright test
```

See [Responsive Testing](/responsive/testing) for UI testing.
