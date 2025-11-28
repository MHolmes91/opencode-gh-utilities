#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
COMMAND_SRC="$ROOT_DIR/commands"
if [ -n "${DIR:-}" ]; then
  TARGET_ROOT="${DIR%/}/.opencode"
elif [ -n "${OPENCODE_TARGET:-}" ]; then
  TARGET_ROOT="$OPENCODE_TARGET"
else
  TARGET_ROOT="$HOME/.config/opencode"
fi
COMMAND_DEST="$TARGET_ROOT/command"
AGENT_DEST="$TARGET_ROOT/agent"
MANIFEST_FILE="$TARGET_ROOT/.gh_ops_manifest"
AGENT_FILE="$ROOT_DIR/agents/gh-ops.md"
SUBAGENTS=("$ROOT_DIR/agents/subagents/gh-workflow-controller.md" "$ROOT_DIR/agents/subagents/gh-pr-issue-controller.md")

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

remove_previous_install() {
  local manifest="$1"
  [ -f "$manifest" ] || return 0
  while IFS= read -r relpath; do
    [ -n "$relpath" ] || continue
    rm -f "$TARGET_ROOT/$relpath"
  done <"$manifest"
}

remove_previous_install "$MANIFEST_FILE"

mkdir -p "$COMMAND_DEST" "$AGENT_DEST"
NEW_MANIFEST=()

for file in "$COMMAND_SRC"/*.md; do
  [ -e "$file" ] || continue
  base="$(basename "$file")"
  install_path="$COMMAND_DEST/$base"
  cp "$file" "$install_path"
  NEW_MANIFEST+=("command/$base")
done

echo "Installed commands into $COMMAND_DEST."

for file in "$ROOT_DIR"/agents/*.md; do
  [ -e "$file" ] || continue
  base="$(basename "$file")"
  install_path="$AGENT_DEST/$base"
  cp "$file" "$install_path"
  NEW_MANIFEST+=("agent/$base")
done

for file in "$ROOT_DIR"/agents/subagents/*.md; do
  [ -e "$file" ] || continue
  base="$(basename "$file")"
  install_path="$AGENT_DEST/$base"
  cp "$file" "$install_path"
  NEW_MANIFEST+=("agent/$base")
done

echo "Installed agents into $AGENT_DEST."

if command_exists openskills; then
  echo "Syncing OpenSkills catalog"
  openskills install "$ROOT_DIR" --universal -y >/dev/null || true
  openskills sync >/dev/null || true
else
  echo "openskills CLI not found; install it with npm i -g openskills."
fi

echo "Initialization complete."
