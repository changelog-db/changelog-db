export type CustomData = Map<string, string | null>;

export function getCustom(): CustomData {
  try {
    const value = localStorage.getItem("changelog-db-custom");
    if (value) {
      const parsed: Record<string, string | null> = JSON.parse(value);
      return new Map(Object.entries(parsed));
    } else {
      return new Map();
    }
  } catch (e) {
    return new Map();
  }
}

/** Write CustomData `map` to storage. */
export function setCustom(map: CustomData) {
  localStorage.setItem(
    "changelog-db-custom",
    JSON.stringify(Object.fromEntries(map))
  );
}

/** Retrieve CustomData, pass it to `updater`, then write the result to storage. */
export function updateCustom(updater: (current: CustomData) => CustomData) {
  const current = getCustom();
  setCustom(updater(current));
}

/**
 * Add a custom entry to localStorage.
 * If `map` is given, also add it to the map.
 */
export function addCustom(pkg: string, url: string | null, map?: CustomData) {
  updateCustom((current) => {
    current.set(pkg, url);
    map?.set(pkg, url);
    return current;
  });
}

/**
 * Remove a custom entry from localStorage.
 * If `map` is given, also remove it from the map.
 */
export function removeCustom(pkg: string, map?: CustomData) {
  updateCustom((current) => {
    current.delete(pkg);
    map?.delete(pkg);
    return current;
  });
}
