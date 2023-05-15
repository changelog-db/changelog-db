import { component$, useSignal, useComputed$ } from "@builder.io/qwik";
import type { DocumentHead } from "@builder.io/qwik-city";

import rawData from "../../../changelog-db.yaml";
const data: [string, string][] = Object.entries(rawData);
const count = data.length;

function truncateURL(url: string) {
  return url.replace(/^https?:\/\//, "");
}

export default component$(() => {
  const searchInput = useSignal("");
  const filtered = useComputed$(() => {
    return data.filter(([pkg, _url]) => pkg.includes(searchInput.value));
  });
  return (
    <main class="mx-auto my-16 w-[95%] max-w-[40rem]">
      <div class="prose">
        <h1>ChangelogDB</h1>
        <p>The missing changelog field in package.json.</p>
        <p>
          PyPI has it, and it's great! The JavaScript ecosystem should have it
          as well.
        </p>
        <p>
          For now, here's a package changelog index.{" "}
          <a
            href="https://github.com/changelog-db/changelog-db/blob/-/changelog-db.yaml"
            target="_blank"
          >
            Manually collected
          </a>{" "}
          (semi-automated with Emacs), best-effort, hopefully saves some time.
        </p>
      </div>
      <p class="mt-4">
        A project by{" "}
        <a
          class="text-blue-400"
          href="https://twitter.com/kisaragi_hiu"
          target="_blank"
        >
          @kisaragi_hiu
        </a>
        {" — "}
        <a
          class="underline"
          href="https://www.buymeacoffee.com/kisaragihiu"
          target="_blank"
        >
          help pay for my rent
        </a>
      </p>
      <input
        type="search"
        placeholder={`Search ${count} entries...`}
        class="input input-bordered mb-4 mt-8 w-full"
        bind:value={searchInput}
      />
      {filtered.value.map(([pkg, url]) => (
        <>
          {url && (
            <div class="flex h-12 w-full items-center justify-between space-x-1">
              <a
                class="w-7/12 truncate underline"
                href={`https://npmjs.com/package/${pkg}`}
              >
                {pkg}
              </a>
              <a class="w-5/12 truncate underline" href={url} target="_blank">
                {truncateURL(url)}
              </a>
            </div>
          )}
        </>
      ))}
      <footer class="text-center text-sm">
        Built with Tailwind CSS, daisyUI, and SvelteKit.
      </footer>
    </main>
  );
});

export const head: DocumentHead = {
  title: "ChangelogDB",
  meta: [
    { name: "title", content: "ChangelogDB" },
    {
      name: "description",
      content:
        "An npm registry package changelog index. Manually collected, best-effort, hopefully saves some time.",
    },
    { property: "og:type", content: "website" },
    { property: "og:url", content: "https://changelog-db.netlify.app/" },
    { property: "og:title", content: "ChangelogDB" },
    {
      property: "og:description",
      content:
        "An npm registry package changelog index. Manually collected, best-effort, hopefully saves some time.",
    },
    { property: "twitter:creator", content: "@kisaragi_hiu" },
    { property: "twitter:card", content: "summary" },
    { property: "twitter:image", content: "" },
    {
      property: "twitter:url",
      content: "https://changelog-db.netlify.app/",
    },
    { property: "twitter:title", content: "ChangelogDB" },
    {
      property: "twitter:description",
      content:
        "An npm registry package changelog index. Manually collected, best-effort, hopefully saves some time.",
    },
  ],
};
