<script lang="ts">
  import LogoNpm from "carbon-icons-svelte/lib/LogoNpm.svelte";
  import Delete from "carbon-icons-svelte/lib/Delete.svelte";
  import clsx from "clsx";
  import { browser } from "$app/environment";
  import { currentPage } from "$lib/stores";
  import { load, dump } from "$lib/parser";
  import { page } from "$app/stores";
  import { addCustom, removeCustom, getCustom } from "$lib/local";
  import Pages from "./Pages.svelte";

  import rawData from "../../../changelog-db.data?raw";
  const importedData = [...load(rawData)];

  let customData = getCustom();
  $: dataMap = new Map([...importedData, ...customData]);
  $: data = [...dataMap];

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
      if (tokens.every((token) => pkg.match(token))) {
        matchType = "pkg";
      } else if (
        tokens.every((token) => (url?.toLowerCase() || "none").match(token))
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
      // Then custom entries
      {
        const a = customData.has(aPkg);
        const b = customData.has(bPkg);
        if (a && !b) return -1;
        if (b && !a) return 1;
      }
      // Put pkg matches before url matches
      {
        const a = aMatchType === "pkg";
        const b = bMatchType === "pkg";
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

  function addEntryHandler() {
    const pkgInput = document.getElementById("pkgInput") as HTMLInputElement;
    const urlInput = document.getElementById("urlInput") as HTMLInputElement;
    const pkgValue = pkgInput.value.trim();
    const urlValue = urlInput.value.trim();
    let url: string | null = null;
    if (urlValue !== "") {
      url = urlValue;
    }
    if (pkgValue === "") {
      pkgInput.classList.add("input-error");
      return;
    }
    pkgInput.classList.remove("input-error");
    addCustom(pkgValue, url, customData);
    // Notify Svelte to update
    customData = customData;
    // Clear the fields
    pkgInput.value = "";
    urlInput.value = "";
  }
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
    {#if filtered.length !== data.length}
      <h2 class="-mt-2 text-center font-bold">{filtered.length} matches</h2>
    {/if}
    <ul id="list" class="divide-y divide-neutral/20">
      {#each filtered.slice(pageStart, pageEnd) as [pkg, url] (pkg)}
        {@const isCustom = customData.has(pkg)}
        <li class="flex h-12 w-full items-center space-x-1">
          <a
            class={`link flex h-full ${
              isCustom ? "w-10/12" : "w-11/12"
            } items-center truncate`}
            target="_blank"
            href={url || `https://npmjs.com/package/${pkg}`}
            title={url ? undefined : "No changelog found"}
          >
            <span class="truncate"
              >{pkg} <span class="opacity-75">({url || "none"})</span></span
            >
          </a>
          {#if isCustom}
            <button
              title="Delete custom entry"
              class="link h-full w-1/12"
              on:click={() => {
                removeCustom(pkg, customData);
                customData = customData;
              }}><Delete size={24} /></button
            >
          {/if}
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
            target="_blank"
            href="https://www.google.com/search?q={searchInput}">Google</a
          >
        </li>
        <li>
          <a
            class="out link text-secondary-focus"
            target="_blank"
            href="https://www.npmjs.com/search?q={searchInput}">npm</a
          >
        </li>
      </ul>
    </div>
  {/if}

  {#if browser}
    <div>
      <div class="prose">
        <h3 class="font-bold">Add a custom entry</h3>
        <p>
          Custom entries are saved in localStorage and take precedence over
          default entries.
        </p>
      </div>
      <form on:submit|preventDefault={addEntryHandler} class="pl-1">
        <div
          class={clsx(
            "flex flex-wrap items-end",
            "[&_.label]:flex-col [&_.label]:items-start",
            "[&_.label]:gap-1 [&_.label]:pl-0",
            "[&_.input]:input-bordered"
          )}
        >
          <label for="pkgInput" class="label">
            <span class="label-text">Package name</span>
            <input id="pkgInput" type="text" placeholder="abc" class="input" />
          </label>
          <label for="urlInput" class="label">
            <span class="label-text">Changelog URL</span>
            <input
              id="urlInput"
              type="text"
              placeholder="https://example.com"
              class="input"
            />
          </label>
        </div>
        <button class="btn">Add entry</button>
      </form>
      <div class="prose mt-4">
        <h3 class="font-bold">Import/Export</h3>
        <p>
          Right now this is a rudimentary version that copies the exported text
          to the clipboard.
        </p>
        <button
          class="btn"
          on:click={() => {
            const value = dump(customData);
            navigator.clipboard.writeText(value);
            console.log(value);
          }}>Export</button
        >
      </div>
    </div>
  {/if}
</main>
