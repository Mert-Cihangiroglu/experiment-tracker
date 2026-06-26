#!/usr/bin/env bash
# Print lab context to stdout — wire into any tool that supports session-start scripts.
set -euo pipefail

LAB_BIN="${HOME}/.lab/lab"
if [[ ! -x "${LAB_BIN}" ]]; then
  LAB_BIN="$(command -v lab 2>/dev/null || true)"
fi

if [[ -z "${LAB_BIN}" || ! -x "${LAB_BIN}" ]]; then
  echo "[lab-floor] Not installed. Run: cd lab-floor && ./install.sh"
  exit 0
fi

exec "${LAB_BIN}" context
