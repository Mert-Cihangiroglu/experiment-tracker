# Lab Floor — Agent Instructions

**Single source of truth:** `~/.lab/registry.yaml`

If a job is not in the registry, it does not exist. Keep the registry aligned with reality.

---

## Every session (mandatory)

Before experiment, GPU, tmux, or run-folder work:

```bash
lab status
cat ~/.lab/registry.yaml
```

If entries look stale: `lab sync` then `lab status` again.

Do this **before** suggesting paths, killing jobs, or launching new experiments.

---

## When launching a job

After any training launch (`torchrun`, `python train.py`, `accelerate launch`, `sbatch`, `tmux new` + train command):

```bash
lab register \
  --id <short-kebab-id> \
  --path <absolute-run-directory> \
  --gpu 0,1 \
  --session "tmux:<session-name>" \
  --command "<exact command>" \
  --config <config-path-or-omit> \
  --notes "<one-line purpose>"
lab status
```

**Naming rules:**

| Thing | Convention |
|-------|------------|
| Experiment id | `model-task-variant` kebab-case |
| tmux session | same as experiment id |
| Run directory | `runs/<date>-<id>/` or `experiments/<id>/` |
| Config | reference canonical config; do not copy unless sweeping |

Never create `temp/`, `test2/`, `new/`, or root-level scratch folders.

---

## When user is lost

1. `lab status`
2. `lab list`
3. `tmux ls`
4. `nvidia-smi` (if available)
5. Cross-reference registry vs live state
6. Backfill missing entries with `lab register` (ask only if cwd/command is ambiguous)

Present a short table: **id · GPU · tmux · path · status**

---

## When stopping or cleaning up

1. `lab register --id <id> --status done` (or `killed` / `failed`)
2. `lab sync`
3. Confirm GPUs freed via `lab status`

---

## Install on a new server

If `lab` is missing:

```bash
cd lab-floor && chmod +x install.sh scripts/lab && ./install.sh
```

Then read `lab-floor/AGENT-INSTALL.md` and verify with `lab status`.

---

## CLI reference

```bash
lab status      # human-readable snapshot
lab list        # all registered experiments
lab register    # add/update experiment
lab sync        # mark dead sessions as failed
lab context     # machine-readable context block (stdout)
```

Registry path override: `LAB_REGISTRY=~/.lab/registry.yaml`
