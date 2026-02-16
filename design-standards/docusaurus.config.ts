import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

const config: Config = {
  title: 'VLN Design Standards',
  tagline: 'Design system, UI guidelines, and engineering standards for VLN products',
  favicon: 'img/favicon.ico',

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

  onBrokenLinks: 'throw',

  // Even if you don't use internationalization, you can use this field to set
  // useful metadata like html lang. For example, if your site is Chinese, you
  // may want to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  headTags: [
    {
      tagName: 'link',
      attributes: {
        rel: 'preconnect',
        href: 'https://fonts.googleapis.com',
      },
    },
    {
      tagName: 'link',
      attributes: {
        rel: 'stylesheet',
        href: 'https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&family=JetBrains+Mono:wght@400;700&display=swap',
      },
    },
  ],

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
    image: 'https://vln.gg/api/og/design',
    metadata: [
      { name: 'og:image',         content: 'https://vln.gg/api/og/design' },
      { name: 'og:image:width',   content: '1200' },
      { name: 'og:image:height',  content: '630' },
      { name: 'og:image:type',    content: 'image/png' },
      { name: 'og:type',          content: 'website' },
      { name: 'og:site_name',     content: 'VLN Design System' },
      { name: 'twitter:card',     content: 'summary_large_image' },
      { name: 'twitter:image',    content: 'https://vln.gg/api/og/design' },
      { name: 'twitter:site',     content: '@vlnsecurity' },
    ],
    colorMode: {
      respectPrefersColorScheme: true,
    },
    navbar: {
      title: 'VLN Design',
      logo: {
        alt: 'VLN Shield Logo',
        src: 'img/logo-light.svg',
        srcDark: 'img/logo.svg',
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
      copyright: `Copyright © ${new Date().getFullYear()} VLN. Built with Docusaurus.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
