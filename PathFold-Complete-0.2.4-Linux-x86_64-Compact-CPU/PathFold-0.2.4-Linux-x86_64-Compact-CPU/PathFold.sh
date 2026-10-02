#!/bin/sh
# PathFold 0.2.4 final distribution wrapper; original AppImage stays immutable.
set -eu
bundle_root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
case "$(uname -s)/$(uname -m)" in Linux/x86_64) ;; *) printf '%s\n' 'PathFold portable runtime requires Linux x86-64.' >&2; exit 2;; esac
appimage=${PATHFOLD_APPIMAGE:-$bundle_root/runtime/PathFoldWorkbench-0.2.4-x86_64.AppImage}
if [ ! -f "$appimage" ] || [ ! -x "$appimage" ]; then printf '%s\n' 'The bundled AppImage is missing or not executable. Preserve the package and re-extract with permissions.' >&2; exit 2; fi
expected=a3c08cbef277ee7248abe80b2f31c326b511ae33b54dd978e02b8a7bfe750729
actual=$(sha256sum -- "$appimage"); actual=${actual%% *}
if [ "$actual" != "$expected" ]; then printf '%s\n' 'AppImage hash differs from the qualified release; launch refused.' >&2; exit 2; fi
if [ "$#" -eq 0 ]; then set -- gui; fi
# Portable state is separate from the runtime. Existing files are preserved.
PATHFOLD_PORTABLE_DATA=${PATHFOLD_PORTABLE_DATA:-$bundle_root/user-data}
mkdir -p -- "$PATHFOLD_PORTABLE_DATA"
PATHFOLD_PORTABLE_DATA=$(CDPATH= cd -- "$PATHFOLD_PORTABLE_DATA" && pwd)
if [ ! -w "$PATHFOLD_PORTABLE_DATA" ]; then printf '%s\n' 'Choose a writable PATHFOLD_PORTABLE_DATA directory.' >&2; exit 2; fi
export PATHFOLD_PORTABLE_DATA
# This route was qualified. It does not depend on mounted FUSE availability.
export APPIMAGE_EXTRACT_AND_RUN=1
exec "$appimage" --appimage-extract-and-run "$@"
