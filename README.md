# Lab Floor

Portable install kit for tracking GPU experiments, tmux sessions, configs, and working directories on a remote server.

**Problem:** Many folders, jobs, GPUs, and terminal sessions with no shared memory.

**Solution:** One registry file (`~/.lab/registry.yaml`) + a `lab` CLI + agent instructions any assistant can follow.

## Quick start

```bash
cd lab-floor
chmod +x install.sh scripts/lab
./install.sh
lab status
```

## Contents

| Path | Purpose |
|------|---------|
| [`AGENT-INSTALL.md`](AGENT-INSTALL.md) | Step-by-step instructions for an AI agent on a remote server |
| [`install.sh`](install.sh) | Installs CLI, registry, agent instructions under `~/.lab/` |
| [`registry.yaml.template`](registry.yaml.template) | Empty registry scaffold |
| [`agent/INSTRUCTIONS.md`](agent/INSTRUCTIONS.md) | Full playbook for any coding agent |
| [`agent/QUICK-RULES.md`](agent/QUICK-RULES.md) | Short rules to paste into project or global agent config |
| [`scripts/lab`](scripts/lab) | CLI: `status`, `register`, `sync`, `list`, `context` |
| [`integrations/`](integrations/) | Optional wiring for tools that support session startup scripts |

## Daily use

```bash
lab status                    # what's running right now
lab list                      # all experiments in registry
lab register --id my-run ...  # record a new job
lab sync                      # reconcile registry vs tmux/GPUs
lab context                   # context block for agents (stdout)
```

**Rule:** if it's not in `~/.lab/registry.yaml`, it doesn't exist.

## Copy to server

```bash
scp -r lab-floor user@gpu-server:~/lab-floor
ssh user@gpu-server 'cd ~/lab-floor && ./install.sh'
```

## Paste this to any coding agent on the server

```
Read lab-floor/AGENT-INSTALL.md and install Lab Floor on this machine.
Follow every step, verify with lab status, and backfill any running tmux/GPU jobs into the registry.
Then read ~/.lab/INSTRUCTIONS.md and follow it for all experiment work.
```

## After install

```
~/.lab/registry.yaml       # source of truth
~/.lab/INSTRUCTIONS.md     # agent playbook
~/.lab/QUICK-RULES.md      # short rules
~/.local/bin/lab             # CLI
```
