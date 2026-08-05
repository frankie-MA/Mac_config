# Optional fallback for Zsh; Fish is the primary interactive shell.
if [[ -f "$HOME/.local/bin/env" ]]; then
    source "$HOME/.local/bin/env"
else
    export PATH="$HOME/.local/bin:$PATH"
fi
