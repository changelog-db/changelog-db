# changelog-db

The missing `changelog` field in package.json.

PyPI has it, and it's great! The JavaScript ecosystem should have it as well.

For now, here's a package changelog index. Manually collected (semi-automated with Emacs), best-effort, hopefully saves some time.

## Data format

Sort-of yaml-ish

Each line is an entry.

    "<pkg>": "<url>"
    # comments work
    "<pkg>": none
    
- pkg is either an npm package name, or in the form `<type>:<name>`.
- Types:
  - npm: no prefix
  - Browser extensions: `ext`
  - JSR: `jsr`
- url is the url to the changelog. As a special case, deprecated packages are marked as
  - `dep:<url>`
  - Where the URL is something to read about the deprecation.


## Roadmap

- Emacs command
- Shell command

## etc.

- `@types/*` are excluded.

- Top 1000 npm packages by number of dependents, number of dependencies, or pagerank score: [anvaka/npm rank](https://gist.github.com/anvaka/8e8fa57c7ee1350e3491).

  Or use <https://github.com/wooorm/npm-high-impact>. As of 2023-09-21 I've made sure its first 250 entries are added.

  ```typescript
  import {npmHighImpact} from 'https://esm.sh/npm-high-impact'
  import {load, dump} from "./web/src/lib/parser.ts"
  import {readFileSync} from "node:fs"
  function importData(){
      return load(readFileSync("./changelog-db.data").toString())
  }
  npmHighImpact.slice(200, 250).filter((k) => !importData().has(k)).map((k) => `https://npmjs.com/package/${k}`)
  ```

- `none` represents "I've checked and it doesn't have a changelog".

- Monorepo GitHub releases: If I can find a search term to narrow it down to the package, I'll try to do so. If not, the release page is recorded as the changelog URL instead.

- GitHub path links: [use `-` to refer to *the default branch*](https://stackoverflow.com/questions/64726262/is-there-a-stable-url-to-always-get-the-default-branch-in-github).

- We track the latest changelog, as the main use is for people looking for what's changed between their current version and a newly released version. For example, [node-config](https://github.com/node-config/node-config) uses GitHub Releases for new releases but has a History.md for releases before a certain point; only the former is tracked.

- Precedence: changelog in the project's website > changelog file > GitHub Releases or equivalent for other forges. This is roughly going by how pleasant the reading experience is. The one actually being actively updated always has the most precedence.

  There are exceptions, for example, Docusaurus's CHANGELOG.md is so big GitHub gave up rendering it on my device, so I used GitHub Releases instead.

## License

CC0.
