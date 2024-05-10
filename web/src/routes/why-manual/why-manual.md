---
title: Why manually collect
desc: Justifying giving up fully automating package → changelog relationship collection.
---

# Why manually collect

Despite changelog conventions being somewhat regular, it is not actually possible to reliably predict where a project
    puts its changelogs (if it does provide it) without projects declaring this information themselves.

- File name differences: `/HISTORY.md`, `/CHANGELOG.md`, changelogs that aren't in Markdown like `/CHANGELOG.org`, upper case / lower case differences. The convention is to use `CHANGELOG.md`. **To determine this reliably would require a full copy of the project source code.**
- File location differences, especially in a monorepo: the path of a project within a monorepo is not predictable. The repository URL is also arbitrary, but projects declare it in package.json — the path does not have this luxary. The convention is to put subprojects in `/packages/[any category if necessary]/<package-name>`, but (a) the path is still unpredictable, and (b) many projects don't have a 1-to-1 mapping between the package name and its corresponding directory name. **To figure this out reliably also requires a full copy of the project source code.**
- Changelog file or Releases: some projects write their changelog in a dedicated file, some write it in the GitHub Release message; many do both. For monorepos, a changelog file is often better as GitHub Release's search function is… quite bad; but sometimes the changelog file isn't desirable, for instance because the file is too big to be rendered by GitHub, or because the project has branched and has multiple changelogs (like [Svelte 5](https://github.com/sveltejs/svelte/blob/f70c0370be345b051c1144473378207b6c08143b/packages/svelte/CHANGELOG.md) and [Svelte 4](https://github.com/sveltejs/svelte/blob/f70c0370be345b051c1144473378207b6c08143b/packages/svelte/CHANGELOG-pre-5.md) as of 2024-05-10). **This requires manual curation to get right.**
- Some projects may simply host their changelogs on their website. An example of this is [sharp](https://sharp.pixelplumbing.com/changelog). Without projects having declared this information, the only way to find out is, again, manually.
- Wanting reliability means LLM-based AI solutions are very much out of the question.
