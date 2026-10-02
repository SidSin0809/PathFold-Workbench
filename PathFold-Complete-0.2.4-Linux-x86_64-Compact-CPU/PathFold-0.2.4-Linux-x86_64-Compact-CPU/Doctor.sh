#!/bin/sh
set -eu
bundle_root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
# PathFold.sh verifies all original AppImage bytes before this startup probe.
exec "$bundle_root/PathFold.sh" diagnostics --multiprocessing-probe "$@"
