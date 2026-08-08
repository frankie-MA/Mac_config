set -gx FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border --margin=1 --padding=1 \
--color='fg:#bbccdd,bg:#111111,preview-bg:#005577,preview-fg:#ffffff' \
--preview 'bat --style=numbers --color=always --line-range :500 {}'"
set -gx FZF_DEFAULT_COMMAND "rg --files --hidden --glob '!.git/*'"

set -gx OLLAMA_API_BASE http://localhost:11434
