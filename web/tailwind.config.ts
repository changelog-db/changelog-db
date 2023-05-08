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
  content: ["./src/**/*.{html,js,svelte,ts}"],

  theme: {
    fontFamily: {
      sans: ["Roboto", ...cjkFallbackSans, "sans-serif"],
    },
    extend: {},
  },

  plugins: [],
};
