<script lang="ts">
  export let maxPage: number;
  import clsx from "clsx";
  import { currentPage } from "$lib/stores";

  function top() {
    if (window) {
      window.scrollTo({
        top: 0,
        left: 0,
        behavior: "smooth",
      });
    }
  }
</script>

<div id="pagination" class="join mb-4 flex justify-center">
  <button
    class={clsx("join-item btn", $currentPage <= 1 && "btn-disabled")}
    on:click={() => {
      $currentPage = Math.max($currentPage - 1, 1);
      top();
    }}>«</button
  >
  <button
    class="join-item btn w-[8ch]"
    on:click={() => {
      $currentPage = 1;
      top();
    }}>{$currentPage}/{maxPage}</button
  >
  <button
    class={clsx("join-item btn", $currentPage >= maxPage && "btn-disabled")}
    on:click={() => {
      $currentPage = Math.min($currentPage + 1, maxPage);
      top();
    }}>»</button
  >
</div>
