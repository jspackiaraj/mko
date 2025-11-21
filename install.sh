#!/usr/bin/env bash
#
# install.sh for mko
# Usage:
#   curl -sSL https://raw.githubusercontent.com/jspackiaraj/mko/main/install.sh | bash
#
# Installs mko into $HOME/.local/bin and adds that directory to PATH
# in the user's shell config if needed.

set -euo pipefail

REPO_RAW_BASE="https://raw.githubusercontent.com/jspackiaraj/mko/main"
INSTALL_DIR="${HOME}/.local/bin"
SCRIPT_NAME="mko"
SCRIPT_URL="${REPO_RAW_BASE}/${SCRIPT_NAME}"

echo "[mko] Installing mko to: ${INSTALL_DIR}"

mkdir -p "${INSTALL_DIR}"

# Download the main script
if command -v curl >/dev/null 2>&1; then
  curl -sSL "${SCRIPT_URL}" -o "${INSTALL_DIR}/${SCRIPT_NAME}"
elif command -v wget >/dev/null 2>&1; then
  wget -qO "${INSTALL_DIR}/${SCRIPT_NAME}" "${SCRIPT_URL}"
else
  echo "[mko] Error: neither curl nor wget is available. Install one of them and try again." >&2
  exit 1
fi

chmod +x "${INSTALL_DIR}/${SCRIPT_NAME}"

# Ensure INSTALL_DIR is in PATH
# We only append to one file; user can adjust later if needed.
ensure_path_line='export PATH="$HOME/.local/bin:$PATH"'

in_path=0
case ":$PATH:" in
  *":${INSTALL_DIR}:"*) in_path=1 ;;
esac

if [ "${in_path}" -eq 1 ]; then
  echo "[mko] ${INSTALL_DIR} is already in PATH."
else
  # Try to guess which shell config file to update
  shell_name="$(basename "${SHELL:-}")"
  target_rc=""

  case "${shell_name}" in
    bash)
      target_rc="${HOME}/.bashrc"
      ;;
    zsh)
      target_rc="${HOME}/.zshrc"
      ;;
    *)
      # Fallback
      if [ -f "${HOME}/.bashrc" ]; then
        target_rc="${HOME}/.bashrc"
      elif [ -f "${HOME}/.zshrc" ]; then
        target_rc="${HOME}/.zshrc"
      else
        target_rc="${HOME}/.profile"
      fi
      ;;
  esac

  echo "[mko] Adding ${INSTALL_DIR} to PATH in ${target_rc}"

  {
    echo ""
    echo "# Added by mko installer"
    echo "${ensure_path_line}"
  } >> "${target_rc}"

  echo "[mko] PATH update appended to ${target_rc}."
  echo "[mko] Reload your shell configuration, e.g.:"
  echo "       source ${target_rc}"
fi

echo "[mko] Installation complete. Try:"
echo "       mko --help"
