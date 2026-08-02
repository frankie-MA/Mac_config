if status is-interactive

    # Commands to run in interactive sessions can go here
    set -g fish_key_bindings fish_vi_key_bindings

    # Управление дотфайлами через bare git repo, если он есть
    if test -d ~/.cfg
        alias home 'git --work-tree=$HOME --git-dir=$HOME/.cfg'
    end

    # Git UI
    alias lg 'lazygit'
    alias lgc 'lazygit -p $HOME/ghq/github.com/frankie-MA/config'
    alias lgconfig 'lazygit -p $HOME/ghq/github.com/frankie-MA/config'

    # GitHub token для MCP/CLI-инструментов, если gh уже авторизован
    if type -q gh
        set -gx GITHUB_TOKEN (gh auth token 2>/dev/null)
    end

    if test -x /usr/bin/zoxide
        /usr/bin/zoxide init fish | source
    else if type -q zoxide
        zoxide init fish | source
    end

    if type -q starship
        starship init fish | source
    end

end

# Быстрый выход
abbr -a q exit

# Быстрая правка конфигов
abbr -a vf 'nvim ~/.config/fish/config.fish'
abbr -a vk 'nvim ~/.config/kitty/kitty.conf'
abbr -a vs 'nvim ~/.config/starship.toml'

# Перезагрузка конфига Fish на лету
abbr -a sf 'source ~/.config/fish/config.fish'

abbr -a l eza -la --icons

# Заменяем стандартный ls на eza
if type -q eza
    abbr -a l 'eza -lh --icons=always --group-directories-first --git'
    abbr -a ll 'eza -lAh --icons=always --group-directories-first --git'
    abbr -a lt 'eza --tree --level=2 --icons=always' # Дерево файлов
    abbr -a lx 'eza -lbhHigUmuSa@ --color=always --icons=always --git' # Максимальная инфо
end

# Настройка fzf для использования bat при просмотре файлов
set -gx FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border --margin=1 --padding=1 \
--color='fg:#bbccdd,bg:#111111,preview-bg:#005577,preview-fg:#ffffff' \
--preview 'bat --style=numbers --color=always --line-range :500 {}'"

# Если хочешь, чтобы Ctrl+T искал файлы быстрее через ripgrep (если установлен)
set -gx FZF_DEFAULT_COMMAND "rg --files --hidden --glob '!.git/*'"
set -gx OLLAMA_API_BASE http://localhost:11434

# AI context tools: ctx log / ctx skel / ctx git

# Added by codebase-memory-mcp install
fish_add_path /home/frankie/.local/bin

# Added by codebase-memory-mcp install
export PATH="/home/frankie/.local/bin:$PATH"
