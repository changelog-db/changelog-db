<script lang="ts">
  export let title: string;
  export let desc: string;
</script>

<svelte:head>
  <title>{title} | ChangelogDB</title>
  <meta name="title" content="{title} | ChangelogDB" />
  <meta name="description" content={desc} />
</svelte:head>

<div class="prose mb-8">
  <slot />
</div>
