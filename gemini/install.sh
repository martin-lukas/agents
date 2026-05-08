#!/usr/bin/env bash
set -euo pipefail

# This script sets up symlinks for Gemini configuration.
# It assumes it is run from the root of the agents repository.

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
GEMINI_DIR="$HOME/.gemini"

mkdir -p "$GEMINI_DIR"

link() {
  local name="$1"
  local src="$REPO_DIR/gemini/$name"
  local dst="$GEMINI_DIR/$name"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "Backing up existing $dst → $dst.bak"
    mv "$dst" "$dst.bak"
  fi
  ln -sfn "$src" "$dst"
  echo "Linked $dst → $src"
}

link "GEMINI.md"
link "settings.json"
link "skills"
link "templates"
# link "commands" # Add if we create a commands directory
