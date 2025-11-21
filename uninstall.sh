#!/usr/bin/env bash
#
# uninstall.sh for mko
# Usage (recommended, safe even when sourced):
#   source <(curl -sSL https://raw.githubusercontent.com/jspackiaraj/mko/main/uninstall.sh)
#
# Or classic:
#   curl -sSL https://raw.githubusercontent.com/jspackiaraj/mko/main/uninstall.sh | bash
#
# Removes the mko script from $HOME/.local/bin and its config directory.
# It does NOT edit your shell config files; any PATH changes stay as-is.

set -euo pipefail

# Detect whether this script is being sourced or run in a subshell.
if (return 0 2>/dev/null); then
  MKO_UN_SOURCED=1
else
  MKO_UN_SOURCED=0
fi

INSTALL_DIR="${HOME}/.local/bin"
SCRIPT_NAME="mko"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/mko"
LOG_FILE="${HOME}/.mko.log"

echo "[mko] Uninstalling mko..."

if [ -f "${INSTALL_DIR}/${SCRIPT_NAME}" ]; then
  rm -f "${INSTALL_DIR}/${SCRIPT_NAME}"
  echo "[mko] Removed ${INSTALL_DIR}/${SCRIPT_NAME}"
else
  echo "[mko] No mko binary found in ${INSTALL_DIR}."
fi

if [ -d "${CONFIG_DIR}" ]; then
  rm -rf "${CONFIG_DIR}"
  echo "[mko] Removed config directory ${CONFIG_DIR}"
else
  echo "[mko] No config directory at ${CONFIG_DIR}."
fi

if [ -f "${LOG_FILE}" ]; then
  rm -f "${LOG_FILE}"
  echo "[mko] Removed log file ${LOG_FILE}"
fi

cat <<EOF
[mko] Uninstall complete.

NOTE:
  - Any PATH changes added to ~/.bashrc, ~/.zshrc or ~/.profile
    by the installer are left in place.
  - If you want to clean them up, open the relevant file and
    remove the lines marked "Added by mko installer".
EOF

# If sourced, do not kill the calling shell.
return 0 2>/dev/null || exit 0
