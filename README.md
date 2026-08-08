# Config — Dotfiles

Единые конфиги kitty, fish, nvim и starship для macOS и Linux.
Различия по ОС вынесены в отдельные файлы или условные блоки.

---

## Bootstrap

Новая машина описана в `docs/bootstrap.md`; автоматизация лежит в `install/bootstrap.sh`.

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
sync-config                           # ff-only pull, push origin, push SMB, doctor
config-doctor                         # проверить fish/nvim/starship/kitty/repo mirror
```

`lazy-lock.json` не трекается: каждая ОС держит свои версии плагинов локально.

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
│   ├── config.fish       # минимальный интерактивный bootstrap
│   └── conf.d/           # paths, aliases, tools, env
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

Основной список: `~/.config/nvim/KEYMAPS.md`.
