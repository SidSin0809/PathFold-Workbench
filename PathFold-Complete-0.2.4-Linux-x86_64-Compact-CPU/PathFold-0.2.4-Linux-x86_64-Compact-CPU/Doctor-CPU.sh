#!/bin/sh
set -eu
bundle_root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cpu_root=$("$bundle_root/Setup-CPU.sh")
exec "$cpu_root/Start-Engine.sh" diagnostics --multiprocessing-probe --verify-package "$cpu_root"
