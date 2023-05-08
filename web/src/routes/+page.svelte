<script>
  import rawData from "../../../changelog-db.yaml";
  const data = Object.entries(rawData);
  const count = data.length;

  function truncateURL(url) {
    console.log(url);
    return url.replace(/^https?:\/\//, "");
  }

  let searchInput = "";
  $: filtered = data.filter(([pkg, _url]) => pkg.includes(searchInput));
</script>

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
