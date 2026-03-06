#!/usr/bin/env bash
set -e
set -x  # Add this line for debugging

COMPLETIONS_DIR="$HOME/.config/fish/completions"
mkdir -p "$COMPLETIONS_DIR"

write_placeholder() {
  local file="$1"
  local tool="$2"
  cat >"$file" <<EOF
# Auto-generated placeholder.
# '$tool' is not available yet, so fish completion could not be generated.
# Re-run bootstrap (or this script) after installing '$tool'.
EOF
}

if docker version >/dev/null 2>&1; then
  docker completion fish >"$COMPLETIONS_DIR/docker.fish"
else
  write_placeholder "$COMPLETIONS_DIR/docker.fish" "docker"
fi

if command -v mise >/dev/null 2>&1; then
  mise completion fish >"$COMPLETIONS_DIR/mise.fish"
elif [ -x "$HOME/.local/bin/mise" ]; then
  "$HOME/.local/bin/mise" completion fish >"$COMPLETIONS_DIR/mise.fish"
else
  write_placeholder "$COMPLETIONS_DIR/mise.fish" "mise"
fi

if command -v starship >/dev/null 2>&1; then
  starship completions fish >"$COMPLETIONS_DIR/starship.fish"
else
  write_placeholder "$COMPLETIONS_DIR/starship.fish" "starship"
fi

if command -v task >/dev/null 2>&1; then
  task --completion fish >"$COMPLETIONS_DIR/task.fish"
else
  write_placeholder "$COMPLETIONS_DIR/task.fish" "task"
fi
