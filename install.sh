#!/usr/bin/env bash
# Lab Floor installer — run on the remote server from lab-floor/
set -euo pipefail

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="${HOME}"
LAB_DIR="${HOME_DIR}/.lab"
LOCAL_BIN="${HOME_DIR}/.local/bin"

echo "==> Lab Floor install"
echo "    kit:    ${KIT_DIR}"
echo "    target: ${HOME_DIR}"

# PyYAML strongly recommended for registry round-trips
if ! python3 -c "import yaml" 2>/dev/null; then
  echo "    pyyaml -> installing (pip --user)..."
  pip3 install --user pyyaml >/dev/null 2>&1 || echo "    WARN: PyYAML missing — install with: pip3 install --user pyyaml"
fi

mkdir -p "${LAB_DIR}"
mkdir -p "${LOCAL_BIN}"

# CLI
cp "${KIT_DIR}/scripts/lab" "${LAB_DIR}/lab"
chmod +x "${LAB_DIR}/lab"
ln -sf "${LAB_DIR}/lab" "${LOCAL_BIN}/lab"
echo "    cli    -> ${LOCAL_BIN}/lab"

# Agent instructions (for any coding agent / assistant)
cp "${KIT_DIR}/agent/INSTRUCTIONS.md" "${LAB_DIR}/INSTRUCTIONS.md"
cp "${KIT_DIR}/agent/QUICK-RULES.md" "${LAB_DIR}/QUICK-RULES.md"
echo "    agent  -> ${LAB_DIR}/INSTRUCTIONS.md"

# Registry (do not overwrite existing)
if [[ ! -f "${LAB_DIR}/registry.yaml" ]]; then
  HOST="$(hostname -s 2>/dev/null || hostname)"
  sed "s/CHANGE_ME_HOSTNAME/${HOST}/" "${KIT_DIR}/registry.yaml.template" > "${LAB_DIR}/registry.yaml"
  echo "    registry -> ${LAB_DIR}/registry.yaml (created)"
else
  echo "    registry -> ${LAB_DIR}/registry.yaml (kept existing)"
fi

echo ""
echo "Lab Floor install complete."
echo ""
echo "Next steps:"
echo "  1. Ensure ~/.local/bin is on PATH (add to ~/.bashrc if needed)"
echo "  2. Run: lab status"
echo "  3. Point your coding agent at ~/.lab/INSTRUCTIONS.md (see integrations/README.md for optional wiring)"
echo ""
echo "For AI agents: read ${KIT_DIR}/AGENT-INSTALL.md"
