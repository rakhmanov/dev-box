#!/usr/bin/env bash
set -e

# Bootstrap
source "$(dirname "$0")/../_bootstrap.sh"
source "$(dirname "$0")/static/write_with_backup.sh"

MISE_BIN="$HOME/.local/bin/mise"

if [ ! -x "$MISE_BIN" ]; then
  curl https://mise.run | sh
fi

FISH_CONF_DIR="$HOME/.config/fish/conf.d"
mkdir -p "$FISH_CONF_DIR"

write_with_backup "$FISH_CONF_DIR/00-path.fish" <<'EOF'
fish_add_path -g ~/.local/bin
EOF

write_with_backup "$FISH_CONF_DIR/10-mise.fish" <<'EOF'
# mise activation (interactive only)
if status is-interactive
  if command -q mise
    mise activate fish | source
  end
end
EOF
