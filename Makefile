NAME    := $(shell node -p "require('./package.json').name")
VERSION := $(shell node -p "require('./package.json').version")
VSIX    := $(NAME)-$(VERSION).vsix

.PHONY: build clean help install package uninstall watch

default: help

help: #   ".......10|.......20|.......30|.......40|.......50|.......60|
	@echo "Available targets:"
	@echo "  make build             # Compile TypeScript"
	@echo "  make watch             # Compile and watch for changes"
	@echo "  make package           # Build and package into .vsix"
	@echo "  make install           # Package and install into VS Code"
	@echo "  make uninstall         # Uninstall extension from VS Code"
	@echo "  make clean             # Remove build artifacts and .vsix"
	@echo ""
	@echo "  Debugging:"
	@echo "    NAME    = $(NAME)"
	@echo "    VERSION = $(VERSION)"
	@echo "    VSIX    = $(VSIX)"

build:
	npm run compile

watch:
	npm run watch

package: build
	npx vsce package

install: package
	code --install-extension $(VSIX)

uninstall:
	code --uninstall-extension $(shell node -p "const p=require('./package.json'); p.publisher+'.'+p.name")

clean:
	rm -rf out $(VSIX)
