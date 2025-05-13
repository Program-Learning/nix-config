link_file_in_source_dir_to_target_dir_rec() {
  local src_dir="$1"
  local dest_dir="$2"

  if [[ ! -d "$src_dir" ]]; then
    echo "Error: src_dir<$src_dir> does not exist" >&2
    return 1
  fi

  mkdir -p "$dest_dir" || {
    echo "Error: failed to mkdir dest_dir<$dest_dir>" >&2
    return 2
  }

  local original_dotglob=$(shopt -p dotglob)
  shopt -s dotglob || echo "Warn: shopt not supported"

  for item in "$src_dir"/*; do
    [[ -e "$item" ]] || continue

    local base_name=$(basename "$item")
    local target_path="$dest_dir/$base_name"

    if [[ -d "$item" ]]; then
      mkdir -p "$target_path"
      link_file_in_source_dir_to_target_dir_rec "$item" "$target_path"
    else
      ln -sfn "$item" "$target_path" || {
        echo "Warn: failed to create link $target_path" >&2
      }
    fi
  done

  $original_dotglob || echo "Warn: shopt not supported"
}
