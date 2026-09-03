#!/bin/sh

set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
test_dir=$(mktemp -d "${TMPDIR:-/tmp}/mount-config-smb-test.XXXXXX")
trap 'rm -rf "$test_dir"' EXIT HUP INT TERM

cp "$repo_root/.local/bin/mount-config-smb" "$test_dir/mount-config-smb"
sed \
    -e "s#/sbin/mount#$test_dir/mount#g" \
    -e "s#/usr/bin/nc#$test_dir/nc#g" \
    -e "s#/usr/bin/osascript#$test_dir/osascript#g" \
    "$test_dir/mount-config-smb" > "$test_dir/mount-config-smb.test"
chmod +x "$test_dir/mount-config-smb.test"

printf '#!/bin/sh\nprintf "Darwin\\n"\n' > "$test_dir/uname"
printf '#!/bin/sh\nexit 0\n' > "$test_dir/mount"
printf '#!/bin/sh\ntest "${SMB_TEST_REACHABLE:-0}" = 1\n' > "$test_dir/nc"
printf '#!/bin/sh\nprintf "called\\n" >> "$SMB_TEST_CALLS"\nexit 0\n' > "$test_dir/osascript"
chmod +x "$test_dir/uname" "$test_dir/mount" "$test_dir/nc" "$test_dir/osascript"

SMB_TEST_CALLS="$test_dir/osascript.calls"
export SMB_TEST_CALLS
PATH="$test_dir:$PATH" "$test_dir/mount-config-smb.test" >/dev/null 2>&1 || true

if test -s "$SMB_TEST_CALLS"; then
    echo 'FAIL: attempted GUI SMB mount while the server was unreachable' >&2
    exit 1
fi

SMB_TEST_REACHABLE=1
export SMB_TEST_REACHABLE
PATH="$test_dir:$PATH" "$test_dir/mount-config-smb.test" >/dev/null 2>&1

if test "$(wc -l < "$SMB_TEST_CALLS" | tr -d ' ')" -ne 1; then
    echo 'FAIL: reachable SMB server did not trigger exactly one GUI mount attempt' >&2
    exit 1
fi

echo 'ok: SMB mount is attempted only when the server is reachable'
