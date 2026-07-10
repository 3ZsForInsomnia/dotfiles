# TODO: no per-schema ACLs enforced yet — any user can read across schemas.
# Add a search_path / -n <schema> dimension once real per-schema access lands.

# _viewDb <env> <schema>
function _viewDb() {
  emulate -L zsh
  local env="$1" schema="$2"

  if [[ -z "$env" ]]; then
    print -u2 "_viewDb: usage: _viewDb <env> <schema>"
    return 2
  fi

  if [[ "$env" == "local" ]]; then
    viewDB postgres "${W_DB_PORTS[local]}" "$W_DB_NAME" "$W_DB_HOST"
    return
  fi

  local port="${W_DB_PORTS[$env]}"
  if [[ -z "$port" ]]; then
    print -u2 "_viewDb: unknown env '$env' (known: ${(ok)W_DB_PORTS})"
    return 1
  fi

  local user="${W_DB_USERS[$schema]}"
  if [[ -z "$user" ]]; then
    print -u2 "_viewDb: unknown schema '$schema' (known: ${(ok)W_DB_USERS})"
    return 1
  fi

  local conn
  if ! conn="$(pg_resolve_conn "$port" "$user" "${W_DB_NAMES[$env]:-}")"; then
    print -u2 "_viewDb: no pgpass match for $env/$schema (port=$port, user~='$user'). Add it to \$PGPASSFILE."
    return 1
  fi

  local db="${conn%% *}" resolved="${conn##* }"
  print -u2 "→ $env/$schema: connecting as $resolved to $db on :$port"
  viewDB "$resolved" "$port" "$db" "$W_DB_HOST"
}
