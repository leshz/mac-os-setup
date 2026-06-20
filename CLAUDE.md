# mac-os-setup — Project Instructions

## Purpose

Modular shell scripts to set up a Mac from scratch. Each script is self-contained and can run independently or via `setup.sh`.

## Structure

```
setup.sh              # Orchestrator — sequential or interactive menu mode
scripts/
  01-homebrew.sh      # Homebrew + CLI tools
  02-zsh.sh           # Zsh + Oh My Zsh + Starship + plugins
  03-languages.sh     # Node.js (FNM), Python (pyenv)
  04-apps.sh          # GUI apps + Nerd Fonts
  05-macos.sh         # macOS system preferences (screenshots only)
  06-dotfiles.sh      # Dotfiles + optional SSH setup
  99-cleanup.sh       # Uninstall/cleanup
dotfiles/             # Config files copied during 06-dotfiles.sh
```

## Key Decisions

### macOS configuration scope (`05-macos.sh`)
Only configures screenshot organization:
- Location: `~/Desktop/Screenshots`
- Format: PNG
- Shadow: disabled

All other system preferences (keyboard, trackpad, dock, finder) were intentionally removed — the user manages those manually.

### SSH setup is optional (`06-dotfiles.sh`)
During the dotfiles step, the script interactively prompts:
```
¿Deseas configurar SSH para GitHub? (y/n):
```
If the user answers `n`, the SSH section is skipped silently. If `y`, it creates `~/.ssh/config` with a template and prints key generation instructions.

## Rules

- Never rebuild after changes — the scripts run directly as shell.
- Do not add macOS system preferences back to `05-macos.sh` without explicit user request.
- Keep each script self-contained (no cross-sourcing between scripts).
- The `confirm()` helper lives only in `setup.sh`; individual scripts use inline `read` prompts.
- Dry-run mode is controlled by `setup.sh` — individual scripts do not need to handle it.
