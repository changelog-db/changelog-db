<script lang="ts">
  import LogoNpm from "carbon-icons-svelte/lib/LogoNpm.svelte";
  import clsx from "clsx";
  import { browser } from "$app/environment";
  import { currentPage } from "$lib/stores";
  import { page } from "$app/stores";
  import Pages from "./Pages.svelte";

  import rawData from "../../../changelog-db.yaml";
  const data: [string, string][] = Object.entries(rawData);

  const url = $page.url;
  let rawInput = url.searchParams.get("q") || "";

  $: {
    if (
      url.searchParams.get("q") !== rawInput &&
      typeof history !== "undefined"
    ) {
      if (rawInput === "") {
        url.searchParams.delete("q");
      } else {
        url.searchParams.set("q", rawInput);
      }
      history.replaceState(null, "", url);
    }
  }
  $: searchInput = rawInput.trim();
  $: tokens = searchInput.split(/\s+/);
  $: filtered = data
    .filter(([pkg, _url]) => {
      return tokens.every((token) => pkg.includes(token));
    })
    .sort(([aPkg], [bPkg]) => {
      // Put prefix matches first
      if (searchInput.length > 0) {
        const a = aPkg.startsWith(searchInput);
        const b = bPkg.startsWith(searchInput);
        if (a && !b) return -1;
        if (b && !a) return 1;
      }
      return aPkg < bPkg ? -1 : 1;
    });

  const pageSize = 100;
  $: maxPage = Math.max(1, Math.ceil(filtered.length / pageSize));
  $: pageStart = pageSize * ($currentPage - 1);
  $: pageEnd = pageSize * $currentPage;
  // Reset page to 1 when `filtered` changes
  $: filtered, ($currentPage = 1);
</script>

<svelte:head>
  <!-- Primary Meta Tags -->
  <title>ChangelogDB</title>
  <meta name="title" content="ChangelogDB" />
  <meta
    name="description"
    content="An npm registry package changelog index. Manually collected, best-effort, hopefully saves some time."
  />

  <!-- Open Graph / Facebook -->
  <meta property="og:type" content="website" />
  <meta property="og:url" content="https://changelog-db.netlify.app/" />
  <meta
    property="og:image"
    content="https://changelog-db.netlify.app/og-image.png"
  />
  <meta property="og:title" content="ChangelogDB" />
  <meta
    property="og:description"
    content="An npm registry package changelog index. Manually collected, best-effort, hopefully saves some time."
  />

  <!-- Twitter -->
  <meta property="twitter:creator" content="@kisaragi_hiu" />
  <meta property="twitter:card" content="summary_large_image" />
  <meta property="twitter:url" content="https://changelog-db.netlify.app/" />
  <meta
    property="twitter:image"
    content="https://changelog-db.netlify.app/og-image.png"
  />
  <meta property="twitter:title" content="ChangelogDB" />
  <meta
    property="twitter:description"
    content="An npm registry package changelog index. Manually collected, best-effort, hopefully saves some time."
  />
</svelte:head>

<main class="mx-auto my-16 w-[95%] max-w-[40rem]">
  <div class="prose">
    <h1>ChangelogDB</h1>
    <p>The missing changelog field in package.json.</p>
    <p>
      PyPI has it, and it's great! The JavaScript ecosystem should have it as
      well.
    </p>
    <p>
      For now, here's a package changelog index. <a
        href="https://github.com/changelog-db/changelog-db/blob/-/changelog-db.yaml"
        target="_blank">Manually collected</a
      >
      (semi-automated with Emacs), best-effort, hopefully saves some time.
    </p>
  </div>
  <p class="mt-4">
    A project by <a
      class="link text-blue-400"
      href="https://twitter.com/kisaragi_hiu"
      target="_blank">@kisaragi_hiu</a
    >
    —
    <a
      class="link"
      href="https://www.buymeacoffee.com/kisaragihiu"
      target="_blank">help pay for my rent</a
    >
  </p>
  <p class="prose my-4 text-xs">
    <a href="https://github.com/changelog-db/changelog-db">Built with</a>{" "}
    Tailwind CSS, daisyUI, and SvelteKit.
  </p>
  <input
    type="search"
    placeholder={browser ? `Search ${data.length} entries` : "Loading"}
    class={clsx(
      "input input-bordered my-4 w-full transition",
      browser || "animate-pulse"
    )}
    bind:value={rawInput}
    disabled={!browser}
  />
  {#if filtered.length > 0}
    <Pages {maxPage} />
    <ul id="list" class="divide-y divide-neutral-content/25">
      {#each filtered.slice(pageStart, pageEnd) as [pkg, url] (pkg)}
        {#if url}
          <li class="flex h-12 w-full items-center space-x-1">
            <a
              class="link flex h-full w-11/12 items-center"
              target="_blank"
              href={url}
            >
              <span class="truncate">{pkg}</span>
            </a>
            <a
              class="link flex h-full w-1/12 items-center text-center"
              href="https://npmjs.com/package/{pkg}"
              target="_blank"
            >
              <span>
                <LogoNpm title="View {pkg} on npm" size={32} />
              </span>
            </a>
          </li>
        {/if}
      {/each}
    </ul>
    <Pages {maxPage} />
  {:else}
    <div class="my-4 space-y-2 text-center text-neutral-content">
      <h2 class="text-2xl font-bold">No matches!</h2>
      <div>
        Searching for <code class="text-primary">{searchInput}</code> on:
      </div>
      <ul class="space-y-2">
        <li>
          <a
            class="out link text-secondary"
            href="https://www.google.com/search?q={searchInput}">Google</a
          >
        </li>
        <li>
          <a
            class="out link text-secondary"
            href="https://www.npmjs.com/search?q={searchInput}">npm</a
          >
        </li>
      </ul>
    </div>
  {/if}
</main>
