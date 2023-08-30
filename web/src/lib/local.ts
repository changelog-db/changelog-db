export function getCustom(): Map<string, string | null> {
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

export function setCustom(map: Map<string, string | null>) {
  localStorage.setItem(
    "changelog-db-custom",
    JSON.stringify(Object.fromEntries(map))
  );
}

/**
 * Add a custom entry to localStorage.
 * If `map` is given, also add it to the map.
 */
export function addCustom(
  pkg: string,
  url: string | null,
  map?: Map<string, string | null>
) {
  const current = getCustom();
  current.set(pkg, url);
  map?.set(pkg, url);
  setCustom(current);
}

/**
 * Remove a custom entry from localStorage.
 * If `map` is given, also remove it from the map.
 */
export function removeCustom(pkg: string, map?: Map<string, string | null>) {
  const current = getCustom();
  current.delete(pkg);
  map?.delete(pkg);
  setCustom(current);
}
