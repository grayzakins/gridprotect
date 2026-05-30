import type { Config } from "tailwindcss";

const config: Config = {
  darkMode: "class",
  content: ["./app/**/*.{ts,tsx}", "./components/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        sparse:  "#2E75B6",
        thermo:  "#E0A800",
        dense:   "#C0392B",
        navy:    "#1F3864",
      },
      fontFamily: {
        sans: ["Inter", "system-ui", "sans-serif"],
        mono: ["JetBrains Mono", "monospace"],
      },
      animation: {
        "fade-in": "fade-in 0.35s ease",
        "pulse-ring": "pulse-ring 2s cubic-bezier(0.455,0.03,0.515,0.955) infinite",
      },
      keyframes: {
        "fade-in": {
          from: { opacity: "0", transform: "translateY(4px)" },
          to:   { opacity: "1", transform: "translateY(0)" },
        },
        "pulse-ring": {
          "0%,100%": { "box-shadow": "0 0 0 0 rgba(46,117,182,0.4)" },
          "70%":     { "box-shadow": "0 0 0 10px rgba(46,117,182,0)" },
        },
      },
    },
  },
  plugins: [],
};
export default config;
