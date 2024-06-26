<script lang="ts">
  import LogoNpm from "carbon-icons-svelte/lib/LogoNpm.svelte";
  import Delete from "carbon-icons-svelte/lib/Delete.svelte";
  import Out from "$lib/Out.svelte";
  import clsx from "clsx";
  import { browser } from "$app/environment";
  import { currentPage } from "$lib/stores";
  import { load, dump } from "$lib/parser";
  import { safeMatch } from "$lib/helpers";
  import { page } from "$app/stores";
  import { addCustom, removeCustom, getCustom, setCustom } from "$lib/local";
  import Pages from "$lib/Pages.svelte";

  import rawData from "$lib/../../../changelog-db.data?raw";
  const importedData = load(rawData);

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
      if (tokens.every((token) => safeMatch(pkg, token))) {
        matchType = "pkg";
      } else if (
        tokens.every((token) => safeMatch(url?.toLowerCase() || "none", token))
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

  const pageSize = 50;
  $: maxPage = Math.max(1, Math.ceil(filtered.length / pageSize));
  $: pageStart = pageSize * ($currentPage - 1);
  $: pageEnd = pageSize * $currentPage;
  // Reset page to 1 when `filtered` changes
  $: filtered, ($currentPage = 1);

  function deleteEntryHandler(pkg: string, url: string | undefined) {
    const pkgInput = document.getElementById("pkgInput") as HTMLInputElement;
    const urlInput = document.getElementById("urlInput") as HTMLInputElement;
    removeCustom(pkg, customData);
    // Notify Svelte to update
    customData = customData;
    pkgInput.value = pkg;
    urlInput.value = url || ""; // empty URL input also means none
  }

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

  function removeDupEntriesHandler() {
    let duplicates: Set<string> = new Set();
    for (const [key, _value] of customData) {
      if (importedData.has(key)) {
        duplicates.add(key);
      }
    }
    for (const dup of duplicates) {
      customData.delete(dup);
    }
    // Notify Svelte to update
    customData = customData;
    setCustom(customData);
  }
</script>

<svelte:head>
  <!-- Primary Meta Tags -->
  <title>ChangelogDB</title>
  <meta name="title" content="ChangelogDB" />
  <meta
    name="description"
    content="An npm registry package changelog index, providing links to JavaScript package changelogs. Manually collected, best-effort, hopefully saves some time."
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
    content="An npm registry package changelog index, providing links to JavaScript package changelogs. Manually collected, best-effort, hopefully saves some time."
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
    content="An npm registry package changelog index, providing links to JavaScript package changelogs. Manually collected, best-effort, hopefully saves some time."
  />
</svelte:head>

<div class="flex items-center gap-x-2">
  <input
    type="search"
    placeholder={browser ? `Search ${data.length} entries` : "Loading"}
    class={clsx(
      "input input-bordered my-4 w-full flex-grow transition",
      browser || "animate-pulse",
    )}
    bind:value={rawInput}
    disabled={!browser}
  />
  <button
    title="Clear search field"
    class="btn flex-none"
    on:click={() => {
      rawInput = "";
    }}><Delete size={24} /></button
  >
</div>
{#if filtered.length > 0}
  <Pages {maxPage} />
  {#if filtered.length !== data.length}
    <h2 class="-mt-2 text-center font-bold">{filtered.length} matches</h2>
  {/if}
  <ul id="list" class="divide-y divide-neutral/20">
    {#each filtered.slice(pageStart, pageEnd) as [pkg, rawUrl] (pkg)}
      {@const isCustom = customData.has(pkg)}
      {@const isDeprecated = rawUrl?.startsWith("dep:")}
      <!-- Replace just once -->
      {@const url = rawUrl?.replace("dep:", "")}
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
            >{pkg} <span class="opacity-75">({isDeprecated ? "deprecated: " : ""}{url || "none"})</span></span
          >
        </a>
        {#if isCustom}
          <button
            title="Delete custom entry"
            class="link h-full w-1/12"
            on:click={() => deleteEntryHandler(pkg, url)}
            ><Delete size={24} /></button
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
  <div class="my-4 space-y-2 text-center text-base-content">
    <h2 class="text-2xl font-bold">No matches!</h2>
    <p>Some options to try:</p>
    <ul class="prose space-y-2">
      <li>TODO :repo/releases (GitHub, Gitea, Forgejo)</li>
      <li>TODO :repo/-/releases (GitLab)</li>
      <li>TODO :repo/refs (Sourcehut)</li>
    </ul>
    <p>
      Search for <code class="text-primary-focus">{searchInput}</code> on:
    </p>
    <ul class="prose space-y-2">
      <li>
        <Out href="https://www.google.com/search?q={searchInput}">Google</Out>
      </li>
      <li>
        <Out href="https://www.npmjs.com/search?q={searchInput}">npm</Out>
      </li>
    </ul>
  </div>
{/if}

{#if browser}
  <div>
    <form on:submit|preventDefault={addEntryHandler} class="pl-1">
      <div class="prose">
        <h3 class="font-bold">Add a custom entry</h3>
        <p>
          Custom entries are saved in localStorage and take precedence over
          default entries.
        </p>
      </div>
      <div
        class={clsx(
          "flex flex-wrap items-end",
          "[&_.label]:flex-col [&_.label]:items-start",
          "[&_.label]:gap-1 [&_.label]:pl-0",
          "[&_.input]:input-bordered",
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
    <div class="pl-1">
      <div class="prose">
        <p>
          After an update adds new entries, it may be desirable to remove custom
          entries that are currently shadowing built-in entries.
        </p>
      </div>
      <button class="btn" on:click={removeDupEntriesHandler}
        >Remove shadowing entries</button
      >
    </div>
    <div class="prose mt-4">
      <h3 class="font-bold">Import/Export</h3>
      <p>
        Right now this is a rudimentary version that copies the exported text to
        the clipboard.
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
