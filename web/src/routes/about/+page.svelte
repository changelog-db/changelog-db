<script lang="ts">
  const priorArt = [
    {
      name: "changelog-view",
      desc: "CLI only, as a viewer in the terminal. Has some support for other ecosystems. Guesses based on heuristics.",
    },
    {
      name: "npm-upgrade-browser",
      desc: "Fancy local browser UI. Grabs changelog via npm-fetch-changelog.",
    },
    {
      name: "npm-fetch-changelog",
      desc: "Is a library. Designed to fetch changelog for particular versions. Only supports GitHub. Utilizes GitHub Releases. Guesses based on basic heuristics: releases or changelog.md.",
    },
    {
      name: "changelog",
      desc: "CLI only, as a viewer in the terminal. Guesses based on basic heuristics: either supply the repo directly, or fetches the repo field from the corresponding package.json.",
    },
  ];
</script>

<svelte:head>
  <!-- Primary Meta Tags -->
  <title>About | ChangelogDB</title>
  <meta name="title" content="About | ChangelogDB" />
  <meta
    name="description"
    content="An npm registry package changelog index. Manually collected, best-effort, hopefully saves some time."
  />
</svelte:head>

<div class="prose mb-8">
  <p>
    ChangelogDB makes it less painful to read changelogs before upgrading your
    JavaScript dependencies. <a
      href="https://github.com/changelog-db/changelog-db/blob/-/changelog-db.data"
      rel="noreferrer noopener"
      target="_blank">A manually curated package → changelog URL mapping</a
    >
    is provided to hopefully make it more reliable than heuristics-based solutions.
  </p>
  <h2>Prior art and comparison</h2>
  <ul>
    {#each priorArt as { name, desc }}
      <li>
        <a
          target="_blank"
          rel="noreferrer noopener"
          class="font-bold"
          href="https://npmjs.com/package/{name}">npm:{name}</a
        >
        <p>{desc}</p>
      </li>
    {/each}
  </ul>
  <p>
    ChangelogDB provides a browser interface for looking up changelogs. As
    changelogs are generally written for humans (not well-structured), and to be
    read in the browser or an editor, providing a centralized viewer is a futile
    effort.
  </p>
  <h2>Why manually collect</h2>
  <a href="/why-manual">See this post</a>.
</div>
