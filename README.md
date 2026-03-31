# Markdown Mention Highlight

A VS Code extension that highlights `@mentions` in Markdown files with a configurable color.

## Features

- Highlights `@mentions` (e.g. `@alice`, `@team-leads`) inline in any Markdown file
- Configurable highlight color via VS Code settings
- Non-destructive: merges with your existing token color customizations

## Installation

This extension is distributed as a `.vsix` file for local installation.

**Build the `.vsix`:**

```sh
cd markdown-mention-highlight
npm install
npm run compile
npx vsce package --no-dependencies
```

**Install in VS Code:**

```sh
code --install-extension markdown-mention-highlight-0.1.0.vsix
```

Or via the UI: open the Extensions panel, click the `...` menu, and choose **Install from VSIX...**.

## Configuration

| Setting                  | Type     | Default   | Description |
|--------------------------|----------|-----------|-------------|
| `mentionHighlight.color` | `string` | `#9b8fbf` | Hex color used to highlight `@mentions` in Markdown files |

Change the color in your VS Code settings:

```json
{
  "mentionHighlight.color": "#e06c75"
}
```

After changing the color, VS Code will prompt you to reload the window for the token color update to take effect.

## Development

**Prerequisites:** Node.js, npm, VS Code

```sh
npm install
```

- **Compile:** `npm run compile`
- **Watch mode:** `npm run watch`

### Testing in the Extension Development Host

1. Open this folder in VS Code
2. Press `F5` (or **Run → Start Debugging**)
3. A second VS Code window opens with the extension loaded
4. Open `test/mentions.md` in that window to see highlighting in action
5. After making changes, run **Developer: Reload Window** in the second window to pick them up

## How It Works

The extension injects a TextMate grammar into `text.html.markdown` (excluding code blocks and inline code) that matches the pattern `@[\w_-]+` and assigns it the scope `markup.mention.markdown`. On activation, it writes a token color rule for that scope into your global `editor.tokenColorCustomizations` setting using the configured color.

The scope `markup.mention.markdown` is intentionally generic — using a scope like `entity.name.tag` would cause themes to apply their own color (typically blue) rather than the configured one.

## Requirements

- VS Code 1.85.0 or later

## License

MIT
