<script lang="ts">
  import { LogoNpm } from "carbon-icons-svelte";
  import rawData from "../../../changelog-db.yaml";
  const data: [string, string][] = Object.entries(rawData);
  const count = data.length;

  let searchInput = "";
  $: filtered = data
    .filter(([pkg, _url]) => pkg.includes(searchInput))
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
  <meta property="og:title" content="ChangelogDB" />
  <meta
    property="og:description"
    content="An npm registry package changelog index. Manually collected, best-effort, hopefully saves some time."
  />

  <!-- Twitter -->
  <meta property="twitter:creator" content="@kisaragi_hiu" />
  <!-- <meta property="twitter:card" content="summary" /> -->
  <!-- <meta property="twitter:image" content="" /> -->
  <meta property="twitter:url" content="https://changelog-db.netlify.app/" />
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
    placeholder="Search {count} entries"
    class="input-bordered input my-4 w-full"
    bind:value={searchInput}
  />
  <ul class="divide-y divide-neutral-content/25">
    {#each filtered as [pkg, url] (pkg)}
      {#if url}
        <li class="flex h-12 w-full items-center space-x-1">
          <a class="link flex h-full w-11/12 items-center" href={url}>
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
</main>
