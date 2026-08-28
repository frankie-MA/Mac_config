# Working with this repo (frankie-MA/config)

This is a personal dotfiles repo for kitty/fish/nvim/starship/atuin/gh/zed/
claude configs, shared between macOS and Linux (including Omarchy). Read
this file before running git commands against it, before editing tracked
config files, and before bootstrapping or syncing a machine. It applies
equally whether you're operating in `$HOME` on a machine that has this repo
deployed, or in a plain clone of the repo itself.

## This is a bare repo, not a normal checkout

There is no working directory that "is" the repo on a live machine.
Instead:

- `~/.cfg` is a bare git repository (`--git-dir`)
- `$HOME` itself is its work-tree (`--work-tree`)
- the fish alias `home` wraps `git --git-dir=$HOME/.cfg --work-tree=$HOME`,
  so `home status`, `home add`, `home commit`, `home log`, etc. operate on
  files scattered across `$HOME` as if it were a normal checkout
- `git --git-dir=$HOME/.cfg config status.showUntrackedFiles no` is set on
  purpose, so `home status` never lists the huge number of unrelated files
  in `$HOME` — only files this repo actually tracks show up as
  modified/staged. A file has to be explicitly `git add`ed to start being
  tracked; it will not show up as a suggestion first.

A second, ordinary (non-bare) clone of the same GitHub origin usually also
exists for editing repo-source files comfortably (e.g.
`~/ghq/github.com/frankie-MA/config`). Both point at the same repo. Edit
shared files (scripts, docs, this file) in whichever clone you have open,
commit + push from there, then bring the bare repo up to date on any given
machine with `sync-config` (or `home fetch && home merge --ff-only
origin/main` by hand).

## Critical gotcha: pathspecs resolve against $PWD, not $HOME

```sh
git --git-dir=$HOME/.cfg --work-tree=$HOME add .config/nvim/lua/plugins/foo.lua
```

