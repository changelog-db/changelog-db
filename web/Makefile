dist: build
build:
	npx qwik build

build.client:
	npx vite build

build.types:
	npx tsc --incremental --noEmit

preview: dist
	npx sirv dist

dev:
	npx vite --mode ssr 2>/dev/null # to silence the "QWIK WARN Duplicate implementations of "JSXNode" found" warning.

dev.debug:
	node --inspect-brk ./node_modules/vite/bin/vite.js --mode ssr --force

fmt:
	prettier --write .

fmt.check:
	npx prettier --check .
