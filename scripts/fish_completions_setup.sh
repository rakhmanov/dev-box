#!/usr/bin/env bash
set -e

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

resolve_command() {
  local tool="$1"

  if command -v "$tool" >/dev/null 2>&1; then
    command -v "$tool"
    return 0
  fi

  if [ -x "$HOME/.local/bin/mise" ] && "$HOME/.local/bin/mise" which "$tool" >/dev/null 2>&1; then
    "$HOME/.local/bin/mise" which "$tool"
    return 0
  fi

  return 1
}

if docker_bin="$(resolve_command docker)"; then
  "$docker_bin" completion fish >"$COMPLETIONS_DIR/docker.fish"
else
  write_placeholder "$COMPLETIONS_DIR/docker.fish" "docker"
fi

if mise_bin="$(resolve_command mise)"; then
  "$mise_bin" completion fish >"$COMPLETIONS_DIR/mise.fish"
elif [ -x "$HOME/.local/bin/mise" ]; then
  "$HOME/.local/bin/mise" completion fish >"$COMPLETIONS_DIR/mise.fish"
else
  write_placeholder "$COMPLETIONS_DIR/mise.fish" "mise"
fi

if starship_bin="$(resolve_command starship)"; then
  "$starship_bin" completions fish >"$COMPLETIONS_DIR/starship.fish"
else
  write_placeholder "$COMPLETIONS_DIR/starship.fish" "starship"
fi

if task_bin="$(resolve_command task)"; then
  "$task_bin" --completion fish >"$COMPLETIONS_DIR/task.fish"
else
  write_placeholder "$COMPLETIONS_DIR/task.fish" "task"
fi
