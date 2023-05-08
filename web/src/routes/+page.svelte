<script>
  import rawData from "../../../changelog-db.yaml";
  const data = Object.entries(rawData);
  const count = data.length;

  function truncateURL(url) {
    return url.replace(/^https?:\/\//, "");
  }

  let searchInput = "";
  $: filtered = data.filter(([pkg, _url]) => pkg.includes(searchInput));
</script>

<svelte:head>
  <title>ChangelogDB</title>
  <meta
    property="description"
    value="An npm registry package changelog index. Manually collected, best-effort, hopefully saves some time."
  />
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

<main class="w-[95%] max-w-[40rem] mx-auto my-16">
  <div class="prose">
    <h1>ChangelogDB</h1>
    <p>The missing changelog field in package.json.</p>
    <p>
      PyPI has it, and it's great! The JavaScript ecosystem should have it as
      well.
    </p>
    <p>
      For now, here's a package changelog index. Manually collected
      (semi-automated with Emacs), best-effort, hopefully saves some time.
    </p>
  </div>
  <p class="mt-4">
    A project by <a
      class="text-blue-400"
      href="https://twitter.com/kisaragi_hiu"
      target="_blank">@kisaragi_hiu</a
    >
    —
    <a
      class="underline"
      href="https://www.buymeacoffee.com/kisaragihiu"
      target="_blank">help pay for my rent</a
    >
  </p>
  <input
    type="search"
    autocorrect="off"
    placeholder="Search {count} entries..."
    class="input input-bordered w-full mt-8 mb-4"
    bind:value={searchInput}
  />
  {#each filtered as [pkg, url] (pkg)}
    {#if url}
      <div class="flex w-full justify-between items-center space-x-1 h-12">
        <span class="w-7/12 truncate">{pkg}</span>
        <a class="w-5/12 truncate underline" href={url} target="_blank"
          >{truncateURL(url)}</a
        >
      </div>
    {/if}
  {/each}
</main>
<footer class="text-center text-sm">
  Built with Tailwind CSS, daisyUI, and SvelteKit.
</footer>
