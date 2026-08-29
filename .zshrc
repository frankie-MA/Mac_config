# Optional fallback for Zsh; Fish is the primary interactive shell.
if [[ -f "$HOME/.local/bin/env" ]]; then
    source "$HOME/.local/bin/env"
else
    export PATH="$HOME/.local/bin:$PATH"
fi

# Use the systemd user SSH agent on Linux.
if [[ "$(uname -s)" == "Linux" ]]; then
    export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/ssh-agent.socket"
fi
