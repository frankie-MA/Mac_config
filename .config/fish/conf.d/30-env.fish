set -gx FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border --margin=1 --padding=1 \
--color='fg:#bbccdd,bg:#111111,preview-bg:#005577,preview-fg:#ffffff' \
--preview 'bat --style=numbers --color=always --line-range :500 {}'"
set -gx FZF_DEFAULT_COMMAND "rg --files --hidden --glob '!.git/*'"

set -gx OLLAMA_API_BASE http://localhost:11434

# Use the systemd user SSH agent on Linux.
if test (uname -s) = Linux
    set -l ssh_runtime_dir "$XDG_RUNTIME_DIR"
    if test -z "$ssh_runtime_dir"
        set ssh_runtime_dir "/run/user/"(id -u)
    end
    set -gx SSH_AUTH_SOCK "$ssh_runtime_dir/ssh-agent.socket"
end
