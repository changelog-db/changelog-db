export type CustomData = Map<string, string | null>;

export function load(input: string): CustomData {
  const lines = input.split("\n");
  const map: CustomData = new Map();
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

export function dump(map: CustomData) {
  const lines: string[] = [];
  map.forEach((value, key) => {
    lines.push(`"${key}": ${value ? `"${value}"` : "none"}`);
  });
  return lines.join("\n");
}
