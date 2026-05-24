if status is-interactive
    # Добавляем Homebrew в PATH (macOS не подхватывает /etc/paths в fish)
    fish_add_path /opt/homebrew/bin /opt/homebrew/sbin

    # Управление дотфайлами через bare git repo (по мотивам paragraph.com/@bobuk/git-home-config)
    alias home 'git --work-tree=$HOME --git-dir=$HOME/.cfg'

    # SSH-ключ в агент (macOS Keychain хранит passphrase)
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519 2>/dev/null

    # GitHub token для MCP сервера (берём из gh CLI)
    set -x GITHUB_TOKEN (gh auth token 2>/dev/null)
end

starship init fish | source
zoxide init fish | source
