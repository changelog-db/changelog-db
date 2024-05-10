<script lang="ts">
  import "../src.css";
  import clsx from "clsx";
  import { page } from "$app/stores";
  const tabs = [
    ["/", "About"],
    ["/changelogs", "Changelogs"],
  ];
</script>

<main
  class={clsx(
    "mx-auto my-4 w-[95%] max-w-[60rem]",
    "lg:my-16 lg:flex lg:gap-x-4 lg:[&>div]:min-w-0",
  )}
>
  <div class="prose">
    <h1>ChangelogDB</h1>
    <div role="tablist" class="tabs tabs-bordered tabs-lg">
      {#each tabs as [href, title]}
        <a
          {href}
          role="tab"
          class={href === $page.url.pathname ? "tab tab-active" : "tab"}
          >{title}</a
        >
      {/each}
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
  </div>
  <div>
    <slot />
  </div>
</main>
