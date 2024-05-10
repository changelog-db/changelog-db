import adapterNetlify from "@sveltejs/adapter-netlify";
import { mdsvex } from "mdsvex";
import { vitePreprocess } from "@sveltejs/vite-plugin-svelte";

/** @type {import('@sveltejs/kit').Config} */
const config = {
  preprocess:
    // When Svelte reads this file, the layout is found at the right place.
    // However, when svelte-language-server reads this file, it tries the path
    // relative to the file being edited, falls back to *repo root* if not
    // found, then errors if it's still not found. Since we're not at repo root,
    // it ends up always reporting an error. It should fall back to the location
    // of this file instead, but... it just doesn't.
    //
    // This hack suppresses the spurious error.
    (() => {
      try {
        return [
          vitePreprocess(),
          mdsvex({
            extensions: [".md"],
            layout: "./src/lib/MarkdownLayout.svelte",
          }),
        ];
      } catch {
        return;
      }
    })(),
  extensions: [".svelte", ".md"],
  kit: {
    adapter: adapterNetlify({
      edge: true,
    }),
  },
};

export default config;
