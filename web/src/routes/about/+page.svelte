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
  <p>
    Despite changelog conventions being somewhat regular, it is not actually
    possible to reliably predict where a project puts its changelogs (if it does
    provide it) without projects declaring this information themselves.
  </p>
  <ul>
    <li>
      File name differences: <code>/HISTORY.md</code>,
      <code>/CHANGELOG.md</code>, changelogs that aren't in Markdown like
      <code>/CHANGELOG.org</code>, upper case / lower case differences. The
      convention is to use <code>CHANGELOG.md</code>.
      <b
        >To determine this reliably would require a full copy of the project
        source code.</b
      >
    </li>
    <li>
      File location differences, especially in a monorepo: the path of a project
      within a monorepo is not predictable. The repository URL is also
      arbitrary, but projects declare it in package.json — the path does not
      have this luxary. The convention is to put subprojects in <code
        >/packages/[any category if necessary]/&lt;package-name&gt;</code
      >, but (a) the path is still unpredictable, and (b) many projects don't
      have a 1-to-1 mapping between the package name and its corresponding
      directory name.
      <b
        >To figure this out reliably also requires a full copy of the project
        source code.</b
      >
    </li>
    <li>
      Changelog file or Releases: some projects write their changelog in a
      dedicated file, some write it in the GitHub Release message; many do both.
      For monorepos, a changelog file is often better as GitHub Release's search
      function is… quite bad; but sometimes the changelog file isn't desirable,
      for instance because the file is too big to be rendered by GitHub, or
      because the project has branched and has multiple changelogs (like <a
        href="https://github.com/sveltejs/svelte/blob/f70c0370be345b051c1144473378207b6c08143b/packages/svelte/CHANGELOG.md"
        rel="noreferrer noopener"
        target="_blank">Svelte 5</a
      >
      and
      <a
        href="https://github.com/sveltejs/svelte/blob/f70c0370be345b051c1144473378207b6c08143b/packages/svelte/CHANGELOG-pre-5.md"
        rel="noreferrer noopener"
        target="_blank">Svelte 4</a
      > as of 2024-05-10).
    </li>
  </ul>
</div>
