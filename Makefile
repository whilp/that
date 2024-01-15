EXE = ./that.com
LUADIR = ./.lua
LUAS = \
	foo/index.lua
FILES := $(LUAS)
REDBEAN = redbean
LUSTACHE_TAR = lustache.tgz
LUSTACHE = $(addprefix .lua/, \
	lustache.lua \
	lustache/context.lua \
	lustache/renderer.lua \
	lustache/scanner.lua \
)

.PHONY: run
run: $(EXE)
	$(EXE)

.PHONY: clean
clean:
	rm -f $(EXE) $(REDBEAN) $(LUSTACHE_TAR) $(LUSTACHE_FILES)

all: \
	$(EXE)

.PHONY: exe
exe: $(EXE)
$(EXE): $(REDBEAN) $(LUSTACHE) $(FILES)
	cp $< $@
	chmod +x $@
	zip -u $@ $(filter-out $<,$^)

deps: $(REDBEAN) $(LUSTACHE)

$(REDBEAN):
	curl -skL https://redbean.dev/redbean-2.2.com -o $@

.PHONY: lustache
lustache: $(LUSTACHE)

$(LUSTACHE_TAR):
	curl -skL https://github.com/Olivine-Labs/lustache/tarball/master -o $@

$(LUSTACHE): $(LUSTACHE_TAR)
	mkdir -p $(LUADIR)
	tar -xzf$< -C $(LUADIR) --strip=2 "Olivine-Labs-lustache-*/src/lustache*"