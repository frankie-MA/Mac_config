# Mac Config — Dotfiles

Конфиги kitty, fish, nvim и Claude Code для macOS (Apple Silicon).

---

## Восстановление на новой машине

### 1. Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Базовые инструменты

```bash
brew install fish kitty neovim starship zoxide lazygit atuin bat eza fzf mise lua node gh tree-sitter stylua
```

### 3. uv (менеджер Python-окружений)

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### 4. Python-инструменты

```bash
uv tool install ruff
```

### 5. npm-инструменты

```bash
npm install -g prettier tree-sitter-cli
```

### 6. MCP серверы для Claude Code

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

### 7. Установить fish как шелл по умолчанию

```bash
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish
```

### 8. Клонировать репо с конфигами

```bash
git clone --bare git@github.com:frankie-MA/config.git ~/.cfg

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

### 9. Авторизация

```bash
# GitHub CLI
gh auth login

# SSH ключ (если нужен новый)
ssh-keygen -t ed25519 -C "MAC"
cat ~/.ssh/id_ed25519.pub  # добавить на github.com/settings/keys
```

### 10. Запустить nvim

При первом запуске `nvim` автоматически:
- установит lazy.nvim
- скачает все плагины
- mason установит LSP серверы (pyright, lua_ls, bashls, yamlls, dockerls и др.)

### 11. Установить темы Kitty

```bash
git clone https://github.com/kovidgoyal/kitty-themes.git ~/.config/kitty/kitty-themes
```

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
│   └── theme.conf        # выбранная тема из kitty-themes
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
