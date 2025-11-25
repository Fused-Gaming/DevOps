#!/usr/bin/env node
/**
 * Sync VLN colors to Penpot project
 * Usage: node scripts/sync-colors.js
 */

require('dotenv').config({ path: '.env.local' });

const VLN_COLORS = {
  backgrounds: {
    dark: '#0a0e0f',
    light: '#151a1c',
    lighter: '#1f2527',
  },
  sage: {
    main: '#86d993',
    light: '#a8e9b4',
    dark: '#5fb76f',
  },
  sky: {
    main: '#7dd3fc',
    light: '#bae6fd',
    dark: '#0ea5e9',
  },
  amber: {
    main: '#fbbf24',
    light: '#fcd34d',
    dark: '#f59e0b',
  },
  purple: {
    main: '#c084fc',
    light: '#d8b4fe',
    dark: '#a855f7',
  },
};

function hexToRgb(hex) {
  const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
  return result
    ? {
        r: parseInt(result[1], 16) / 255,
        g: parseInt(result[2], 16) / 255,
        b: parseInt(result[3], 16) / 255,
      }
    : null;
}

async function syncColors() {
  console.log('🎨 VLN Color Sync Tool');
  console.log('================================\n');

  const token = process.env.PENPOT_ACCESS_TOKEN;
  const projectId = process.env.PENPOT_PROJECT_ID;

  if (!token) {
    console.error('❌ Error: PENPOT_ACCESS_TOKEN not set');
    console.error('Please add your token to .env.local');
    process.exit(1);
  }

  // Flatten colors
  const colors = [];
  Object.entries(VLN_COLORS).forEach(([category, shades]) => {
    Object.entries(shades).forEach(([name, hex]) => {
      const rgb = hexToRgb(hex);
      colors.push({
        name: `VLN/${category}/${name}`,
        hex,
        rgb,
      });
    });
  });

  console.log(`📦 Prepared ${colors.length} colors for sync:\n`);

  colors.forEach(({ name, hex }) => {
    const color = `\x1b[38;2;${Math.round(hexToRgb(hex).r * 255)};${Math.round(
      hexToRgb(hex).g * 255
    )};${Math.round(hexToRgb(hex).b * 255)}m█████\x1b[0m`;
    console.log(`  ${color} ${name} - ${hex}`);
  });

  console.log('\n================================');
  console.log('✅ Color palette ready!');
  console.log('\nTo import into Penpot:');
  console.log('1. Open your Penpot project');
  console.log('2. Create a new shared library');
  console.log('3. Add colors manually using the hex codes above');
  console.log('4. Or use Penpot API when available');
  console.log('\nNote: Automated API sync coming soon!');
}

syncColors().catch((error) => {
  console.error('❌ Error:', error.message);
  process.exit(1);
});
