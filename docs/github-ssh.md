# GitHub по SSH без повторного ввода пароля

Используй SSH-адрес репозитория:

```text
git@github.com:OWNER/REPOSITORY.git
```

## 1. Создать ключ (один раз)

Если `~/.ssh/id_ed25519` уже существует, пропусти этот шаг.

```sh
ssh-keygen -t ed25519 -C "EMAIL"
```

Приватный файл `~/.ssh/id_ed25519` никому не показывай и не добавляй в git.
На GitHub добавляется только содержимое `~/.ssh/id_ed25519.pub`:

```sh
cat ~/.ssh/id_ed25519.pub
```

Путь в GitHub: **Settings → SSH and GPG keys → New SSH key**.

## 2. Запустить агент и добавить ключ

### Bash

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

### Zsh

```zsh
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

### Fish

```fish
set -e SSH_AUTH_SOCK SSH_AGENT_PID
eval (ssh-agent -c)
ssh-add ~/.ssh/id_ed25519
```

Парольная фраза ключа запрашивается один раз на время жизни агента. Не убирай
её из ключа только ради удобства; постоянный агент или системное хранилище
ключей безопаснее.

## 3. Проверить

```sh
ssh-add -l
ssh -T git@github.com
```

После успешной проверки:

```sh
git clone git@github.com:OWNER/REPOSITORY.git
```

Если существующий remote использует HTTPS, переключи его:

```sh
git remote set-url origin git@github.com:OWNER/REPOSITORY.git
```

Команды выше запускают агент только для текущей login-сессии. Для постоянной
настройки лучше использовать один пользовательский `ssh-agent` через systemd
на Linux или Keychain на macOS, а не запускать новый агент в каждом терминале.
