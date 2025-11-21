import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

const config: Config = {
  title: 'VLN Design Standards',
  tagline: 'Design system, UI guidelines, and engineering standards for VLN products',
  favicon: 'img/favicon.svg',

  // Future flags, see https://docusaurus.io/docs/api/docusaurus-config#future
  future: {
    v4: true, // Improve compatibility with the upcoming Docusaurus v4
  },

  // Set the production url of your site here
  url: 'https://design.vln.gg',
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: '/',

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: 'Fused-Gaming', // Usually your GitHub org/user name.
  projectName: 'DevOps', // Usually your repo name.

  onBrokenLinks: 'warn',

  // Even if you don't use internationalization, you can use this field to set
  // useful metadata like html lang. For example, if your site is Chinese, you
  // may want to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          routeBasePath: '/', // Serve docs at the root
          editUrl:
            'https://github.com/Fused-Gaming/DevOps/tree/main/design-standards/',
        },
        blog: false, // Disable blog for design standards site
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    image: 'img/vln-social-card.jpg',
    colorMode: {
      respectPrefersColorScheme: true,
    },
    navbar: {
      title: 'VLN Design',
      logo: {
        alt: 'VLN Logo',
        src: 'img/logo.svg',
      },
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'designSidebar',
          position: 'left',
          label: 'Design System',
        },
        {
          type: 'docSidebar',
          sidebarId: 'toolsSidebar',
          position: 'left',
          label: 'Tools & Workflows',
        },
        {
          href: 'https://github.com/Fused-Gaming/DevOps',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Design System',
          items: [
            {
              label: 'Getting Started',
              to: '/getting-started',
            },
            {
              label: 'Colors',
              to: '/design-system/colors',
            },
            {
              label: 'Components',
              to: '/design-system/components',
            },
          ],
        },
        {
          title: 'Tools',
          items: [
            {
              label: 'Design Tools',
              to: '/tools/design-tools',
            },
            {
              label: 'Mockup Workflow',
              to: '/tools/mockup-workflow',
            },
            {
              label: 'ASCII Design',
              to: '/tools/ascii-design',
            },
          ],
        },
        {
          title: 'Resources',
          items: [
            {
              label: 'GitHub',
              href: 'https://github.com/Fused-Gaming/DevOps',
            },
            {
              label: 'DevOps Panel',
              href: 'https://vln.gg',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} VLN. All rights reserved.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
