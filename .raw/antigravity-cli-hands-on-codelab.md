Source: https://codelabs.developers.google.com/antigravity-cli-hands-on#5
Fetched: 2026-06-08

# Antigravity CLI — Hands-on Codelab (Step 5)

## Installation

macOS / Linux:
  curl -fsSL https://antigravity.google/cli/install.sh | bash

Windows PowerShell:
  irm https://antigravity.google/cli/install.ps1 | iex

## CLI flags

- `-p` / `--print`              — Non-interactive mode with direct prompt
- `--model`                     — Specify model for session
- `-c` / `--continue`           — Resume most recent conversation
- `--conversation`              — Resume previous conversation by ID
- `--dangerously-skip-permissions` — Auto-approve all tool requests
- `--sandbox`                   — Run with terminal restrictions enabled
- `--add-dir`                   — Add directory to workspace

## Slash commands

/help, /config, /artifact, /model, /clear, /exit, /quit, /planning, /fast,
/context, /permissions, /hooks, /mcp

Shell mode: press `!` to toggle shell access within Antigravity.

## Configuration

Location: ~/.gemini/antigravity-cli/settings.json

Key settings:
- colorScheme: dark | light | solarized light | solarized dark | colorblind-friendly variants
- model: currently selected model
- trustedWorkspaces: folders where permissions granted
- toolPermission: request-review | proceed-in-sandbox | always-proceed | strict

## Tool permission modes

- request-review (default): pauses before system-affecting actions
- proceed-in-sandbox: automatic execution within isolated container
- always-proceed: full autonomy without prompts
- strict: read-only; all non-read operations require approval

## Available models

- Gemini 3.5 Flash (Low, Medium, High)
- Gemini 3.1 Pro (Low, High)
- Claude Sonnet 4.6 (Thinking)
- Claude Opus 4.6 (Thinking)

Access via: agy models

## Trust prompt

On first launch in a new folder: "Do you trust the contents of this project?"
Required for Antigravity to read, edit, and execute files.
