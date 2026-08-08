# Bootstrap

## macOS

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install fish kitty neovim starship zoxide lazygit atuin bat eza fzf mise lua node gh tree-sitter stylua
curl -LsSf https://astral.sh/uv/install.sh | sh
uv tool install ruff
npm install -g prettier tree-sitter-cli
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish
```

## Arch/Omarchy

```bash
sudo pacman -S fish kitty neovim starship zoxide lazygit atuin bat eza fzf mise lua nodejs npm github-cli tree-sitter-cli stylua
curl -LsSf https://astral.sh/uv/install.sh | sh
uv tool install ruff
npm install -g prettier tree-sitter-cli
echo /usr/bin/fish | sudo tee -a /etc/shells
chsh -s /usr/bin/fish
```

## Dotfiles

Fast path:

```bash
./install/bootstrap.sh --packages
```

Manual path:

```bash
git clone --bare git@github.com:frankie-MA/config.git ~/.cfg
git --git-dir=$HOME/.cfg config status.showUntrackedFiles no
git --git-dir=$HOME/.cfg config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
git --git-dir=$HOME/.cfg remote add smb /mnt/katecloud/homes/repo/git/config.git
git --work-tree=$HOME --git-dir=$HOME/.cfg checkout
```

If checkout reports conflicts, move the listed files to a backup directory and repeat checkout.
