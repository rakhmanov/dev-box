#!/usr/bin/env bash
set -e

# Bootstrap
source "$(dirname "$0")/../_bootstrap.sh"
source "$(dirname "$0")/static/write_with_backup.sh"

if [ ! -d "$HOME/.krew" ]; then
  # Install krew
  (
    set -x; cd "$(mktemp -d)" &&
    OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
    KREW="krew-${OS}_${ARCH}" &&
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
    tar zxvf "${KREW}.tar.gz" &&
    ./"${KREW}" install krew
  )
fi

MARKER='KREW_ROOT'
BLOCK=$(cat <<'EOF'
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
EOF
)
add_once_to_file "$MARKER" "$BLOCK" # Add to path file

FISH_CONF_DIR="$HOME/.config/fish/conf.d"
mkdir -p "$FISH_CONF_DIR"
write_with_backup "$FISH_CONF_DIR/40-krew-path.fish" <<'EOF'
if not contains $HOME/.krew/bin $PATH
  fish_add_path -g $HOME/.krew/bin
end
EOF

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

if ! command -v kubectl >/dev/null 2>&1; then
  echo "kubectl is not installed; skipping krew plugins."
  exit 0
fi

if ! kubectl krew version >/dev/null 2>&1; then
  echo "kubectl krew is not available; skipping plugin installs."
  exit 0
fi

install_krew_plugin_if_missing() {
  local plugin="$1"
  if ! kubectl krew list 2>/dev/null | rg -qx "$plugin"; then
    kubectl krew install "$plugin"
  fi
}

install_krew_plugin_if_missing ns
install_krew_plugin_if_missing ctx
install_krew_plugin_if_missing node-shell
