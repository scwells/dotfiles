#!/bin/bash

# Requires these tools to be installed on system:
#
# ripgrep
# bat
# fzf

PATTERN="$1"

# Load in folders to include in search
FOLDERS=()
while IFS= read -r line || [[ -n "$line" ]]; do
  FOLDERS+=("$line")
done < "$(dirname "$0")/jg_folders.env"

# Load in folders to ignore in search results
IGNORE=()
while IFS= read -r line || [[ -n "$line" ]]; do
  IGNORE+=("$line")
done < "$(dirname "$0")/jg_ignore.env"
IGNORE=$(IFS=,; echo "${IGNORE[*]}")

# Ripgrep search
RG_CMD="rg --glob '!{$IGNORE}' --color=always -n '$PATTERN' ${FOLDERS[@]}"

# Previewer
BAT_CMD='
  bat --style=header,grid \
      --color=always \
      --highlight-line $(echo {} | cut -d: -f2) $(echo {} | cut -d: -f1)
'

SELECTED=$(eval $RG_CMD | fzf --ansi --preview "$BAT_CMD" --preview-window=right:50%:wrap --reverse)

if [ -n "$SELECTED" ]; then
  FILE_PATH=$(echo "$SELECTED" | cut -d: -f1)
  LINE_NUMBER=$(echo "$SELECTED" | cut -d: -f2)
 
  REPO_DIR=$(git -C "$(dirname "$FILE_PATH")" rev-parse --show-toplevel 2>/dev/null)

  if [ -n "$REPO_DIR" ]; then
     nvim --cmd "cd $REPO_DIR" +$LINE_NUMBER "$FILE_PATH" -c "NvimTreeToggle" -c "normal! $LINE_NUMBER"
  else
     nvim +$LINE_NUMBER "$FILE_PATH"
  fi
fi

