#!/usr/bin/env bash
set -e

# Bootstrap
source "$(dirname "$0")/../_bootstrap.sh"
source "$(dirname "$0")/static/write_with_backup.sh"

FISH_BIN="$(command -v fish || true)"
if [ -z "$FISH_BIN" ]; then
  echo "fish is not installed. Run apt_prepare first."
  exit 1
fi

if ! grep -qFx "$FISH_BIN" /etc/shells; then
  echo "$FISH_BIN" | sudo tee -a /etc/shells >/dev/null
fi

# Detect WSL
if grep -qi microsoft /proc/version; then
  IS_WSL=true
else
  IS_WSL=false
fi

# Set fish as default shell
if [ "$IS_WSL" = true ]; then
  if ! grep -q "exec fish" ~/.bashrc; then
    echo 'exec fish' >> ~/.bashrc
  fi
else
  if [ "$(basename "$SHELL")" != "fish" ]; then
    chsh -s "$FISH_BIN"
  fi
fi

mkdir -p "$HOME/.config/fish"

ALIASES_FILE="$HOME/.config/fish/aliases.fish"
if [ ! -f "$ALIASES_FILE" ] || ! grep -qF "$(head -n 1 ./scripts/static/.fish_aliases)" "$ALIASES_FILE"; then
  cat ./scripts/static/.fish_aliases >> "$ALIASES_FILE"
fi

FISH_CONF_DIR="$HOME/.config/fish/conf.d"
mkdir -p "$FISH_CONF_DIR"

write_with_backup "$FISH_CONF_DIR/30-aliases.fish" <<'EOF'
if test -f ~/.config/fish/aliases.fish
  source ~/.config/fish/aliases.fish
end
EOF
