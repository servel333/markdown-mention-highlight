# Mention Highlight Test

## Inline mentions

A simple mention: @alice

Multiple mentions on one line: @alice and @bob are working on this.

Mention at the start of a line: @charlie should review this.

Mention at end of line: assign to @diana

## Mention formats

- Underscore: @some_user
- Hyphen: @team-leads
- Numbers: @user123
- Mixed: @the-real_user1

## Should NOT highlight

- Email address: user@example.com
- Inside code: `@not-a-mention`
- Inside a code block:

```
@not-a-mention
```

## In other contexts

> Blockquote with @mention

**Bold with @mention**

_Italic with @mention_

| Column A    | Column B    |
|-------------|-------------|
| @alice      | @bob        |
