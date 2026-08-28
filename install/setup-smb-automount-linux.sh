#!/bin/sh

# One-time, interactive setup for the SMB mirror (kateCloud) on Linux.
# Installs a systemd .mount + .automount unit pair so the mirror mounts
# itself on first access (git push, `ls`, etc.) and unmounts after being
# idle -- no login-time script, no periodic polling. Needs sudo and a
# real password, so this is not run automatically by bootstrap.sh; run it
# by hand once per machine.

set -eu

[ "$(uname -s)" = "Linux" ] || {
    printf 'this script is Linux-only (macOS uses mount-config-smb + a LaunchAgent instead)\n' >&2
    exit 1
}

command -v mount.cifs >/dev/null 2>&1 || {
    printf 'missing mount.cifs -- install cifs-utils first\n' >&2
    exit 1
}

mount_point="${SMB_CONFIG_MOUNT_POINT:-/mnt/katecloud/homes}"
smb_host="${SMB_CONFIG_HOST:-192.168.88.254}"
smb_share="${SMB_CONFIG_SHARE:-homes}"
smb_user="${SMB_CONFIG_USER:-frankie}"
creds_file="${SMB_CONFIG_CREDS:-/etc/samba/credentials-katecloud}"
uid="$(id -u)"
gid="$(id -g)"

sudo mkdir -p "$mount_point"
sudo mkdir -p "$(dirname "$creds_file")"

if [ ! -f "$creds_file" ]; then
    sudo install -m 600 /dev/null "$creds_file"
    printf 'username=%s\npassword=CHANGE_ME\n' "$smb_user" | sudo tee "$creds_file" >/dev/null
    printf 'Created %s with a placeholder password.\n' "$creds_file"
    printf 'Edit it now: sudo "${EDITOR:-vi}" %s\n' "$creds_file"
    printf '(mirrors what the macOS LaunchAgent gets from Keychain -- this file is root-only, 600, and never tracked in git)\n'
else
    printf '%s already exists, leaving it as-is.\n' "$creds_file"
fi

unit_base="$(systemd-escape --path "$mount_point")"
mount_unit="/etc/systemd/system/$unit_base.mount"
automount_unit="/etc/systemd/system/$unit_base.automount"

sudo tee "$mount_unit" >/dev/null <<UNIT
[Unit]
Description=SMB mirror (kateCloud) for frankie-MA/config dotfiles

[Mount]
What=//$smb_host/$smb_share
Where=$mount_point
Type=cifs
Options=credentials=$creds_file,uid=$uid,gid=$gid,_netdev,noserverino
UNIT

sudo tee "$automount_unit" >/dev/null <<UNIT
[Unit]
Description=Automount SMB mirror (kateCloud) for frankie-MA/config dotfiles

[Automount]
Where=$mount_point
TimeoutIdleSec=600

[Install]
WantedBy=multi-user.target
UNIT

sudo systemctl daemon-reload
sudo systemctl enable --now "$unit_base.automount"

printf 'ok: %s will automount on first access and unmount after 10 min idle\n' "$mount_point"
printf 'If the password above is still CHANGE_ME, edit %s then run:\n' "$creds_file"
printf '  sudo systemctl restart %s.automount\n' "$unit_base"
printf 'Test it with: ls %s\n' "$mount_point"
