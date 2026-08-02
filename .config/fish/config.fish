if status is-interactive
    # Homebrew в PATH на macOS
    if test (uname) = Darwin
        fish_add_path /opt/homebrew/bin /opt/homebrew/sbin
    end

    set -g fish_key_bindings fish_vi_key_bindings

    # Управление дотфайлами через bare git repo
    if test -d "$HOME/.cfg"
        alias home 'git --work-tree=$HOME --git-dir=$HOME/.cfg'
        alias lgh 'lazygit --work-tree=$HOME --git-dir=$HOME/.cfg'
    end

    alias lg lazygit

    # macOS Keychain хранит passphrase ключа
    if test (uname) = Darwin; and test -f "$HOME/.ssh/id_ed25519"
        ssh-add --apple-use-keychain "$HOME/.ssh/id_ed25519" 2>/dev/null
    end

    # gh использует системный keyring; GITHUB_TOKEN глобально не экспортируем.
    if type -q starship
        starship init fish | source
    end

    if type -q zoxide
        zoxide init fish | source
    end

    if type -q mise
        mise activate fish | source
    end
end

# Быстрые команды
abbr -a q exit
abbr -a cat bat
abbr -a vf 'nvim ~/.config/fish/config.fish'
abbr -a vk 'nvim ~/.config/kitty/kitty.conf'
abbr -a vs 'nvim ~/.config/starship.toml'
abbr -a sf 'source ~/.config/fish/config.fish'

# Заменяем стандартный ls на eza, когда он установлен
if type -q eza
    abbr -a l 'eza -lh --icons=always --group-directories-first --git'
    abbr -a ll 'eza -lAh --icons=always --group-directories-first --git'
    abbr -a lt 'eza --tree --level=2 --icons=always'
    abbr -a lx 'eza -lbhHigUmuSa@ --color=always --icons=always --git'
end

# fzf с предпросмотром файлов через bat
set -gx FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border --margin=1 --padding=1 \
--color='fg:#bbccdd,bg:#111111,preview-bg:#005577,preview-fg:#ffffff' \
--preview 'bat --style=numbers --color=always --line-range :500 {}'"
set -gx FZF_DEFAULT_COMMAND "rg --files --hidden --glob '!.git/*'"

set -gx OLLAMA_API_BASE http://localhost:11434
fish_add_path "$HOME/.local/bin"
