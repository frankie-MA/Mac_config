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

This repo (`git@github.com:frankie-MA/config.git`) is a personal dotfiles
project. It is deployed with the **bare-repo pattern**: there is no working
directory that "is" the repo on a live machine. Instead:

- `~/.cfg` is a bare git repository (`--git-dir`)
- `$HOME` itself is its work-tree (`--work-tree`)
- the fish alias `home` (defined by the repo's own fish config) wraps
  `git --git-dir=$HOME/.cfg --work-tree=$HOME`, so `home status`, `home add`,
  `home commit`, `home log` etc. all operate on files scattered across `$HOME`
  as if `$HOME` were a normal checkout.
- `git --git-dir=$HOME/.cfg config status.showUntrackedFiles no` is set on
  purpose, so `home status` never lists the thousands of unrelated files in
  `$HOME` — only files this repo actually tracks show up as modified/staged.

A second, ordinary (non-bare) clone of the same origin usually also exists
somewhere for editing repo-source files comfortably (e.g.
`~/ghq/github.com/frankie-MA/config`). Both point at the same GitHub repo.
Edit shared files (scripts, docs, this skill) in whichever clone is open;
commit+push from there, then bring the bare repo up to date with
`sync-config` (or `home pull` / `home fetch && home merge --ff-only
origin/main` by hand).

## Critical gotcha: pathspecs are relative to $PWD, not $HOME

`git --work-tree=$HOME --git-dir=$HOME/.cfg add <path>` resolves `<path>`
relative to the **current working directory**, not to `$HOME`, even though
`--work-tree` is `$HOME`. If your shell's cwd is somewhere else (e.g. the
other clone's directory), a command like:

```sh
git --git-dir=$HOME/.cfg --work-tree=$HOME add .config/nvim/lua/plugins/foo.lua
```

silently does nothing useful (git resolves the path against cwd, not
`$HOME`), and the follow-up `commit` then fails with a confusing
`no changes added to commit` — with no hint that the real cause was cwd.

**Always `cd "$HOME"` first** (or use `cd "$HOME" && home <command>`, or
give absolute paths) before running any bare-repo git command whose
pathspec isn't already absolute. This bit a previous session doing exactly
this kind of dotfiles maintenance — don't repeat it.

## Commands (tracked in `.local/bin/`, expected on `$PATH`)

- **`check-config`** — fast syntax/runtime sanity checks: POSIX shell
  scripts under `.local/bin/*` and `install/*.sh` (`sh -n`, only for
  `#!/bin/sh`-shebang files — `.local/bin` also holds non-shell binaries),
  fish syntax, headless nvim startup, starship config.
- **`sync-config`** — `home fetch origin main && home merge --ff-only
  origin/main && home push origin main`, then push to the SMB mirror if
  mounted, then `config-doctor`. **Refuses to run** if the work-tree has any
  staged or unstaged changes — commit or discard first (`home status
  --short` to see what's dirty; see "background auto-injected files" below
  before assuming a diff needs committing).
- **`config-doctor`** — full health check: fish syntax, nvim headless
  startup, starship config, required kitty files present, work-tree clean,
  local `HEAD` matches `origin/main`, SMB mirror in sync (or
  `skip: SMB mirror not mounted or not configured`), and the expected Claude
  Code MCP servers exist in `~/.claude.json`.
- **`setup-claude-mcp`** — idempotent; merges `filesystem`, `github`,
  `memory`, `sequential-thinking`, `tree-sitter` (plus `homebrew` only on
  macOS when `brew` exists) into `~/.claude.json`'s `mcpServers`, using
  Claude Code's own `${HOME}` / `${GITHUB_TOKEN}` expansion syntax rather
  than a hardcoded path — needs `jq`. **`~/.claude.json` itself is NOT
  tracked by this repo** (it holds OAuth/session/cache state), so this
  script is the only mechanism that puts these servers there; it runs
  automatically at the end of `bootstrap.sh` and is safe to re-run anytime.
- **`mount-config-smb`** — **macOS only** (no-ops immediately on any other
  `uname`); auto-mounts the SMB mirror via a LaunchAgent at login, using a
  Keychain-stored password (see SMB section below).

## Bootstrapping a new machine

```sh
git clone git@github.com:frankie-MA/config.git ~/config-bootstrap
cd ~/config-bootstrap
./install/bootstrap.sh --packages
```

`install/bootstrap.sh --packages`:

1. Installs base packages for the detected OS (`brew` on Darwin, `pacman`
   on Arch/Omarchy Linux — see the script for the exact list, currently
   includes `jq` for `setup-claude-mcp`).
2. Bare-clones the repo to `~/.cfg`.
3. **On a fresh clone only**, moves any *whole* pre-existing app-config
   directory this repo owns (any child of `.config/` or `.local/` present
   in the repo's tree — e.g. `nvim`, `kitty`, `fish`) that already exists on
   disk into `~/.config-backup/<timestamp>-preexisting/` **before**
   checkout. This exists because a fresh OS (Omarchy is the known case) can
   preinstall a full app scaffold — e.g. a stock LazyVim `~/.config/nvim` —
   whose file paths mostly don't collide with anything this repo tracks, so
   plain `git checkout`'s own per-file conflict detection misses it and
   silently leaves the two configs mixed together (this happened for real:
   Omarchy's `LazyVim/LazyVim` plugin spec ended up loaded alongside this
   repo's own plain-`lazy.nvim` config and broke on an unrelated LazyVim
   startup check). If you're setting up a new OS/distro for the first time,
   expect this backup step to fire and don't be alarmed by it.
4. Runs `git checkout` normally; any *remaining* exact-path conflicts (a
   single tracked file that already exists, not caught by step 3) get
   backed up reactively to `~/.config-backup/<timestamp>/` the same way.
5. Sets fish as the login shell (`chsh`).
6. Runs `setup-claude-mcp` if `jq` is available, then `config-doctor`.

The manual (no-`--packages`) bare-clone steps are in `docs/bootstrap.md`.

## SMB mirror (kateCloud)

- Real host: SMB share, LAN IP `192.168.88.254`, mDNS name `kateCloud`
  (`smb://frankie@kateCloud._smb._tcp.local/homes`). The mDNS `.local` name
  needs Bonjour/Avahi to resolve — on a Linux box without Avahi running
  (a fresh Omarchy install may not have it), mount by IP instead, e.g.
  `//192.168.88.254/homes`.
- Detection in `sync-config` / `config-doctor` / `bootstrap.sh` is purely
  **mount-based**, not protocol-based: `detect_smb_remote()` just checks
  `mount | grep " on $mount_point "` for `/Volumes/homes` (macOS default) or
  `/mnt/katecloud/homes` (Linux default) — override with
  `SMB_CONFIG_MOUNT_POINT`. However that mount got there (LaunchAgent,
  `/etc/fstab`, autofs, a manual `mount -t cifs`), if something is mounted
  at that path, sync/doctor treat it as present.
- The git remote living on the share is expected at
  `<mount_point>/repo/git/config.git` (override with `SMB_CONFIG_REMOTE`
  for a nonstandard layout).
- **Auto-mounting only exists for macOS today** (`mount-config-smb` +
  LaunchAgent `com.mafrankie.config-smb`, password from Keychain — see
  README for the one-time `launchctl bootstrap`/`kickstart` setup). There is
  **no Linux equivalent yet** — on Omarchy/Arch the mirror will show as
  `skip: SMB mirror not mounted or not configured` unless mounted manually,
  e.g.:
  ```sh
  sudo mkdir -p /mnt/katecloud/homes
  sudo mount -t cifs //192.168.88.254/homes /mnt/katecloud/homes \
      -o username=frankie,uid=$(id -u),gid=$(id -g)
  ```
  (adjust share name/credentials/options; add a matching `/etc/fstab` line,
  or a systemd `.mount`/`automount` unit, for it to persist across
  reboots). If asked to make this "just work" on Linux like it does on
  macOS, that is new work — say so rather than assuming a Linux automount
  already exists.
- Missing/unmounted SMB is not an error: it's an optional secondary
  push target, everything still works against `origin` alone.

## Policy (`docs/policy.md`)

- Shared behavior belongs in tracked files.
- OS-specific behavior belongs in `linux.conf` / `macos.conf` or a small
  `uname` block — mirror this instead of hardcoding one OS's paths (this is
  exactly what was wrong with the old `.config/claude/settings.json`, which
  hardcoded `/Users/...` and Homebrew and was never even read by Claude
  Code — it read `~/.claude.json` instead; see git history for the fix and
  `setup-claude-mcp` above for the replacement).
- Machine-local behavior belongs in **ignored** local overrides:
  `~/.config/fish/conf.d/99-local.fish`, `~/.config/kitty/local.conf`,
  `~/.config/nvim/lua/local.lua`.
- `~/.config/nvim/lazy-lock.json` is intentionally untracked.
- Secrets, tokens, private hostnames, machine-only paths: never tracked.
- Finish config edits with `check-config`, then `sync-config`.

## Watch for background auto-injected diffs

Some tools rewrite tracked files on their own after checkout/first run —
seen so far: a `uv`/`mise`-style installer appending a PATH-sourcing line to
`.profile`/`.zshrc`, `opencode` adding a `"$schema"` key to its own config,
an MCP plugin registering itself into `~/.config/zed/settings.json`. Before
treating a `home status` diff as something to commit, check whether it's
actually an intentional edit or one of these auto-injected artifacts; if
it's noise, `home checkout -- <path>` to drop it rather than committing it.
