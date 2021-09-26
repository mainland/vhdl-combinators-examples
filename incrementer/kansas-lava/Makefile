PKG_DESCRIPTION = incrementer.cabal
DEP = .cabal-sandbox
CONFIGURE = dist/setup-config

all: install dep run clean

install:
	stack install

$(DEP): $(PKG_DESCRIPTION)
	[ -e $(DEP) ] || (stack install)
	stack install --dependencies-only

dep: $(DEP)

run: $(CONFIGURE)
	stack run

clean:
	rm -rf .stack-work bin/incrementer *.lock
