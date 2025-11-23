#!/usr/bin/env bash
#
# install.sh for mko
#
# Recommended (auto-reload if possible):
#   source <(curl -sSL https://raw.githubusercontent.com/jspackiaraj/mko/main/install.sh)
#
# Classic:
#   curl -sSL https://raw.githubusercontent.com/jspackiaraj/mko/main/install.sh | bash
#
# Installs or updates mko in $HOME/.local/bin and ensures that directory is on PATH.

set -euo pipefail

# Detect whether this script is being sourced or run in a subshell.
# If sourced, (return 0) will succeed at top level; if executed, it will fail.
if (return 0 2>/dev/null); then
  MKO_SOURCED=1
else
  MKO_SOURCED=0
fi

REPO_RAW_BASE="https://raw.githubusercontent.com/jspackiaraj/mko/main"
INSTALL_DIR="${HOME}/.local/bin"
SCRIPT_NAME="mko"
SCRIPT_PATH="${INSTALL_DIR}/${SCRIPT_NAME}"
SCRIPT_URL="${REPO_RAW_BASE}/${SCRIPT_NAME}"

mkdir -p "${INSTALL_DIR}"

if [ -f "${SCRIPT_PATH}" ]; then
  echo "[mko] Existing ${SCRIPT_NAME} found at ${SCRIPT_PATH}."
  echo "[mko] Updating to the latest version..."
else
  echo "[mko] Installing ${SCRIPT_NAME} to: ${INSTALL_DIR}"
fi

# Download the main script
if command -v curl >/dev/null 2>&1; then
  curl -sSL "${SCRIPT_URL}" -o "${SCRIPT_PATH}"
elif command -v wget >/dev/null 2>&1; then
  wget -qO "${SCRIPT_PATH}" "${SCRIPT_URL}"
else
  echo "[mko] Error: neither curl nor wget is available. Install one of them and try again." >&2
  return 1 2>/dev/null || exit 1
fi

chmod +x "${SCRIPT_PATH}"

# Ensure INSTALL_DIR is in PATH
ensure_path_line='export PATH="$HOME/.local/bin:$PATH"'
in_path=0
case ":$PATH:" in
  *":${INSTALL_DIR}:"*) in_path=1 ;;
esac

target_rc=""

if [ "${in_path}" -eq 1 ]; then
  echo "[mko] ${INSTALL_DIR} is already in PATH."
else
  # Try to guess which shell config file to update
  shell_name="$(basename "${SHELL:-}")"
  case "${shell_name}" in
    bash) target_rc="${HOME}/.bashrc" ;;
    zsh)  target_rc="${HOME}/.zshrc" ;;
    *)
      if   [ -f "${HOME}/.bashrc" ]; then
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

  if [ "${MKO_SOURCED}" -eq 1 ]; then
    # We are running in the current shell context; we can reload immediately.
    echo "[mko] Reloading shell configuration from ${target_rc}..."
    # shellcheck disable=SC1090
    . "${target_rc}"
    echo "[mko] Shell configuration reloaded in this session."
  else
    echo "[mko] To activate mko in this shell, run:"
    echo " source ${target_rc}"
    echo " or open a new terminal."
  fi
fi

# Post-install verification
if command -v mko >/dev/null 2>&1; then
  echo "[mko] Installation/update complete. Try:"
  echo " mko --help"
else
  echo "[mko] Installation/update complete, but 'mko' is not yet on PATH in this shell."
  if [ "${in_path}" -eq 1 ]; then
    echo "[mko] Your PATH already includes ${INSTALL_DIR}."
    echo "[mko] Start a new shell, or ensure your login/session actually uses that PATH."
  else
    if [ -n "${target_rc}" ]; then
      echo "[mko] Open a new terminal, or run:"
      echo " source ${target_rc}"
    else
      echo "[mko] Ensure that ${INSTALL_DIR} is on your PATH in your shell configuration."
    fi
  fi
fi

# If we are sourced, avoid killing the caller shell with exit.
return 0 2>/dev/null || exit 0
