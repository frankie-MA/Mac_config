#!/bin/sh

set -eu

repo_url="${CONFIG_REPO_URL:-git@github.com:frankie-MA/config.git}"
home_git="${HOME_GIT_DIR:-$HOME/.cfg}"
install_packages=0

detect_smb_remote() {
    if [ -n "${SMB_CONFIG_REMOTE:-}" ]; then
        printf '%s\n' "$SMB_CONFIG_REMOTE"
        return
    fi

    for mount_point in ${SMB_CONFIG_MOUNT_POINT:+"$SMB_CONFIG_MOUNT_POINT"} /Volumes/homes /mnt/katecloud/homes; do
        if mount | grep -Fq " on $mount_point "; then
            printf '%s/repo/git/config.git\n' "$mount_point"
            return
        fi
    done
}

smb_remote="$(detect_smb_remote)"

usage() {
    printf 'usage: %s [--packages]\n' "$0"
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --packages) install_packages=1 ;;
        -h|--help) usage; exit 0 ;;
        *) usage >&2; exit 2 ;;
    esac
    shift
done

os=$(uname)

install_base_packages() {
    case "$os" in
        Darwin)
            if ! command -v brew >/dev/null 2>&1; then
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            brew install fish kitty neovim starship zoxide lazygit atuin bat eza fzf mise lua node gh tree-sitter stylua
            ;;
        Linux)
            if command -v pacman >/dev/null 2>&1; then
                sudo pacman -S --needed fish kitty neovim starship zoxide lazygit atuin bat eza fzf mise lua nodejs npm github-cli tree-sitter-cli stylua
            else
                printf 'Unsupported Linux package manager. Install packages manually.\n' >&2
                exit 1
            fi
            ;;
        *)
            printf 'Unsupported OS: %s\n' "$os" >&2
            exit 1
            ;;
    esac
}

fish_path() {
    case "$os" in
        Darwin) printf '/opt/homebrew/bin/fish\n' ;;
        Linux) printf '/usr/bin/fish\n' ;;
        *) return 1 ;;
    esac
}

ensure_fish_shell() {
    shell_path=$(fish_path)
    if [ -x "$shell_path" ]; then
        if ! grep -qx "$shell_path" /etc/shells 2>/dev/null; then
            printf '%s\n' "$shell_path" | sudo tee -a /etc/shells >/dev/null
        fi
        chsh -s "$shell_path"
    fi
}

backup_preexisting_app_configs() {
    stamp="$(date +%Y%m%d-%H%M%S)"
    backup="$HOME/.config-backup/$stamp-preexisting"

    for parent in .config .local; do
        git --git-dir="$home_git" ls-tree --name-only "HEAD:$parent" 2>/dev/null |
            while IFS= read -r child; do
                path="$parent/$child"
                [ -e "$HOME/$path" ] || continue
                [ -L "$HOME/$path" ] && continue
                mkdir -p "$backup/$parent"
                mv "$HOME/$path" "$backup/$path"
                printf 'Pre-existing %s moved to %s\n' "$path" "$backup"
            done
    done
}

checkout_dotfiles() {
    fresh_clone=0
    if [ ! -d "$home_git" ]; then
        git clone --bare "$repo_url" "$home_git"
        fresh_clone=1
    fi

    git --git-dir="$home_git" config status.showUntrackedFiles no
    git --git-dir="$home_git" config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'

    if [ -n "$smb_remote" ] && [ -d "$smb_remote" ] && ! git --git-dir="$home_git" remote get-url smb >/dev/null 2>&1; then
        git --git-dir="$home_git" remote add smb "$smb_remote"
    fi

    # A fresh OS (e.g. Omarchy) can preinstall a full app config directory
    # (e.g. ~/.config/nvim as a LazyVim scaffold) whose file paths don't
    # collide with anything this repo tracks. Plain `git checkout` only
    # backs up files it detects as conflicting by exact path, so it would
    # silently leave that preinstalled tree mixed in alongside the tracked
    # one. Move any whole app directory this repo owns out of the way first.
    if [ "$fresh_clone" -eq 1 ]; then
        backup_preexisting_app_configs
    fi

    if ! git --work-tree="$HOME" --git-dir="$home_git" checkout; then
        backup="$HOME/.config-backup/$(date +%Y%m%d-%H%M%S)"
        mkdir -p "$backup"
        git --work-tree="$HOME" --git-dir="$home_git" checkout 2>&1 |
            sed -n 's/^[[:space:]]*//p' |
            while IFS= read -r path; do
                [ -e "$HOME/$path" ] || continue
                mkdir -p "$backup/$(dirname "$path")"
                mv "$HOME/$path" "$backup/$path"
            done
        git --work-tree="$HOME" --git-dir="$home_git" checkout
        printf 'Existing files backed up to %s\n' "$backup"
    fi
}

if [ "$install_packages" -eq 1 ]; then
    install_base_packages
fi

checkout_dotfiles
ensure_fish_shell

if command -v config-doctor >/dev/null 2>&1; then
    config-doctor
fi
