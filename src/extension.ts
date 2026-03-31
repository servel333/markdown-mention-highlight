import * as vscode from 'vscode';

const MENTION_SCOPE = 'entity.name.tag.mention.markdown';
const COLOR_SETTING = 'mentionHighlight.color';

function applyMentionColor(color: string): void {
  const config = vscode.workspace.getConfiguration();

  // Read existing tokenColorCustomizations so we don't overwrite other rules
  const existing = config.get<Record<string, unknown>>(
    'editor.tokenColorCustomizations',
    {}
  );

  const existingRules = Array.isArray(
    (existing as { textMateRules?: unknown[] }).textMateRules
  )
    ? ([...((existing as { textMateRules: unknown[] }).textMateRules)] as Array<
        Record<string, unknown>
      >)
    : [];

  // Replace or append the mention rule
  const ruleIndex = existingRules.findIndex(
    (r) => r['scope'] === MENTION_SCOPE
  );

  const mentionRule = {
    scope: MENTION_SCOPE,
    settings: { foreground: color },
  };

  if (ruleIndex >= 0) {
    existingRules[ruleIndex] = mentionRule;
  } else {
    existingRules.push(mentionRule);
  }

  config.update(
    'editor.tokenColorCustomizations',
    { ...existing, textMateRules: existingRules },
    vscode.ConfigurationTarget.Global
  );
}

export function activate(context: vscode.ExtensionContext): void {
  // Apply color from current config on activation
  const initialColor = vscode.workspace
    .getConfiguration()
    .get<string>(COLOR_SETTING, '#9b8fbf');

  applyMentionColor(initialColor);

  // Watch for color setting changes
  const disposable = vscode.workspace.onDidChangeConfiguration((event) => {
    if (!event.affectsConfiguration(COLOR_SETTING)) {
      return;
    }

    const newColor = vscode.workspace
      .getConfiguration()
      .get<string>(COLOR_SETTING, '#9b8fbf');

    applyMentionColor(newColor);

    vscode.window
      .showInformationMessage(
        'Mention highlight color updated. A window reload may be needed for token color changes to take effect.',
        'Reload Window'
      )
      .then((selection) => {
        if (selection === 'Reload Window') {
          vscode.commands.executeCommand('workbench.action.reloadWindow');
        }
      });
  });

  context.subscriptions.push(disposable);
}

export function deactivate(): void {}
