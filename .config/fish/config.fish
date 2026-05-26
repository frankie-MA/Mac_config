if status is-interactive
    # Homebrew в PATH (macOS не подхватывает /etc/paths в fish)
    fish_add_path /opt/homebrew/bin /opt/homebrew/sbin

    # Управление дотфайлами через bare git repo
    alias home 'git --work-tree=$HOME --git-dir=$HOME/.cfg'

    # SSH-ключ в агент (macOS Keychain хранит passphrase)
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519 2>/dev/null

    # GitHub token для MCP сервера
    set -x GITHUB_TOKEN (/opt/homebrew/bin/gh auth token 2>/dev/null)

    # Промпт и навигация (только в интерактивных сессиях)
    starship init fish | source
    zoxide init fish | source
end
