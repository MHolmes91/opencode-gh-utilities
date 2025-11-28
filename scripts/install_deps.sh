#!/usr/bin/env bash
set -euo pipefail

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

APT_UPDATED=0
PACMAN_SYNCED=0

install_with_apt() {
  if [ $APT_UPDATED -eq 0 ]; then
    sudo apt-get update
    APT_UPDATED=1
  fi
  sudo apt-get install -y "$1"
}

install_with_pacman() {
  if [ $PACMAN_SYNCED -eq 0 ]; then
    sudo pacman -Sy
    PACMAN_SYNCED=1
  fi
  sudo pacman -S --noconfirm --needed "$1"
}

install_pkg() {
  local package="$1"
  if command_exists "$package"; then
    echo "Found ${package}"
    return
  fi

  if command_exists brew; then
    echo "Installing ${package} with Homebrew"
    brew install "$package"
    return
  fi

  if command_exists apt-get; then
    echo "Installing ${package} with apt-get"
    install_with_apt "$package"
    return
  fi

  if command_exists pacman; then
    echo "Installing ${package} with pacman"
    install_with_pacman "$package"
    return
  fi

  echo "Unable to install ${package}. Please install it manually (requires brew, apt-get, or pacman)." >&2
  exit 1
}

for bin in gh jq; do
  install_pkg "$bin"
  if ! command_exists "$bin"; then
    echo "${bin} is still missing after attempted installation." >&2
    exit 1
  fi
done

if ! command_exists npm; then
  echo "npm is required. Please install Node.js and npm, then rerun make deps." >&2
  exit 1
fi

ensure_npm_tool() {
  local binary="$1"
  local package="$2"
  if command_exists "$binary"; then
    echo "Found ${binary}"
    return
  fi

  if npm list -g "$package" >/dev/null 2>&1; then
    echo "Found ${package} globally but ${binary} not in PATH; continuing"
  else
    echo "Installing ${package} with npm"
    npm install -g "$package"
  fi

  if command_exists "$binary"; then
    echo "${binary} installed"
  else
    echo "${binary} still missing; ensure npm globals are on PATH." >&2
    exit 1
  fi
}

ensure_npm_tool opencode opencode-ai
ensure_npm_tool openskills openskills
echo "Dependencies installed."

