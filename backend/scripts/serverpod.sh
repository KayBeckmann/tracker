#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
SERVERPOD_HOME_DIR="$REPO_ROOT/.serverpod-home"

mkdir -p "$SERVERPOD_HOME_DIR"

HOME="$SERVERPOD_HOME_DIR" ~/.pub-cache/bin/serverpod "$@"
