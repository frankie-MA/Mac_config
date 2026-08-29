function dotfiles --description 'Open the dotfiles working clone in Neovim'
    set -l config_repo "$HOME/ghq/github.com/frankie-MA/config"

    if not test -d "$config_repo/.git"
        echo "dotfiles: working clone not found: $config_repo" >&2
        return 1
    end

    cd "$config_repo"; or return
    command nvim .
end
