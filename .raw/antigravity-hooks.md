# Google Antigravity Hooks Documentation

Source: https://antigravity.google/docs/hooks

In Google Antigravity, **hooks** are a mechanism for executing custom scripts, shell commands, or automated workflows at specific points during an agent's execution lifecycle.

## Key Concepts and Configurations

1. **Purpose:**
   Hooks allow users to enforce custom rules, run diagnostics (such as linters or testing suites), or trigger specific agent behaviors automatically.

2. **Configuration Formats:**
   * **Antigravity desktop/CLI environment:** Hooks are configured via a `hooks.json` file located in the customization directory or the project workspace root (e.g., `.agents/hooks.json` or `plugins/<plugin_name>/hooks.json`).
   * **Antigravity SDK:** Developers can implement lifecycle hooks programmatically using Python to observe and steer tool calls and agent behavior.

3. **Lifecycle Events:**
   * **SessionStart:** This is a common lifecycle event hook used to initialize session-specific resources, state, or to auto-install dependencies/plugins when a new agent session begins.

| Feature | Description |
|---|---|
| **JSON Hooks** | A simple format to intercept and control agent behavior by mapping events (e.g., `on_commit`, `on_file_save`) to actions. |
| **Lifecycle Hooks** | Available in the SDK to observe and steer every tool call, providing deep programmatic control. |
| **Behavioral Rules** | You can define rules in `.agent/rules/` that act as hooks, triggering validation or specific tasks when conditions are met. |
