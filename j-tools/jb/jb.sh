#!/bin/bash

# Requires python3 installed

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
BOOKMARKS_FILE="$SCRIPT_DIR/bookmarks.txt"

cat "$BOOKMARKS_FILE" \
 | fzf --layout reverse --with-nth 2.. --preview='echo {1}' \
 | awk '{print $1}' \
 | xargs python3 -m webbrowser

