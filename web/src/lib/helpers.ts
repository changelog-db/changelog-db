/** Like `str`.match(`regexp`) but does not throw. */
export function safeMatch(str: string, regexp: string | RegExp) {
  try {
    return str.match(regexp);
  } catch (_e) {
    return;
  }
}
