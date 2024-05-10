<script context="module">
  import a from "./Out.svelte";
  export { a };
</script>

<script>
  /** @type string */
  export let title;
  /** @type string */
  export let desc;
</script>

<svelte:head>
  <!-- Primary Meta Tags -->
  <title>{title} | ChangelogDB</title>
  <meta name="title" content="{title} | ChangelogDB" />
  {#if desc}
    <meta name="description" content={desc} />
  {/if}
</svelte:head>

<div class="prose mb-8">
  <slot />
</div>
