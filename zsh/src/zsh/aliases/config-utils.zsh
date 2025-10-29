# Generic configuration file utilities
# These functions can be used to update any config file type

function update_json_property() {
  local file="$1"
  local json_path="$2"
  local value="$3"

  if [[ ! -f "$file" ]]; then
    echo "Error: File not found: $file"
    return 1
  fi

  local tmp_file="$file.tmp"
  jq "$json_path = \"$value\"" "$file" >"$tmp_file"
  mv "$tmp_file" "$file"
}

function update_yaml_property() {
  local file="$1"
  local yaml_path="$2"
  local value="$3"

  if [[ ! -f "$file" ]]; then
    echo "Error: File not found: $file"
    return 1
  fi

  local tmp_file="$file.tmp"
  yq eval "$yaml_path = \"$value\"" "$file" >"$tmp_file"
  mv "$tmp_file" "$file"
}

function update_env_var() {
  local file="$1"
  local key="$2"
  local value="$3"

  if [[ ! -f "$file" ]]; then
    echo "Error: File not found: $file"
    return 1
  fi

  printf "\n%s=%s" "$key" "$value" >>"$file"
}

function comment_out_env_vars() {
  local file="$1"
  shift
  local vars_to_comment=("$@")

  if [[ ! -f "$file" ]]; then
    echo "Error: File not found: $file"
    return 1
  fi

  local temp_file="$file.tmp"
  touch "$temp_file"

  while IFS= read -r line || [[ -n "$line" ]]; do
    local should_comment=false

    for var in "${vars_to_comment[@]}"; do
      if [[ "$line" =~ ^[[:space:]]*${var}[[:space:]]*= && ! "$line" =~ ^[[:space:]]*# ]]; then
        should_comment=true
        break
      fi
    done

    if [[ "$should_comment" == true ]]; then
      echo "# $line" >>"$temp_file"
    else
      echo "$line" >>"$temp_file"
    fi
  done <"$file"

  mv "$temp_file" "$file"
}
