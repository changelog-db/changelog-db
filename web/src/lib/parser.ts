export function load(input: string): Map<string, string | null> {
  const lines = input.split("\n");
  const map: Map<string, string | null> = new Map();
  lines.forEach((line) => {
    // Avoid rebuild with split
    const match = line.match(/^([^ #]*):(.*)/);
    if (match) {
      const key = match[1].trim().replace(/^"|"$/g, "");
      const value = match[2].trim().replace(/^"|"$/g, "");
      if (value === "none") {
        map.set(key, null);
      } else {
        map.set(key, value);
      }
    }
  });
  return map;
}
