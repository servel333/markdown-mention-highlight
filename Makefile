NAME    := $(shell node -p "require('./package.json').name")
VERSION := $(shell node -p "require('./package.json').version")
VSIX    := $(NAME)-$(VERSION).vsix

.PHONY: build watch package install uninstall clean

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
