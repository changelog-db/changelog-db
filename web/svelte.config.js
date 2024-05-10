import adapterNetlify from "@sveltejs/adapter-netlify";
import { mdsvex } from "mdsvex";
import { vitePreprocess } from "@sveltejs/vite-plugin-svelte";

/** @type {import('@sveltejs/kit').Config} */
const config = {
  preprocess: [
    vitePreprocess(),
    mdsvex({ extensions: [".md"], layout: "./src/lib/MarkdownLayout.svelte" }),
  ],
  extensions: [".svelte", ".md"],
  kit: {
    adapter: adapterNetlify({
      edge: true,
    }),
  },
};

export default config;
