dev:
	npx vite dev

build:
	npx vite build

preview: build
	(cd build && python -m http.server)

check:
	npx svelte-kit sync
	npx svelte-check --tsconfig ./tsconfig.json

check.watch:
	npx svelte-kit sync
	npx svelte-check --tsconfig ./tsconfig.json --watch
