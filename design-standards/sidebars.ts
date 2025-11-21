import type {SidebarsConfig} from '@docusaurus/plugin-content-docs';

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

/**
 * Creating a sidebar enables you to:
 - create an ordered group of docs
 - render a sidebar for each doc of that group
 - provide next/previous navigation

 The sidebars can be generated from the filesystem, or explicitly defined here.

 Create as many sidebars as you want.
 */
const sidebars: SidebarsConfig = {
  designSidebar: [
    'getting-started',
    {
      type: 'category',
      label: 'Design System',
      items: [
        'design-system/colors',
        'design-system/typography',
        'design-system/spacing',
        'design-system/components',
        'design-system/animations',
        'design-system/icons',
      ],
    },
    {
      type: 'category',
      label: 'Responsive Design',
      items: [
        'responsive/breakpoints',
        'responsive/layouts',
        'responsive/testing',
      ],
    },
    {
      type: 'category',
      label: 'Branding',
      items: [
        'branding/logo',
        'branding/voice-tone',
        'branding/assets',
      ],
    },
  ],
  toolsSidebar: [
    'tools/overview',
    {
      type: 'category',
      label: 'Design Tools',
      items: [
        'tools/design-tools',
        'tools/penpot-setup',
        'tools/mockup-workflow',
        'tools/ascii-design',
        'tools/prototyping',
      ],
    },
    {
      type: 'category',
      label: 'Development',
      items: [
        'tools/setup',
        'tools/component-development',
        'tools/testing',
      ],
    },
  ],
};

export default sidebars;
