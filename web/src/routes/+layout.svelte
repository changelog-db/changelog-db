<script lang="ts">
  import "../src.css";
  import { page } from "$app/stores";
  const tabs = [
    ["/", "Changelog listing"],
    ["/about", "About"],
  ];
  const menu = [
    ["/", "Changelog listing"],
    ["/about", "About"],
    ["/why-manual", "Why manually collect"],
  ];
</script>

<main class={"mx-auto my-4 w-[95%]"}>
  <div class="navbar">
    <div class="flex-1">
      <a href="/"
         data-sveltekit-reload
         class="text-xl hover:underline">ChangelogDB</a>
    </div>
    <div class="flex-none lg:hidden">
      <div role="tablist" class="tabs tabs-bordered">
        {#each tabs as [href, title]}
          <a
            {href}
            data-sveltekit-reload
            role="tab"
            class={href === $page.url.pathname ? "tab tab-active" : "tab"}
            >{title}</a
          >
        {/each}
      </div>
    </div>
  </div>
  <div class="w-full lg:flex lg:gap-x-8 lg:[&>div]:min-w-0">
    <div class="max-lg:hidden lg:w-1/4">
      <ul class="menu p-0">
        {#each menu as [href, title]}
          <li>
            <a {href} data-sveltekit-reload class={href === $page.url.pathname ? "active" : undefined}
              >{title}</a
            >
          </li>
        {/each}
      </ul>
      <div class="prose text-sm">
        <p class="mt-6">
          By <a href="https://kisaragi-hiu.com" target="_blank">@kisaragi_hiu</a
          >.
          <a href="https://www.patreon.com/kisaragihiu" target="_blank"
            >Donate</a>
        <p class="mt-6">
          <a href="https://github.com/changelog-db/changelog-db">Source code</a
          >.
        </p>
      </div>
    </div>
    <div class="lg:w-3/4">
      <slot />
    </div>
  </div>
</main>