resolves the path relative to the **current working directory**, not to
`$HOME`, even though `--work-tree` is `$HOME`. If your shell's cwd is
somewhere else (e.g. the other clone's directory), this silently does
nothing useful, and a follow-up `commit` then fails with a confusing
`no changes added to commit` — no hint that the real cause was cwd.

**Always `cd "$HOME"` first** before running any bare-repo git command with
a relative pathspec, or use absolute paths. This has actually bitten a
previous session doing this exact kind of maintenance — don't repeat it.

## Commands (tracked in `.local/bin/`, expected on `$PATH`)

- **`check-config`** — fast syntax/runtime sanity checks: POSIX shell
  scripts under `.local/bin/*` and `install/*.sh` (`sh -n`, only for
  `#!/bin/sh`-shebang files — `.local/bin` also holds non-shell binaries),
  fish syntax, headless nvim startup, starship config.
- **`sync-config`** — `home fetch origin main && home merge --ff-only
  origin/main && home push origin main`, then push to the SMB mirror if
  mounted, then `config-doctor`. **Refuses to run** if the work-tree has
  any staged or unstaged changes — commit or discard first (`home status
  --short` to see what's dirty; see "background auto-injected files"
  below before assuming a diff needs committing).
- **`config-doctor`** — full health check: fish syntax, nvim headless
  startup, starship config, required kitty files present, work-tree clean,
  local `HEAD` matches `origin/main`, SMB mirror in sync (or
  `skip: SMB mirror not mounted or not configured`), and the expected
  Claude Code MCP servers exist in `~/.claude.json`.
- **`setup-claude-mcp`** — idempotent; merges `filesystem`, `github`,
  `memory`, `sequential-thinking`, `tree-sitter` (plus `homebrew` only on
  macOS when `brew` exists) into `~/.claude.json`'s `mcpServers`, using
  Claude Code's own `${HOME}` / `${GITHUB_TOKEN}` expansion syntax rather
  than a hardcoded path — needs `jq`. **`~/.claude.json` itself is NOT
  tracked** (it holds OAuth/session/cache state), so this script is the
  only mechanism that puts these servers there; it runs automatically at
  the end of `bootstrap.sh` and is safe to re-run anytime.
- **`mount-config-smb`** — checks/triggers the SMB mirror mount: on macOS,
  mounts via Finder/`osascript` if not already mounted; on Linux, just
  touches the mount point (enough to trigger the systemd automount below)
  and reports whether it's mounted; no-op elsewhere.

## Bootstrapping a new machine

```sh
git clone git@github.com:frankie-MA/config.git ~/config-bootstrap
cd ~/config-bootstrap
./install/bootstrap.sh --packages
```

`install/bootstrap.sh --packages`:

1. Installs base packages for the detected OS (`brew` on Darwin, `pacman`
   on Arch/Omarchy Linux — see the script for the exact list; currently
   includes `jq` for `setup-claude-mcp` and `cifs-utils` for the SMB
   mirror).
2. Bare-clones the repo to `~/.cfg`.
3. **On a fresh clone only**, moves any *whole* pre-existing app-config
   directory this repo owns (any child of `.config/` or `.local/` present
   in the repo's tree — e.g. `nvim`, `kitty`, `fish`) that already exists
   on disk into `~/.config-backup/<timestamp>-preexisting/` **before**
   checkout. This exists because a fresh OS (Omarchy is the known case)
   can preinstall a full app scaffold — e.g. a stock LazyVim
   `~/.config/nvim` — whose file paths mostly don't collide with anything
   this repo tracks, so plain `git checkout`'s own per-file conflict
   detection misses it and silently leaves the two configs mixed together
   (this happened for real: Omarchy's `LazyVim/LazyVim` plugin spec ended
   up loaded alongside this repo's own plain-`lazy.nvim` config and broke
   on an unrelated LazyVim startup check). If you're setting up a new
   OS/distro for the first time, expect this backup step to fire and
   don't be alarmed by it.
4. Runs `git checkout` normally; any *remaining* exact-path conflicts (a
   single tracked file that already exists, not caught by step 3) get
   backed up reactively to `~/.config-backup/<timestamp>/` the same way.
5. Sets fish as the login shell (`chsh`).
6. Runs `setup-claude-mcp` if `jq` is available, then `config-doctor`.

The manual (no-`--packages`) bare-clone steps are in `docs/bootstrap.md`.
The SMB automount setup (below) is a separate, deliberately-manual step —
it needs sudo and a real password, so it is not run by `bootstrap.sh`.

## SMB mirror (kateCloud)

- Real host: SMB share, LAN IP `192.168.88.254`, mDNS name `kateCloud`
  (`smb://frankie@kateCloud._smb._tcp.local/homes`). The mDNS `.local` name
  needs Bonjour/Avahi to resolve — on a Linux box without Avahi (a fresh
  Omarchy install may not have it), the scripts below use the raw IP
  instead.
- Detection in `sync-config` / `config-doctor` / `bootstrap.sh` is
  mount-based: `detect_smb_remote()` touches the candidate mount point
  (`[ -d "$mount_point" ]` — a bare stat, which is enough to trigger a
  Linux systemd `.automount` unit if one is set up) and then checks
  `mount | grep " on $mount_point "` for `/Volumes/homes` (macOS default)
  or `/mnt/katecloud/homes` (Linux default) — override with
  `SMB_CONFIG_MOUNT_POINT`. It doesn't care what mounted it (LaunchAgent,
  systemd, fstab, a manual mount) — if something real is there, sync/doctor
  use it.
- The git remote living on the share is expected at
  `<mount_point>/repo/git/config.git` (override with `SMB_CONFIG_REMOTE`
  for a nonstandard layout).
- **macOS**: `mount-config-smb` + LaunchAgent `com.mafrankie.config-smb`
  mount at login via Keychain-stored credentials (see README for the
  one-time `launchctl bootstrap`/`kickstart` setup).
- **Linux**: run `install/setup-smb-automount-linux.sh` once (interactive,
  needs sudo + the real SMB password). It installs a systemd `.mount` +
  `.automount` unit pair at `/mnt/katecloud/homes` and a credentials file
  at `/etc/samba/credentials-katecloud` (root-only, 600, never tracked in
  git — the Linux equivalent of Keychain). The share mounts lazily on
  first access and unmounts after 10 minutes idle — no login script, no
  polling, same philosophy as the macOS LaunchAgent. Override host/share/
  mount point/credentials path via `SMB_CONFIG_HOST` / `SMB_CONFIG_SHARE` /
  `SMB_CONFIG_MOUNT_POINT` / `SMB_CONFIG_CREDS`. The script reads
  `${SUDO_UID:-$(id -u)}` / `${SUDO_GID:-$(id -g)}` so it mounts with the
  real (non-root) user's ownership whether it's run directly (it calls
  `sudo` itself per privileged step) or as `sudo ./setup-...sh` (the whole
  thing as root) — get this wrong and the mount ends up `uid=0,gid=0`,
  unwritable by the normal user and rejected by git as "dubious
  ownership" (hit this for real once; fixed by editing the installed
  `.mount` unit's `Options=` line, `daemon-reload`, `umount`, restart the
  `.automount` unit). If a `~/.config/gtk-3.0/bookmarks` file already
  exists (Nautilus/Nemo/Thunar), the script also adds a bookmark there so
  the mirror shows up in the file manager's sidebar.
- Missing/unmounted SMB is not an error: it's an optional secondary push
  target, everything still works against `origin` alone
  (`skip: SMB mirror not mounted or not configured`).

## Policy (`docs/policy.md`)

- Shared behavior belongs in tracked files.
- OS-specific behavior belongs in `linux.conf` / `macos.conf` or a small
  `uname` block — mirror this instead of hardcoding one OS's paths (this
  is exactly what was wrong with the old `.config/claude/settings.json`,
  which hardcoded `/Users/...` and Homebrew paths and was never even read
  by Claude Code — it reads `~/.claude.json` instead; see git history and
  `setup-claude-mcp` above for the fix).
- Machine-local behavior belongs in **ignored** local overrides:
  `~/.config/fish/conf.d/99-local.fish`, `~/.config/kitty/local.conf`,
  `~/.config/nvim/lua/local.lua`.
- `~/.config/nvim/lazy-lock.json` is intentionally untracked.
- Secrets, tokens, private hostnames, machine-only paths: never tracked.
- Finish config edits with `check-config`, then `sync-config`.

## Watch for background auto-injected diffs

Some tools rewrite tracked files on their own after checkout/first run —
seen so far: a `uv`/`mise`-style installer appending a PATH-sourcing line
to `.profile`/`.zshrc`, `opencode` adding a `"$schema"` key to its own
config, an MCP plugin registering itself into `~/.config/zed/settings.json`.
Before treating a `home status` diff as something to commit, check whether
it's actually an intentional edit or one of these auto-injected artifacts;
if it's noise, `home checkout -- <path>` to drop it rather than committing
it.
