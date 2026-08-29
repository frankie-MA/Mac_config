# GitHub SSH: Русский / English

## Русский

### Что настраивается

На Linux используется один штатный пользовательский `ssh-agent`, запущенный
через systemd socket activation. Bash, Zsh и Fish подключаются к одному сокету:

```text
$XDG_RUNTIME_DIR/ssh-agent.socket
```

Не запускай `eval "$(ssh-agent -s)"` или `eval (ssh-agent -c)` в каждом
терминале: это создаёт несколько независимых агентов.

На macOS используется системный SSH-agent и Keychain. Настройки
`AddKeysToAgent` и `UseKeychain` находятся в `~/.ssh/config`.

### Первичная настройка

Если `~/.ssh/id_ed25519` уже существует, новый ключ создавать не нужно.

```sh
ssh-keygen -t ed25519 -C "EMAIL"
```

Приватный ключ `~/.ssh/id_ed25519` никому не показывай и не добавляй в git.
На GitHub добавляется только публичный ключ:

```sh
cat ~/.ssh/id_ed25519.pub
```

Добавь его в **GitHub → Settings → SSH and GPG keys → New SSH key**.

На Linux включи штатный systemd-сокет один раз:

```sh
systemctl --user enable --now ssh-agent.socket
```

Перезапусти shell и добавь ключ:

```sh
ssh-add ~/.ssh/id_ed25519
```

Для Fish перезапуск текущего shell:

```fish
exec fish
```

Для Bash или Zsh открой новый терминал либо выполни `exec bash` / `exec zsh`.

### После перезагрузки

Запускать агент вручную больше не требуется. При первом подключении к GitHub
OpenSSH добавит ключ в агент благодаря `AddKeysToAgent yes`. Если ключ защищён
passphrase, система запросит её один раз после перезагрузки; остальные
`clone`, `pull` и `push` в этой сессии пройдут без повторного запроса.

### Проверка и использование

```sh
systemctl --user status ssh-agent.socket
ssh-add -l
ssh -T git@github.com
git clone git@github.com:OWNER/REPOSITORY.git
```

Переключить существующий remote с HTTPS на SSH:

```sh
git remote set-url origin git@github.com:OWNER/REPOSITORY.git
```

## English

### What this configures

Linux uses one system-provided user `ssh-agent`, started through systemd socket
activation. Bash, Zsh, and Fish all connect to the same socket:

```text
$XDG_RUNTIME_DIR/ssh-agent.socket
```

Do not run `eval "$(ssh-agent -s)"` or `eval (ssh-agent -c)` in every terminal;
that creates multiple independent agents.

macOS uses its system SSH agent and Keychain. `AddKeysToAgent` and
`UseKeychain` are configured in `~/.ssh/config`.

### Initial setup

If `~/.ssh/id_ed25519` already exists, do not create another key.

```sh
ssh-keygen -t ed25519 -C "EMAIL"
```

Never share or commit the private `~/.ssh/id_ed25519` file. Add only the public
key to GitHub:

```sh
cat ~/.ssh/id_ed25519.pub
```

Add it under **GitHub → Settings → SSH and GPG keys → New SSH key**.

On Linux, enable the system socket once:

```sh
systemctl --user enable --now ssh-agent.socket
```

Restart the shell and add the key:

```sh
ssh-add ~/.ssh/id_ed25519
```

For Fish, restart the current shell with:

```fish
exec fish
```

For Bash or Zsh, open a new terminal or run `exec bash` / `exec zsh`.

### After a reboot

You no longer need to start the agent manually. On the first GitHub connection,
OpenSSH adds the key to the agent because of `AddKeysToAgent yes`. If the key is
protected by a passphrase, enter it once after the reboot; subsequent `clone`,
`pull`, and `push` commands in that session will not ask again.

### Verify and use

```sh
systemctl --user status ssh-agent.socket
ssh-add -l
ssh -T git@github.com
git clone git@github.com:OWNER/REPOSITORY.git
```

Switch an existing remote from HTTPS to SSH:

```sh
git remote set-url origin git@github.com:OWNER/REPOSITORY.git
```
