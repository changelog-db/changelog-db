<script lang="ts">
  export let maxPage: number;
  import clsx from "clsx";
  import { page } from "$lib/stores";

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
    class={clsx("join-item btn", $page <= 1 && "btn-disabled")}
    on:click={() => {
      $page = Math.max($page - 1, 1);
      top();
    }}>«</button
  >
  <button
    class="join-item btn w-[8ch]"
    on:click={() => {
      $page = 1;
      top();
    }}>{$page}/{maxPage}</button
  >
  <button
    class={clsx("join-item btn", $page >= maxPage && "btn-disabled")}
    on:click={() => {
      $page = Math.min($page + 1, maxPage);
      top();
    }}>»</button
  >
</div>
