<script lang="ts">
  import "../src.css";
  import clsx from "clsx";
  import { page } from "$app/stores";
  const tabs = [
    ["/", "Changelog listing"],
    ["/about", "About"],
  ];
</script>

<div class="navbar lg:hidden">
  <div class="flex-1">
    <a href="/" class="text-xl hover:underline">ChangelogDB</a>
  </div>
  <div class="flex-none">
    <div role="tablist" class="tabs tabs-bordered">
      {#each tabs as [href, title]}
        <a
          {href}
          role="tab"
          class={href === $page.url.pathname ? "tab tab-active" : "tab"}
          >{title}</a
        >
      {/each}
    </div>
  </div>
</div>
<main
  class={clsx(
    "mx-auto my-4 w-[95%] max-w-[60rem]",
    "lg:my-16 lg:flex lg:gap-x-4 lg:[&>div]:min-w-0",
  )}
>
  <div class="max-lg:hidden lg:w-1/4">
    <div class="prose text-sm">
      <h1>ChangelogDB</h1>
      <p>The missing changelog field in package.json.</p>
      <p>
        PyPI has it, and it's great! The JavaScript ecosystem should have it as
        well.
      </p>
      <p>
        For now, here's a package changelog index. <a
          href="https://github.com/changelog-db/changelog-db/blob/-/changelog-db.data"
          target="_blank">Manually collected</a
        >
        (semi-automated with Emacs), best-effort, hopefully saves some time.
      </p>
      <p class="mt-6">
        By <a href="https://kisaragi-hiu.com" target="_blank">@kisaragi_hiu</a
        >.<br />
        <a href="https://www.buymeacoffee.com/kisaragihiu" target="_blank"
          >Buy me a meal</a
        >.
      </p>
      <p class="mt-6">
        <a href="https://github.com/changelog-db/changelog-db">Source code</a>.
      </p>
    </div>
  </div>
  <div class="lg:w-3/4">
    <slot />
  </div>
</main>
