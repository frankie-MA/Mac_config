function home --description 'git for the dotfiles bare repo (~/.cfg, work-tree $HOME)'
    # add/mv/rm take pathspecs that resolve against $PWD, not $HOME, even
    # though --work-tree is $HOME. Running these from anywhere else silently
    # does nothing useful, then `commit` fails with a confusing "no changes
    # added to commit" -- no hint that the real cause was cwd. This has
    # actually bitten a previous session; refuse loudly instead of repeating it.
    switch "$argv[1]"
        case add mv rm
            if test "$PWD" != "$HOME"
                echo "home: refusing to run '$argv[1]' -- cwd is $PWD, not \$HOME." >&2
                echo "home: pathspecs resolve against \$PWD, not \$HOME -- run 'cd \$HOME' first." >&2
                return 1
            end
    end

    git --work-tree=$HOME --git-dir=$HOME/.cfg $argv
end
