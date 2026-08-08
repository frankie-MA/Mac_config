# Dotfiles Policy

- Shared behavior belongs in tracked files.
- OS-specific behavior belongs in `linux.conf`, `macos.conf`, or a small `uname` block.
- Machine-local behavior belongs in ignored local overrides:
  - `~/.config/fish/conf.d/99-local.fish`
  - `~/.config/kitty/local.conf`
  - `~/.config/nvim/lua/local.lua`
- `~/.config/nvim/lazy-lock.json` is not tracked. Each OS can resolve plugin versions locally.
- Secrets, tokens, private hostnames, and machine-only paths are not tracked.
- Finish config changes with `check-config`, then `sync-config`.
