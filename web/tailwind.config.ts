const cjkFallbackSans = [
  "'Noto Sans CJK TC'",
  "'Noto Sans TC'",
  "Microsoft Jhenghei",
  "Microsoft Yahei",
  "Meiryo",
  "Malgun Gothic",
];
export default {
  content: ["./src/**/*.{html,js,ts,svelte}"],

  theme: {
    fontFamily: {
      sans: ["Roboto", ...cjkFallbackSans, "sans-serif"],
    },
    extend: {},
  },

  plugins: [require("daisyui")],
  daisyui: {
    // Because daisyui prints straight to stdout and ends up in the
    // output of prettier-plugin-tailwindcss.
    // Surely it should be printing to stderr?
    logs: false,
    themes: [
      "cupcake",
      {
        // Dracula, but with neutral set to dracula's "neutral-content".
        // In builtin light themes neutral would be dark, but in
        // builtin dark themes neutral is still dark.
        dark: {
          primary: "#ff79c6",
          secondary: "#bd93f9",
          accent: "#ffb86c",
          neutral: "#d6d7db",
          "base-100": "#282a36",
          "base-content": "#f8f8f2",
          info: "#8be9fd",
          success: "#50fa7b",
          warning: "#f1fa8c",
          error: "#ff5555",
        },
      },
    ],
  },
};
