#!/usr/bin/env bash
set -e

# Bootstrap
source "$(dirname "$0")/../_bootstrap.sh"
source "$(dirname "$0")/static/write_with_backup.sh"

MISE_BIN="$HOME/.local/bin/mise"

if [ ! -x "$MISE_BIN" ]; then
  curl https://mise.run | sh
fi

MARKER='MISE_PATH'
BLOCK=$(cat <<'EOF'
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"
EOF
)
add_once_to_file "$MARKER" "$BLOCK"

PROFILE_MARKER='PATH_ADDITIONS'
PROFILE_BLOCK=$(cat <<'EOF'
if [ -f "$HOME/.path_additions" ]; then
  . "$HOME/.path_additions"
fi
EOF
)
add_once_to_file "$PROFILE_MARKER" "$PROFILE_BLOCK" "$HOME/.profile"

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
