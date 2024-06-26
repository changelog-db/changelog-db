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
    darkTheme: "night",
    themes: ["emerald", "night"],
  },
};
