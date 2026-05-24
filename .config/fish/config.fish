if status is-interactive
    # Добавляем Homebrew в PATH (macOS не подхватывает /etc/paths в fish)
    fish_add_path /opt/homebrew/bin /opt/homebrew/sbin

    # Управление дотфайлами через bare git repo (по мотивам paragraph.com/@bobuk/git-home-config)
    alias home 'git --work-tree=$HOME --git-dir=$HOME/.cfg'
end

starship init fish | source
