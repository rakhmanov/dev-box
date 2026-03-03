#!/usr/bin/env bash
set -e

# Bootstrap
source "$(dirname "$0")/../_bootstrap.sh"
source "$(dirname "$0")/static/write_with_backup.sh"

FISH_CONF_DIR="$HOME/.config/fish/conf.d"
mkdir -p "$FISH_CONF_DIR"

write_with_backup "$FISH_CONF_DIR/20-starship.fish" <<'EOF'
if status is-interactive
  if command -q starship
    starship init fish | source
  end
end
EOF
