dist: build
build:
	npx vite build

preview: dist
	npx sirv dist

dev:
	npx vite dev

fmt:
	npx prettier --write .

fmt.check:
	npx prettier --check .

check:
	npx svelte-kit sync
	npx svelte-check --tsconfig ./tsconfig.json

check.watch:
	npx svelte-kit sync
	npx svelte-check --tsconfig ./tsconfig.json --watch
