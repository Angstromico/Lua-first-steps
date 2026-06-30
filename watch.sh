#!/usr/bin/env bash

# Default parameters
ENTRY="${1:-main.lua}"
LUA="${2:-lua}"

# Move to the script's directory
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASE_DIR" || exit 1

if [ ! -f "$ENTRY" ]; then
  echo "Error: Entry file '$ENTRY' not found in $BASE_DIR" >&2
  exit 1
fi

echo "========================================="
echo "Starting Lua Watcher (Bash)"
echo "Watching .lua files in $BASE_DIR"
echo "Entry file: $ENTRY"
echo "Press Ctrl+C to stop."
echo "========================================="

# Initial run
echo "[$(date +%H:%M:%S)] Initial execution:"
$LUA "$ENTRY"
echo "Lua exit code: $?"
echo "-----------------------------------------"

# Function to get current state (paths and modification times of all .lua files)
get_state() {
  if stat --version 2>/dev/null | grep -q "GNU"; then
    # GNU/Linux, Git Bash, WSL
    find . -name "*.lua" -type f -exec stat -c "%Y %p" {} + 2>/dev/null | sort
  else
    # macOS / BSD fallback
    find . -name "*.lua" -type f -exec stat -f "%m %N" {} + 2>/dev/null | sort
  fi
}

# Store the initial state
last_state=$(get_state)

# Polling loop
while true; do
  sleep 0.5
  current_state=$(get_state)
  
  if [ "$current_state" != "$last_state" ]; then
    echo ""
    echo "[$(date +%H:%M:%S)] Change detected in .lua files"
    echo "Running: $LUA $ENTRY"
    $LUA "$ENTRY"
    echo "Lua exit code: $?"
    echo "-----------------------------------------"
    last_state="$current_state"
  fi
done
