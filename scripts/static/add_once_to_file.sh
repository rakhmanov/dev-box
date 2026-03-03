# Usage: add_once_to_file "grep_query" "block_to_add" [file]
add_once_to_file() {
  local marker="$1"
  local block="$2"
  local file="${3:-$HOME/.path_additions}"

  local start_marker="# >>> $marker"
  local end_marker="# <<< $marker"

  mkdir -p "$(dirname "$file")"
  touch "$file"

  # If marker is not found, append block with markers
  if ! grep -Fq "$start_marker" "$file"; then
    {
      echo "$start_marker"
      echo "$block"
      echo "$end_marker"
    } >> "$file"
  fi
}
