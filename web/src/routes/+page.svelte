<script lang="ts">
  import LogoNpm from "carbon-icons-svelte/lib/LogoNpm.svelte";
  import clsx from "clsx";
  import { browser } from "$app/environment";
  import { currentPage } from "$lib/stores";
  import { load } from "$lib/parser";
  import { page } from "$app/stores";
  import Pages from "./Pages.svelte";

  import rawData from "../../../changelog-db.data?raw";
  const data = [...load(rawData)];

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
    .map((entry) => {
      const pkg = entry[0];
      const url = entry[1];
      let matchType: string | null = null;
      if (tokens.every((token) => pkg.includes(token))) {
        matchType = "pkg";
      } else if (
        tokens.every((token) => (url?.toLowerCase() || "none").includes(token))
      ) {
        matchType = "url";
      } else {
        matchType = null;
      }
      // Without the as it'd get typed as Array<string | null> even
      // though the first element cannot be null
      return [pkg, url, matchType] as [string, string | null, string | null];
    })
    .filter(([_pkg, _url, matchType]) => matchType)
    .sort(([aPkg, _aUrl, aMatchType], [bPkg, _bUrl, bMatchType]) => {
      // Put pkg prefix matches first
      if (searchInput.length > 0) {
        const a = aPkg.startsWith(searchInput);
        const b = bPkg.startsWith(searchInput);
        if (a && !b) return -1;
        if (b && !a) return 1;
      }
      // Put url matches after pkg matches
      if (aMatchType === "pkg" && bMatchType === "url") return -1;
      if (bMatchType === "pkg" && aMatchType === "url") return 1;
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
  <p class="prose mt-4">
    A project by <a href="https://twitter.com/kisaragi_hiu" target="_blank"
      >@kisaragi_hiu</a
    >
    —
    <a href="https://www.buymeacoffee.com/kisaragihiu" target="_blank"
      >help pay for my rent</a
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
    <h2 class="-mt-2 text-center font-bold">{filtered.length} matches</h2>
    <ul id="list" class="divide-y divide-neutral/20">
      {#each filtered.slice(pageStart, pageEnd) as [pkg, url] (pkg)}
        <li class="flex h-12 w-full items-center space-x-1">
          <a
            class="link flex h-full w-11/12 items-center truncate"
            target="_blank"
            href={url || `https://npmjs.com/package/${pkg}`}
            title={url ? undefined : "No changelog found"}
          >
            <span class="truncate"
              >{pkg} <span class="opacity-75">({url || "none"})</span></span
            >
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
      {/each}
    </ul>
    <Pages {maxPage} />
  {:else}
    <div class="my-4 space-y-2 text-center text-neutral">
      <h2 class="text-2xl font-bold">No matches!</h2>
      <div>
        Search for <code class="text-primary-focus">{searchInput}</code> on:
      </div>
      <ul class="space-y-2">
        <li>
          <a
            class="out link text-secondary-focus"
            href="https://www.google.com/search?q={searchInput}">Google</a
          >
        </li>
        <li>
          <a
            class="out link text-secondary-focus"
            href="https://www.npmjs.com/search?q={searchInput}">npm</a
          >
        </li>
      </ul>
    </div>
  {/if}
</main>
