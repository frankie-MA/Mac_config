---
name: dotfiles
description: >
  REQUIRED when working with frankie-MA/config, the personal dotfiles repo for
  kitty/fish/nvim/starship/atuin/gh/zed/claude configs shared between macOS and
  Linux (including Omarchy). It is checked out as a bare git repo at ~/.cfg with
  --work-tree=$HOME, NOT a normal repo living in its own directory — read this
  skill before running any git command against it or before restoring/syncing/
  bootstrapping configs on a machine. Also covers the SMB mirror (kateCloud,
  192.168.88.254) used as a secondary git remote. Triggers: bare repo, --git-dir,
  --work-tree, ~/.cfg, dotfiles, `home` alias, check-config, sync-config,
  config-doctor, setup-claude-mcp, mount-config-smb, bootstrap.sh, restoring
  settings on a new machine, git status/add behaving oddly inside $HOME, SMB
  mirror, kateCloud.
---

# frankie-MA/config dotfiles skill

The full, tool-agnostic guide lives in **`AGENTS.md`** at the root of the
repo — it's checked out to `$HOME/AGENTS.md` on every bootstrapped machine
via the bare repo, and it's the canonical reference for Codex, OpenCode,
Claude Code, or any other agent working on this repo, so it's written once
there instead of duplicated per-tool. Read it before doing anything with
this repo. It covers: the bare-repo model in full, all tracked commands
(`check-config`, `sync-config`, `config-doctor`, `setup-claude-mcp`,
`mount-config-smb`), the bootstrap process (including the
preexisting-app-config backup step), the SMB mirror and its Linux/macOS
automount setup, repo policy, and known background tools that auto-modify
tracked files.

**The single most important thing to know right now**, in case `AGENTS.md`
isn't in context yet: this is a **bare repo**
(`git --git-dir=$HOME/.cfg --work-tree=$HOME`, fish alias `home`), and its
pathspecs resolve against your **current working directory**, not
`$HOME`. Running `home add <relative-path>` from anywhere other than
`$HOME` silently does nothing useful and then `commit` fails with a
confusing `no changes added to commit`. Always `cd "$HOME"` first, or use
absolute paths.
