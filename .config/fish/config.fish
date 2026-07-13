if status is-interactive
    # Homebrew в PATH (macOS не подхватывает /etc/paths в fish)
    fish_add_path /opt/homebrew/bin /opt/homebrew/sbin

    # Управление дотфайлами через bare git repo
    alias home 'git --work-tree=$HOME --git-dir=$HOME/.cfg'
    alias lgh 'lazygit --work-tree=$HOME --git-dir=$HOME/.cfg'

    # SSH-ключ в агент (macOS Keychain хранит passphrase)
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519 2>/dev/null

    # Не экспортируем GITHUB_TOKEN глобально: gh предпочитает env-token keyring-auth.

    # Промпт и навигация (только в интерактивных сессиях)
    starship init fish | source
    zoxide init fish | source

    set -g fish_key_bindings fish_vi_key_bindings
end

# Added by codebase-memory-mcp install
export PATH="/Users/frankie/.local/bin:$PATH"

# mise
if status is-interactive
    /opt/homebrew/bin/mise activate fish | source
end
