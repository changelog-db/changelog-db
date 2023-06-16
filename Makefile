.ONESHELL:

test:
	cat changelog-db.yaml |
	  sed s@'github.com/\([^/]*\)/\([^/]*\)/releases'@'ungh.cc/repos/\1/\2/releases'@ |
	  lychee - --accept 200,429

build:
	(cd web && $(MAKE) build)
