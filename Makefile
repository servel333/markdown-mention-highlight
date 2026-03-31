NAME      := $(shell node -p "require('./package.json').name")
VERSION   := $(shell node -p "require('./package.json').version")
VSIX      := $(NAME)-$(VERSION).vsix
WATCH_LOG := .watch.log
WATCH_PID := .watch.pid

.PHONY: build clean help install package uninstall watch watch-bg watch-stop

default: help

help: #   ".......10|.......20|.......30|.......40|.......50|.......60|
	@echo "Available targets:"
	@echo "  make build             # Compile TypeScript"
	@echo "  make watch             # Compile and watch for changes"
	@echo "  make watch-bg          # Watch in background, output to console"
	@echo "  make watch-dt          # Watch in background detached, output to $(WATCH_LOG)"
	@echo "  make watch-stop        # Stop background watch (watch-bg or watch-dt)"
	@echo "  make package           # Build and package into .vsix"
	@echo "  make install           # Package and install into VS Code"
	@echo "  make uninstall         # Uninstall extension from VS Code"
	@echo "  make clean             # Remove build artifacts and .vsix"
	@echo ""
	@echo "  Debugging:"
	@echo "    NAME    = $(NAME)"
	@echo "    VERSION = $(VERSION)"
	@echo "    VSIX    = $(VSIX)"

build: ; npm run compile
clean: ; rm -rf out $(VSIX)
install: package ; code --install-extension $(VSIX)
package: build ; npx vsce package

uninstall:
	code --uninstall-extension $(shell node -p "const p=require('./package.json'); p.publisher+'.'+p.name")

watch   : ; npm run watch
watch-bg: ; npm run watch & echo $$! > $(WATCH_PID)

watch-dt:
	@if [ -f $(WATCH_PID) ] && kill -0 $$(cat $(WATCH_PID)) 2>/dev/null; then \
		echo "Watch already running (PID $$(cat $(WATCH_PID)))"; \
	else \
		npm run watch > $(WATCH_LOG) 2>&1 & echo $$! > $(WATCH_PID); \
		echo "Watch started (PID $$(cat $(WATCH_PID)), log: $(WATCH_LOG))"; \
	fi

watch-stop:
	@if [ -f $(WATCH_PID) ] && kill -0 $$(cat $(WATCH_PID)) 2>/dev/null; then \
		kill $$(cat $(WATCH_PID)) && rm $(WATCH_PID); \
		echo "Watch stopped"; \
	else \
		echo "Watch is not running"; rm -f $(WATCH_PID); \
	fi
