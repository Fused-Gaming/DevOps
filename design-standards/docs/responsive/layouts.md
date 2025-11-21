---
id: layouts
title: Layout Patterns
sidebar_position: 2
---

# Layout Patterns

Common responsive layout patterns used in VLN products.

## Dashboard Layout

```tsx
<div className="flex flex-col md:flex-row">
  <Sidebar className="w-full md:w-64" />
  <Main className="flex-1" />
</div>
```

## Card Grid

```tsx
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
  <Card />
  <Card />
  <Card />
</div>
```

See [Breakpoints](/responsive/breakpoints) for more details.
