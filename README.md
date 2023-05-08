# changelog-db

The missing `changelog` field in package.json.

PyPI has it, and it's great! The JavaScript ecosystem should have it as well.

For now, here's a package changelog index. Manually collected (semi-automated with Emacs), best-effort, hopefully saves some time.

## Roadmap

- Emacs command
- Shell command

## etc.

`false` represents "I've checked and it doesn't have a changelog".

Monorepo GitHub releases: If I can find a search term to narrow it down to the package, I'll try to do so. If not, the release page is recorded as the changelog URL instead.

GitHub path links: [use `-` to refer to *the default branch*](https://stackoverflow.com/questions/64726262/is-there-a-stable-url-to-always-get-the-default-branch-in-github).

We track the latest changelog, as the main use is for people looking for what's changed between their current version and a newly released version. For example, [node-config](https://github.com/node-config/node-config) uses GitHub Releases for new releases but has a History.md for releases before a certain point; only the former is tracked.

When there are multiple equivalent files, usually I prefer CHANGELOG.md over GitHub Releases as the former is usually easier to read. Docusaurus is an example of an exception: the CHANGELOG.md is so big GitHub gave up rendering it on my device, so I used GitHub Releases instead.

## License

CC0.
