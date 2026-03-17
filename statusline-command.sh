#!/usr/bin/env bash

input=$(cat)

# Extract fields from JSON input
project_dir=$(echo "$input" | jq -r '.workspace.project_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
effort=$(echo "$input" | jq -r '.effortLevel // empty')
if [ -z "$effort" ]; then
  effort=$(jq -r '.effortLevel // empty' ~/.claude/settings.json 2>/dev/null)
fi

# Project folder name (basename only)
folder=$(basename "$project_dir")

# Git branch (skip optional locks to avoid blocking)
git_branch=$(git -C "$project_dir" --no-optional-locks branch --show-current 2>/dev/null)

# ANSI color codes
BLUE="\033[34m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
PINK="\033[38;5;213m"
GRAY="\033[38;5;245m"
ORANGE="\033[38;5;208m"
RESET="\033[0m"

# Context window usage with color thresholds
if [ -n "$used_pct" ]; then
  used_int=$(printf "%.0f" "$used_pct")
  if [ "$used_int" -ge 90 ]; then
    context_str=$(printf "${RED}${used_int}%% ctx${RESET}")
  elif [ "$used_int" -ge 70 ]; then
    context_str=$(printf "${YELLOW}${used_int}%% ctx${RESET}")
  else
    context_str=$(printf "${GREEN}${used_int}%% ctx${RESET}")
  fi
else
  context_str=$(printf "${GREEN}0%% ctx${RESET}")
fi

# Model color: haiku=pink, sonnet=gray, opus=orange
model_lower=$(echo "$model" | tr '[:upper:]' '[:lower:]')
if echo "$model_lower" | grep -q "haiku"; then
  model_color="$GREEN"
elif echo "$model_lower" | grep -q "sonnet"; then
  model_color="$ORANGE"
elif echo "$model_lower" | grep -q "opus"; then
  model_color="$RED"
else
  model_color="$RESET"
fi

# Effort color: low=green, medium=orange, high=red
case "$effort" in
  low)    effort_color="$GREEN" ;;
  medium) effort_color="$ORANGE" ;;
  high)   effort_color="$RED" ;;
  *)      effort_color="$RESET" ;;
esac

# Build status line parts
parts=""

if [ -n "$folder" ]; then
  parts="📁 $(printf "${BLUE}${folder}${RESET}")"
fi

if [ -n "$git_branch" ]; then
  parts="$parts [$git_branch]"
fi

if [ -n "$model" ]; then
  model_str=$(printf "${model_color}${model}${RESET}")
  if [ -n "$effort" ]; then
    effort_str=$(printf "${effort_color}${effort}${RESET}")
    parts="$parts | $model_str ($effort_str)"
  else
    parts="$parts | $model_str"
  fi
fi

parts="$parts | $context_str"

printf "%b" "$parts"
