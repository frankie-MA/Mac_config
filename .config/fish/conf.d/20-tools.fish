if status is-interactive
    if test (uname) = Darwin; and test -f "$HOME/.ssh/id_ed25519"
        ssh-add --apple-use-keychain "$HOME/.ssh/id_ed25519" 2>/dev/null
    end

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
