import adapterNetlify from "@sveltejs/adapter-netlify";
import { mdsvex } from "mdsvex";
import { vitePreprocess } from "@sveltejs/vite-plugin-svelte";

/** @type {import('@sveltejs/kit').Config} */
const config = {
  preprocess: [
    vitePreprocess(),
    mdsvex({
      extensions: [".md"],
      // We have to specify the base path so that svelte language server can
      // find it in the right place. It falls back to repo root, but we're not
      // at repo root here.
      layout: `${import.meta.dirname}/src/lib/MarkdownLayout.svelte`,
    }),
  ],
  extensions: [".svelte", ".md"],
  kit: {
    adapter: adapterNetlify({
      edge: true,
    }),
  },
};

export default config;
