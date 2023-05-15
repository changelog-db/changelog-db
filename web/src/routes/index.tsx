import { component$, useSignal, useComputed$ } from "@builder.io/qwik";
import type { DocumentHead } from "@builder.io/qwik-city";
import { SiNpm } from "@qwikest/icons/simpleicons";

import rawData from "../../../changelog-db.yaml";
const data: [string, string][] = Object.entries(rawData);
const count = data.length;

export default component$(() => {
  const searchInput = useSignal("");
  const filtered = useComputed$(() => {
    const query = searchInput.value;
    let value = data
      .filter(([pkg, _url]) => pkg.includes(query))
      .sort(([aPkg], [bPkg]) => {
        // Put prefix matches first
        if (query.length > 0) {
          const a = aPkg.startsWith(query);
          const b = bPkg.startsWith(query);
          if (a && !b) return -1;
          if (b && !a) return 1;
        }
        return aPkg < bPkg ? -1 : 1;
      });
    return value;
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
          class="link text-blue-400"
          href="https://twitter.com/kisaragi_hiu"
          target="_blank"
        >
          @kisaragi_hiu
        </a>
        {" — "}
        <a
          class="link"
          href="https://www.buymeacoffee.com/kisaragihiu"
          target="_blank"
        >
          help pay for my rent
        </a>
      </p>
      <p class="prose my-4 text-xs">
        <a href="https://github.com/changelog-db/changelog-db">Built with</a>{" "}
        Tailwind CSS, daisyUI, and Qwik.
      </p>
      <input
        type="search"
        placeholder={`Search ${count} entries`}
        class="input input-bordered my-4 w-full"
        bind:value={searchInput}
      />
      <ul>
        {filtered.value.map(([pkg, url]) => (
          <>
            {url && (
              <li class="flex h-12 w-full items-center space-x-1">
                <a class="link flex h-full w-11/12 items-center" href={url}>
                  <span class="truncate">{pkg}</span>
                </a>
                <a
                  class="link h-full w-1/12 text-right text-2xl"
                  href={`https://npmjs.com/package/${pkg}`}
                  target="_blank"
                >
                  <SiNpm class="inline" />
                </a>
              </li>
            )}
          </>
        ))}
      </ul>
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
