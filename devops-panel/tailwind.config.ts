import type { Config } from "tailwindcss";

const config: Config = {
  darkMode: ["class"],
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    container: {
      center: true,
      padding: "2rem",
      screens: {
        "2xl": "1280px",
      },
    },
    extend: {
      colors: {
        vln: {
          // Base colors
          bg: "#0a0e0f",
          "bg-light": "#151a1c",
          "bg-lighter": "#1f2527",

          // Primary accents (Sage Green family - WCAG AAA compliant)
          sage: "#86d993",          // Brighter, more accessible sage
          "sage-light": "#a8e9b4",
          "sage-dark": "#5fb76f",

          // Secondary accents (Blue-Gray family)
          bluegray: "#7dd3fc",      // Brighter sky blue for better contrast
          "bluegray-light": "#bae6fd",
          "bluegray-dark": "#0ea5e9",

          // Tertiary accents (Amber for highlights and warnings)
          amber: "#fbbf24",
          "amber-light": "#fcd34d",
          "amber-dark": "#f59e0b",

          // Purple accents (for premium/special features)
          purple: "#c084fc",
          "purple-light": "#d8b4fe",
          "purple-dark": "#a855f7",

          // Semantic colors
          success: "#86d993",
          warning: "#fbbf24",
          error: "#ef4444",
          info: "#7dd3fc",

          // Text colors
          white: "#f8f9fa",
          gray: "#cbd5e1",
          "gray-dark": "#94a3b8",

          // Accent (default to sage for backwards compatibility)
          accent: "#86d993",
        },
      },
      borderRadius: {
        vln: "12px",
      },
      boxShadow: {
        "vln-glow": "0 0 12px #86d993",
        "vln-glow-blue": "0 0 12px #7dd3fc",
        "vln-glow-amber": "0 0 12px #fbbf24",
        "vln-glow-purple": "0 0 12px #c084fc",
        "vln-lift": "0 4px 6px rgba(0, 0, 0, 0.3)",
      },
      fontFamily: {
        sans: ["var(--font-inter)", "sans-serif"],
        mono: ["var(--font-jetbrains-mono)", "monospace"],
      },
    },
  },
  plugins: [],
};

export default config;
