# Config — Dotfiles

Единые конфиги kitty, fish, nvim и starship для macOS и Linux.
Различия по ОС вынесены в отдельные файлы или условные блоки.

---

## Восстановление на новой машине

### 1. Базовые инструменты

macOS:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install fish kitty neovim starship zoxide lazygit atuin bat eza fzf mise lua node gh tree-sitter stylua
```

Arch/Omarchy:
```bash
sudo pacman -S fish kitty neovim starship zoxide lazygit atuin bat eza fzf mise lua nodejs npm github-cli tree-sitter-cli stylua
```

### 2. uv (менеджер Python-окружений)

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### 3. Python-инструменты

```bash
uv tool install ruff
```

### 4. npm-инструменты

```bash
npm install -g prettier tree-sitter-cli
```

### 5. MCP серверы для Claude Code

```bash
npm install -g \
  @modelcontextprotocol/server-filesystem \
  @modelcontextprotocol/server-github \
  @modelcontextprotocol/server-memory \
  @modelcontextprotocol/server-sequential-thinking
```

```bash
pip3 install mcp mcp-server-tree-sitter
```

### 6. Установить fish как шелл по умолчанию

macOS:
```bash
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish
```

Linux:
```bash
echo /usr/bin/fish | sudo tee -a /etc/shells
chsh -s /usr/bin/fish
```

### 7. Клонировать bare repo с конфигами

```bash
git clone --bare git@github.com:frankie-MA/config.git ~/.cfg
git --git-dir=$HOME/.cfg config status.showUntrackedFiles no
git --git-dir=$HOME/.cfg remote add smb /mnt/katecloud/homes/repo/git/config.git

# Применить конфиги
git --work-tree=$HOME --git-dir=$HOME/.cfg checkout

# Если git ругается на конфликты — сделать бэкап существующих файлов и повторить
mkdir -p ~/.config-backup
git --work-tree=$HOME --git-dir=$HOME/.cfg checkout 2>&1 \
  | grep "^\s" \
  | awk '{print $1}' \
  | xargs -I{} mv ~/{} ~/.config-backup/{}
git --work-tree=$HOME --git-dir=$HOME/.cfg checkout
```

SMB mirror для копий repo:

```bash
home push origin main
home push smb main
```

### 8. Авторизация

```bash
# GitHub CLI
gh auth login

# SSH ключ (если нужен новый)
ssh-keygen -t ed25519 -C "$(hostname)"
cat ~/.ssh/id_ed25519.pub  # добавить на github.com/settings/keys
```

### 9. Запустить nvim

При первом запуске `nvim` автоматически:
- установит lazy.nvim
- скачает все плагины
- mason установит LSP серверы (pyright, lua_ls, bashls, yamlls, dockerls и др.)

---

## Ежедневная работа с конфигами

Алиас `home` доступен после старта fish:

```fish
home status                           # посмотреть изменения
home add .config/kitty/kitty.conf     # добавить файл
home commit -m "update kitty"         # закоммитить
home push                             # отправить на GitHub
```

---

## Структура конфигов

```
~/.config/
├── kitty/
│   ├── kitty.conf        # общие настройки терминала
│   ├── macos.conf        # настройки macOS
│   ├── linux.conf        # настройки Linux
│   ├── catppuccin/       # темы Catppuccin
│   ├── catppuccin-current.conf
│   └── switch-catppuccin # переключатель темы Kitty + Neovim
├── fish/
│   └── config.fish       # shell, PATH и алиасы
├── nvim/
│   ├── init.lua           # точка входа, lazy.nvim bootstrap
│   └── lua/
│       ├── options.lua    # настройки vim
│       ├── keymaps.lua    # глобальные биндинги
│       └── plugins/       # плагины (по одному файлу на плагин)
└── claude/
    └── settings.json     # MCP серверы для Claude Code
~/.gitconfig               # git user.name / user.email
```

---

## Ключевые биндинги nvim

| Клавиши | Действие |
|---|---|
| `<Space>pv` | Файловый менеджер (oil.nvim) |
| `<Space>ff` | Поиск файлов (telescope) |
| `<Space>fg` | Поиск по коду (grep) |
| `<Space>lg` | LazyGit |
| `<Space>tt` | Терминал float |
| `<Space>vs` | Выбор Python venv (uv) |
| `<Space>fm` | Форматировать файл |
| `<Space>` | Показать все биндинги (which-key) |
| `gd` | Go to definition |
| `K` | Документация |
| `gcc` | Закомментировать строку |
