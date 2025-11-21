---
id: animations
title: Animations
sidebar_position: 5
---

# Animations

VLN uses Framer Motion for smooth, performant animations.

## Common Patterns

### Fade In
```tsx
<motion.div
  initial={{ opacity: 0 }}
  animate={{ opacity: 1 }}
  transition={{ duration: 0.3 }}
>
  Content
</motion.div>
```

### Slide Up
```tsx
<motion.div
  initial={{ opacity: 0, y: 20 }}
  animate={{ opacity: 1, y: 0 }}
>
  Content
</motion.div>
```

### Hover Effects
```tsx
<motion.div whileHover={{ y: -4, scale: 1.02 }}>
  Hover me
</motion.div>
```

See [Framer Motion Docs](https://www.framer.com/motion/) for more.
