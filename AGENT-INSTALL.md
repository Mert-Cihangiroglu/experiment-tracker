# Agent install instructions — Lab Floor

**Audience:** Any coding agent on a **remote Linux server** (SSH, REPL, terminal assistant).

**Goal:** Install Lab Floor so the agent always knows what GPUs, tmux sessions, and experiments are active — without the user asking every time.

---

## Prerequisites

```bash
command -v python3 && python3 --version
command -v tmux    # optional but strongly recommended
command -v nvidia-smi  # optional; needed for GPU visibility
```

---

## Install procedure (follow in order)

### 1. Locate the kit

```bash
ls -la lab-floor/install.sh lab-floor/agent/INSTRUCTIONS.md lab-floor/scripts/lab
```

If missing, stop and tell the user to copy `lab-floor/` to the server first.

### 2. Run the installer

```bash
cd lab-floor
chmod +x install.sh scripts/lab
./install.sh
```

Expected output ends with `Lab Floor install complete.`

### 3. Verify installation

```bash
test -f ~/.lab/registry.yaml && echo "registry OK"
test -f ~/.lab/INSTRUCTIONS.md && echo "instructions OK"
test -x ~/.lab/lab && echo "cli OK"

export PATH="$HOME/.local/bin:$PATH"
lab status
```

### 4. Load agent instructions

Read and follow `~/.lab/INSTRUCTIONS.md` for the rest of the session and all future experiment work.

At the start of **every** session involving GPUs, tmux, training, or run folders:

```bash
lab status
cat ~/.lab/registry.yaml
```

Optional: run `lab context` and treat the output as session context.

### 5. Smoke test

Summarize for the user:

- which GPUs are free/busy
- active tmux sessions
- registered running experiments
- anything live on the system but **not** in the registry (backfill with `lab register`)

---

## Post-install: agent obligations

Whenever the user works with experiments, training, GPUs, tmux, or scattered run folders:

1. **Read** `~/.lab/registry.yaml` (or `lab list`)
2. **Run** `lab status` for a live GPU/tmux snapshot
3. **Register** new jobs before or immediately after launch:
   ```bash
   lab register \
     --id <short-kebab-id> \
     --path <absolute-run-dir> \
     --gpu 0,1 \
     --session "tmux:<session-name>" \
     --command "<exact launch command>" \
     --config <config-path-or-none> \
     --notes "<one line why>"
   ```
4. **Sync** when something looks wrong: `lab sync`
5. **Never** create `temp/`, `test2/`, or unregistered experiment folders at repo root

---

## Registering existing jobs (one-time audit)

If the server already has running jobs not in the registry:

```bash
nvidia-smi --query-compute-apps=pid,gpu_uuid,used_memory --format=csv 2>/dev/null || nvidia-smi
tmux ls 2>/dev/null || echo "no tmux"
nvidia-smi -L 2>/dev/null

for pid in $(nvidia-smi --query-compute-apps=pid --format=csv,noheader 2>/dev/null); do
  ps -p "$pid" -o pid,cmd --no-headers 2>/dev/null
done
```

For each running job, ask the user only when cwd/command is ambiguous. Otherwise infer from `ps` + tmux pane paths and register with `lab register`.

---

## Optional: wire into your editor or agent tool

See [`integrations/README.md`](integrations/README.md). Core Lab Floor does **not** depend on any specific product.

---

## Uninstall

```bash
rm -f ~/.local/bin/lab
rm -rf ~/.lab/lab ~/.lab/INSTRUCTIONS.md ~/.lab/QUICK-RULES.md
# Keep ~/.lab/registry.yaml unless the user wants it deleted
```

---

## File map after install

```
~/.lab/registry.yaml       # source of truth
~/.lab/INSTRUCTIONS.md     # agent playbook
~/.lab/QUICK-RULES.md      # short rules
~/.lab/lab                 # CLI binary
~/.local/bin/lab           # symlink on PATH
```
