if status is-interactive
    # `home` is a function (functions/home.fish), not an alias here -- it
    # guards against running add/mv/rm from outside $HOME.
    if test -d "$HOME/.cfg"
        alias lgh 'lazygit --work-tree=$HOME --git-dir=$HOME/.cfg'
    end

    if test -d "$HOME/ghq/github.com/frankie-MA/config/.git"
        alias lgc 'lazygit -p $HOME/ghq/github.com/frankie-MA/config'
        alias lgconfig 'lazygit -p $HOME/ghq/github.com/frankie-MA/config'
    end

    alias lg 'lazygit'

    abbr -a q exit
    abbr -a cat bat
    abbr -a vf 'nvim ~/.config/fish/config.fish'
    abbr -a vk 'nvim ~/.config/kitty/kitty.conf'
    abbr -a vs 'nvim ~/.config/starship.toml'
    abbr -a sf 'source ~/.config/fish/config.fish'

    if type -q eza
        abbr -a l 'eza -lh --icons=always --group-directories-first --git'
        abbr -a ll 'eza -lAh --icons=always --group-directories-first --git'
        abbr -a lt 'eza --tree --level=2 --icons=always'
        abbr -a lx 'eza -lbhHigUmuSa@ --color=always --icons=always --git'
    end
end
