<script lang="ts">
</script>

<svelte:head>
  <!-- Primary Meta Tags -->
  <title>ChangelogDB</title>
  <meta name="title" content="ChangelogDB" />
  <meta
    name="description"
    content="An npm registry package changelog index. Manually collected, best-effort, hopefully saves some time."
  />

  <!-- Open Graph / Facebook -->
  <meta property="og:type" content="website" />
  <meta property="og:url" content="https://changelog-db.netlify.app/" />
  <meta
    property="og:image"
    content="https://changelog-db.netlify.app/og-image.png"
  />
  <meta property="og:title" content="ChangelogDB" />
  <meta
    property="og:description"
    content="An npm registry package changelog index. Manually collected, best-effort, hopefully saves some time."
  />

  <!-- Twitter -->
  <meta property="twitter:creator" content="@kisaragi_hiu" />
  <meta property="twitter:card" content="summary_large_image" />
  <meta property="twitter:url" content="https://changelog-db.netlify.app/" />
  <meta
    property="twitter:image"
    content="https://changelog-db.netlify.app/og-image.png"
  />
  <meta property="twitter:title" content="ChangelogDB" />
  <meta
    property="twitter:description"
    content="An npm registry package changelog index. Manually collected, best-effort, hopefully saves some time."
  />
</svelte:head>

<div class="prose">
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
</div>
