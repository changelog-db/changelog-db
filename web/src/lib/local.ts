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

export function updateCustom(
  updater: (current: Map<string, string | null>) => Map<string, string | null>
) {
  const current = getCustom();
  setCustom(updater(current));
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
export function removeCustom(pkg: string, map?: Map<string, string | null>) {
  updateCustom((current) => {
    current.delete(pkg);
    map?.delete(pkg);
    return current;
  });
}
