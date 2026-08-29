# Config — Dotfiles

Единые конфиги kitty, fish, nvim и starship для macOS и Linux.
Различия по ОС вынесены в отдельные файлы или условные блоки.

---

## Bootstrap

Новая машина описана в `docs/bootstrap.md`. На свежей macOS начни с temporary clone:

```bash
git clone git@github.com:frankie-MA/config.git ~/config-bootstrap
cd ~/config-bootstrap
./install/bootstrap.sh --packages
```

Настройка GitHub SSH для Bash, Zsh и Fish: [короткая инструкция](docs/github-ssh.md).

После перезапуска shell проверь состояние:

```bash
config-doctor
```

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
check-config                          # быстрые syntax/runtime проверки
sync-config                           # ff-only pull, push origin, push SMB, doctor
config-doctor                         # проверить fish/nvim/starship/kitty/repo mirror/claude MCP
setup-claude-mcp                      # (пере)накатить MCP-серверы в ~/.claude.json
```

`setup-claude-mcp` вызывается автоматически при `bootstrap.sh`, но идемпотентен — можно
перезапускать вручную, чтобы добавить новые серверы или починить локальный `~/.claude.json`.
`~/.claude.json` не трекается (там же токены/сессии/кэш Claude Code), поэтому серверы туда
подмешиваются скриптом, а не хранятся в git.

`lazy-lock.json` не трекается: каждая ОС держит свои версии плагинов локально.
Правила repo: `docs/policy.md`.

### Автомонтирование SMB на macOS

LaunchAgent `com.mafrankie.config-smb` один раз при входе в macOS проверяет
`/Volumes/homes` и при необходимости монтирует
`smb://frankie@kateCloud._smb._tcp.local/homes`. Пароль в dotfiles не хранится:
macOS использует запись из Keychain. Для первичной установки сохрани пароль при
ручном подключении в Finder, затем один раз загрузи агент:

```sh
launchctl bootstrap "gui/$(id -u)" ~/Library/LaunchAgents/com.mafrankie.config-smb.plist
launchctl kickstart -k "gui/$(id -u)/com.mafrankie.config-smb"
```

Периодического опроса нет, поэтому агент не будит Mac в фоне. Если NAS был
недоступен во время входа, позже запусти `mount-config-smb` вручную.

Адрес и точку монтирования можно переопределить переменными
`SMB_CONFIG_URL` и `SMB_CONFIG_MOUNT_POINT` при ручном запуске скрипта.
Скрипты синхронизации не проверяют имя ОС: они ищут реально смонтированный
каталог среди `/Volumes/homes` и `/mnt/katecloud/homes`. Нестандартное зеркало
можно задать через `SMB_CONFIG_REMOTE`.

### Автомонтирование SMB на Linux

Однократно (нужен sudo и реальный пароль от шары):

```sh
./install/setup-smb-automount-linux.sh
```

Скрипт создаёт пару systemd-юнитов `.mount`/`.automount` на `/mnt/katecloud/homes`
(адрес `192.168.88.254`, шара `homes` — переопределяются через `SMB_CONFIG_HOST` /
`SMB_CONFIG_SHARE` / `SMB_CONFIG_MOUNT_POINT`) и файл с учётными данными
`/etc/samba/credentials-katecloud` (root-only, 600, не трекается в git — аналог
Keychain на macOS). При первом запуске пароль там будет заглушкой `CHANGE_ME`,
скрипт подскажет команду для правки.

Монтирование ленивое: юнит `.automount` цепляет CIFS-шару при первом обращении к
пути (даже просто `stat`/`ls`) и отмонтирует через 10 минут простоя — как и на
macOS, без периодического опроса в фоне. `sync-config`/`config-doctor`/
`bootstrap.sh` сами трогают точку монтирования перед проверкой, так что
автомонт срабатывает прозрачно при обычной работе.

Скрипт можно запускать и напрямую (`./install/setup-smb-automount-linux.sh`,
он сам зовёт `sudo` только для нужных команд), и целиком под `sudo` — в обоих
случаях владельцем точки монтирования корректно станет реальный пользователь,
а не root.

Если уже существует `~/.config/gtk-3.0/bookmarks` (Nautilus/Nemo/Thunar),
скрипт добавит туда закладку на `/mnt/katecloud/homes`, чтобы зеркало было
видно в боковой панели файлового менеджера.

### Правило для проверок

Каталог `~/.local/bin` может содержать и скрипты, и бинарные программы. Поэтому
проверки должны определять тип файла по shebang или расширению и запускать
валидатор только для подходящего типа. Нельзя передавать весь каталог одному
интерпретатору (например, делать `sh -n ~/.local/bin/*`).

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
~/.gitconfig               # git user.name / user.email
```

---

## Ключевые биндинги nvim

Основной список: `~/.config/nvim/KEYMAPS.md`.
