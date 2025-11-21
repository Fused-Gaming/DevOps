---
id: prototyping
title: Prototyping
sidebar_position: 4
---

# Prototyping

Create interactive prototypes with open source tools.

## Penpot Interactive Prototypes

Penpot supports Figma-like prototyping:
- Link frames together
- Add interactions (click, hover)
- Test flows in browser
- Share with stakeholders

## Code Prototypes

For complex interactions, prototype in code:

```tsx
// Quick prototype with Next.js
'use client';

import { useState } from 'react';
import { Button } from '@/components/ui/button';

export default function Prototype() {
  const [step, setStep] = useState(1);

  return (
    <div>
      {step === 1 && <Step1 onNext={() => setStep(2)} />}
      {step === 2 && <Step2 onNext={() => setStep(3)} />}
      {step === 3 && <Step3 />}
    </div>
  );
}
```

See [Component Development](/tools/component-development) for more.
