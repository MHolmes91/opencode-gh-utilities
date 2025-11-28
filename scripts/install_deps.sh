#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

install_pkg() {
  local package="$1"
  if command_exists brew; then
    echo "Installing ${package} with Homebrew"
    brew install "$package"
  elif command_exists apt-get; then
    echo "Installing ${package} with apt-get"
    sudo apt-get update
    sudo apt-get install -y "$package"
  else
    echo "Please install ${package} manually and re-run make deps" >&2
    return 1
  fi
}

for bin in gh jq; do
  if command_exists "$bin"; then
    echo "Found ${bin}"
  else
    install_pkg "$bin"
  fi
done

if ! command_exists python3; then
  echo "python3 is required. Please install Python 3.10+ and re-run." >&2
  exit 1
fi

python3 -m pip install --upgrade pip
python3 -m pip install --upgrade -r "$ROOT_DIR/requirements.txt"

echo "Dependencies installed."
