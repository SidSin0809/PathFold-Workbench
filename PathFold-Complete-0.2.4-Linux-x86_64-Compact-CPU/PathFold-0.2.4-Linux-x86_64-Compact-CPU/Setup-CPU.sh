#!/bin/sh
# Install the immutable complete CPU edition to an owned, separately writable directory.
set -eu
bundle_root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
case "$(uname -s)/$(uname -m)" in Linux/x86_64) ;; *) printf '%s\n' 'PathFold CPU runtime requires Linux x86-64.' >&2; exit 2;; esac
archive="$bundle_root/packages/PathFold-CPU-Edition-0.2.4-Linux-x86_64.tar.gz"
expected=4728926f28210272f3bf60391af09a050177b4b73a9e4fb4a7c08b83f2323a2c
if [ ! -f "$archive" ]; then printf '%s\n' 'The bundled complete CPU archive is missing.' >&2; exit 2; fi
actual=$(sha256sum -- "$archive"); actual=${actual%% *}
if [ "$actual" != "$expected" ]; then printf '%s\n' 'CPU archive hash differs from the qualified release; setup refused.' >&2; exit 2; fi
cpu_home=${PATHFOLD_CPU_HOME:-$bundle_root/cpu}
if [ -L "$cpu_home" ]; then printf '%s\n' 'CPU home must not be a symlink; existing contents are preserved.' >&2; exit 2; fi
mkdir -p -- "$cpu_home"
cpu_home=$(CDPATH= cd -- "$cpu_home" && pwd)
cpu_root="$cpu_home/PathFold-CPU-Edition-0.2.4-Linux-x86_64"
owner="$cpu_home/.pathfold-cpu-0.2.4.owner"
lock="$cpu_home/.pathfold-cpu-0.2.4.setup-lock"
if ! mkdir -- "$lock" 2>/dev/null; then printf '%s\n' 'Another setup or an interrupted setup lock exists. Preserve it and inspect before retrying.' >&2; exit 2; fi
stage=
cleanup() {
    if [ -n "$stage" ] && [ -d "$stage" ]; then rm -rf -- "$stage"; fi
    rmdir -- "$lock" 2>/dev/null || :
}
trap cleanup 0
trap 'exit 130' INT
trap 'exit 143' TERM
if [ -e "$cpu_root" ] || [ -L "$cpu_root" ]; then
    if [ -L "$cpu_root" ] || [ ! -f "$owner" ] || [ -L "$owner" ] || [ "$(cat -- "$owner")" != "$expected" ]; then
        printf '%s\n' 'An unowned or incomplete CPU edition already exists. It was preserved. Choose a fresh PATHFOLD_CPU_HOME.' >&2
        exit 2
    fi
    "$cpu_root/engine/PathFoldEngine" diagnostics --verify-package "$cpu_root" >/dev/null
    printf '%s\n' "$cpu_root"
    exit 0
fi
if [ -e "$owner" ] || [ -L "$owner" ]; then
    printf '%s\n' 'An orphaned CPU ownership marker exists. It was preserved. Choose a fresh PATHFOLD_CPU_HOME.' >&2
    exit 2
fi
# The original archive has already been hashed; GNU tar preserves its executable modes.
stage=$(mktemp -d "$cpu_home/.pathfold-cpu-stage.XXXXXXXX")
tar -xzf "$archive" -C "$stage" --no-same-owner
staged_root="$stage/PathFold-CPU-Edition-0.2.4-Linux-x86_64"
if [ ! -x "$staged_root/engine/PathFoldEngine" ]; then printf '%s\n' 'CPU runtime extraction is incomplete; existing editions were preserved.' >&2; exit 2; fi
"$staged_root/engine/PathFoldEngine" diagnostics --verify-package "$staged_root" >/dev/null
# The lock prevents another copy of this setup from merging into the destination.
if [ -e "$cpu_root" ] || [ -L "$cpu_root" ]; then printf '%s\n' 'CPU destination appeared during setup; existing contents were preserved.' >&2; exit 2; fi
mv -T -n -- "$staged_root" "$cpu_root"
if [ -e "$staged_root" ]; then printf '%s\n' 'CPU destination appeared during setup; existing contents were preserved.' >&2; exit 2; fi
printf '%s\n' "$expected" > "$lock/owner.new"
mv -T -n -- "$lock/owner.new" "$owner"
if [ -e "$lock/owner.new" ]; then printf '%s\n' 'CPU owner marker appeared during setup. The extracted edition was preserved for inspection.' >&2; exit 2; fi
printf '%s\n' "$cpu_root"
