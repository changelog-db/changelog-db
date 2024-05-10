<script lang="ts">
  import "../src.css";
  import { page } from "$app/stores";
  const tabs = [
    ["/", "Home"],
    ["/changelogs", "Changelogs"],
  ];
</script>

<main class="mx-auto my-16 w-[95%] max-w-[40rem]">
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
  </div>
  <slot />
</main>
