# Lab Floor — Quick Rules

Paste into project README, global agent config, or system prompt.

---

Before any GPU, tmux, training, or experiment-folder work:

1. Run `lab status`
2. Read `~/.lab/registry.yaml`
3. Register new jobs with `lab register` immediately after launch
4. Run `lab sync` when sessions may have died

Full playbook: `~/.lab/INSTRUCTIONS.md`

If `lab` is not found: `cd lab-floor && ./install.sh`

**If it's not in the registry, it doesn't exist.**
