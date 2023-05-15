const cjkFallbackSans = [
  "'Noto Sans CJK TC'",
  "'Noto Sans TC'",
  "'jf-openhuninn'",
  "'jf-openhuninn-1.1'",
  "Microsoft Jhenghei",
  "Microsoft Yahei",
  "Meiryo",
  "Malgun Gothic",
];
export default {
  content: ["./src/**/*.{html,js,jsx,ts,tsx}"],

  theme: {
    fontFamily: {
      sans: ["Roboto", ...cjkFallbackSans, "sans-serif"],
    },
    extend: {},
  },

  plugins: [require("daisyui")],
  daisyui: {
    themes: ["pastel", "dracula"],
    darkTheme: "dracula",
  },
};
