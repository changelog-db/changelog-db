.ONESHELL:

node_modules: package.json
	pnpm install

test:
	cat changelog-db.data |
	  sed s@'github.com/\([^/]*\)/\([^/]*\)/releases'@'ungh.cc/repos/\1/\2/releases'@ |
	  lychee - --accept 200,429

dev: node_modules
	cd web && make dev
