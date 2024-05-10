.PHONY: build preview dev fmt fmt.check check check.watch
build:
	npx vite build
	npx size-limit

preview: build
	npx sirv build

dev: node_modules
	npx svelte-kit sync
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
