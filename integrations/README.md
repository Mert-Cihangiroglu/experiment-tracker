# Optional integrations

Lab Floor core is just `~/.lab/` + the `lab` CLI. Nothing here is required.

Wire these into **whatever tool you use** — coding agent, IDE plugin, shell profile, or orchestrator — if it can run a command at session start and read stdout.

## Session context script

[`session-context.sh`](session-context.sh) prints `lab context` to stdout.

**Examples (adapt to your tool):**

```bash
# Shell profile — print lab state when you SSH in
lab status

# Agent session preamble — paste output into context
lab context

# Cron — snapshot every 5 min (optional audit log)
lab status >> ~/.lab/audit.log
```

### Bash login (optional)

Add to `~/.bashrc` or `~/.zshrc`:

```bash
if command -v lab >/dev/null 2>&1; then
  lab status 2>/dev/null | head -20
fi
```

### Agent system prompt (optional)

Add one line to your agent's project or global instructions:

```
At session start, run `lab status` and read ~/.lab/INSTRUCTIONS.md before any GPU or experiment work.
```

Or copy the contents of `~/.lab/QUICK-RULES.md`.

## Editor / agent hooks

If your tool supports **session-start hooks** that accept shell script stdout as extra context, point it at:

```bash
/path/to/lab-floor/integrations/session-context.sh
```

The script is generic — it only calls `lab context`. Configure the hook in your tool's own docs; Lab Floor does not ship product-specific config files.
