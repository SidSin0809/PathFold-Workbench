#!/bin/sh
# Explicit CPU CLI entrypoint. No arguments run diagnostics, never model inference.
set -eu
bundle_root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cpu_root=$("$bundle_root/Setup-CPU.sh")
if [ "$#" -eq 0 ]; then set -- diagnostics --multiprocessing-probe; fi
exec "$cpu_root/Start-Engine.sh" "$@"
