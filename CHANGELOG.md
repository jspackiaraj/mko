# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and the versioning scheme follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Nothing yet.

---

## [0.1.0] – 2025-11-23

### Added
- `d` option in the existing-file prompt:
  - When the last file exists and is non-empty, answering `d` (lowercase only) empties the file before opening it.
- `--empty` flag as a non-interactive equivalent of choosing `d`:
  - If the last file exists and is non-empty, it is truncated to zero bytes and then opened, without asking.
- `-y` / `--yes` as aliases for `--force`, so that existing usages such as:
  - `mko -y /path/to/file1 /path/to/file2`
  continue to work and open the last file without prompting.

### Changed
- Existing-file prompt updated from a simple yes/no style to:
  - `Open in EDITOR? [y/N/d]`
  explicitly separating “open as-is” (`y`) from the destructive “empty and open” (`d`) path.
- `install.sh`:
  - Now detects an existing `~/.local/bin/mko` and treats reruns as updates rather than fresh installs.
  - Avoids duplicating `PATH` entries and prints clearer messages when updating an existing installation.

---

## [0.0.0] – 2025-11-21

### Added
- Initial public release of `mko`.
- Core command behaviour:
  - Create missing parent directories using `mkdir -p`.
  - Create files if they do not exist using `touch`.
  - Accept multiple file paths but open only the last one in the editor.
- Support for `nano` and `nvim` as editors:
  - Per-run editor override via `-e, --editor EDITOR`.
  - Persistent default editor via `--set-editor EDITOR`, stored in `~/.config/mko/config`.
- `--dry-run` mode to show what would be done without creating or opening anything.
- `--silent` mode to suppress normal informational output (errors still shown).
- Basic logging of actions (directories created, files created, files opened) to `~/.mko.log`.
- Colourised terminal output when running in a TTY and not in silent mode.
- Optional auto-install of the chosen editor (`nano` or `nvim`) on:
  - Ubuntu / Debian via `apt`.
  - Arch-based systems via `pacman`.
  with clear messages when `sudo` is unavailable or installation fails.
- `--force` flag to open an existing non-empty last file without prompting.
- `install.sh` to install `mko` into `~/.local/bin` and add it to `PATH` where needed.
- `uninstall.sh` to remove:
  - `~/.local/bin/mko`
  - `~/.config/mko`
  - `~/.mko.log`

[Unreleased]: https://github.com/jspackiaraj/mko/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/jspackiaraj/mko/compare/v0.0.0...v0.1.0
[0.0.0]: https://github.com/jspackiaraj/mko/releases/tag/v0.0.0
