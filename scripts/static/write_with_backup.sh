#!/usr/bin/env bash

write_with_backup() {
  local target="$1"
  local tmp
  tmp="$(mktemp)"
  cat >"$tmp"

  if [ -f "$target" ] && ! cmp -s "$target" "$tmp"; then
    local bak="$target.bak"
    if [ ! -f "$bak" ]; then
      cp "$target" "$bak"
    fi
  fi

  mkdir -p "$(dirname "$target")"
  mv "$tmp" "$target"
}
