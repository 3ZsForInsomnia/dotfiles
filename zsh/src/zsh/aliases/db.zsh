# First arg: Port
# Second arg: User
function get_pg_password() {
  PGHOST="localhost"
  PGPORT="$1"
  PGUSER="$2"

  PASSWORD=$(awk -F: -v host="$PGHOST" -v port="$PGPORT" -v user="$PGUSER" \
    '$1 == host && $2 == port && ($3 == "*" || $3 == "") && $4 == user {print $5}' "$PGPASSFILE")

  if [ -z "$PASSWORD" ]; then
    echo "Password not found in $PGPASSFILE for the given connection details."
    return 1
  fi

  echo "$PASSWORD"
}

# First arg: port number
# Second arg: database name
# Third arg: username
# Fourth arg: output directory
# Assumes password is in "$PGPASSFILE"
function create_db_schema_diagram() {
  if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Usage: create_db_schema_diagram <port> <database_name> <username> <output_directory -- optional>"

    if [ -z "$1" ]; then
      echo "Missing port"
    fi
    if [ -z "$2" ]; then
      echo "Missing database name"
    fi
    if [ -z "$3" ]; then
      echo "Missing username"
    fi
  fi

  port=$1
  database_name=$2
  username=$3
  output_directory=$(default "$4" .)

  PASSWORD=$(get_pg_password "$port" "$username")

  java \
    -jar "$SCHEMASPY_LOCATION" \
    -t pgsql -all \
    -dp "$POSTGRES_JDBC_LOCATION" \
    -db "$database_name" \
    -host localhost \
    -port "$port" \
    -u "$username" -p "$PASSWORD" \
    -o "$output_directory"
}

function viewDB() {
  local user=$1
  local port=$2
  local name=$3
  local host=$4

  cmd="psql -U $user -h $host -p $port -d $name"
  # echo "Running: $cmd"
  eval "$cmd"
}

# pg_resolve_conn <port> <user> [db]
# Prints "<database> <username>" for the matching pgpass line. <user> is matched
# as a substring of the pgpass username. If several lines match, the database
# whose name ends in "postgres" wins.
function pg_resolve_conn() {
  emulate -L zsh
  local port="$1" user="$2" db_filter="${3:-}"

  if [[ -z "$port" || -z "$user" ]]; then
    print -u2 "pg_resolve_conn: usage: pg_resolve_conn <port> <user> [db]"
    return 2
  fi
  if [[ ! -r "$PGPASSFILE" ]]; then
    print -u2 "pg_resolve_conn: cannot read PGPASSFILE ($PGPASSFILE)"
    return 1
  fi

  local -a matches
  matches=("${(@f)$(awk -F: -v p="$port" -v u="$user" -v dbf="$db_filter" '
    $1 == "localhost" && $2 == p && index($4, u) && (dbf == "" || $3 == dbf) { print $3 ":" $4 }
  ' "$PGPASSFILE")}")
  matches=("${(@)matches:#}")

  if (( ${#matches} == 0 )); then
    print -u2 "pg_resolve_conn: no pgpass entry for port=$port user~='$user'${db_filter:+ db=$db_filter}"
    return 1
  fi

  local chosen="${matches[1]}" m
  if (( ${#matches} > 1 )); then
    for m in $matches; do
      if [[ "${m%%:*}" == *postgres ]]; then
        chosen="$m"
        break
      fi
    done
  fi

  print -r -- "${chosen%%:*} ${chosen#*:}"
}

# pg_conn_url <port> <user> [db] [host]
function pg_conn_url() {
  emulate -L zsh
  local port="$1" user="$2" db_filter="${3:-}" host="${4:-localhost}"
  local conn
  conn="$(pg_resolve_conn "$port" "$user" "$db_filter")" || return 1
  print -r -- "postgresql://${conn##* }@${host}:${port}/${conn%% *}"
}

# pgDumpTo <port> <db> <user> <out-file> [pg_dump args...]
function pgDumpTo() {
  emulate -L zsh
  local port="$1" db="$2" user="$3" out="$4"
  shift 4
  if [[ -z "$port" || -z "$db" || -z "$user" || -z "$out" ]]; then
    print -u2 "pgDumpTo: usage: pgDumpTo <port> <db> <user> <out-file> [pg_dump args...]"
    return 2
  fi
  print -u2 "pgDumpTo: dumping $db@localhost:$port (user $user) -> $out"
  pg_dump -h localhost -p "$port" -U "$user" -d "$db" "$@" >"$out"
}

# Restore a .sql file into a postgres database (password from pgpass).
#   $1 port  $2 db  $3 user  $4 input file
function pgLoadFrom() {
  emulate -L zsh
  local port="$1" db="$2" user="$3" in="$4"
  if [[ -z "$port" || -z "$db" || -z "$user" || -z "$in" ]]; then
    print -u2 "pgLoadFrom: usage: pgLoadFrom <port> <db> <user> <in-file>"
    return 2
  fi
  if [[ ! -r "$in" ]]; then
    print -u2 "pgLoadFrom: cannot read input file: $in"
    return 1
  fi
  print -u2 "pgLoadFrom: loading $in -> $db@localhost:$port (user $user)"
  psql -h localhost -p "$port" -U "$user" -d "$db" -f "$in"
}

# Dump / restore a sqlite database file.
function sqliteDumpTo() {
  emulate -L zsh
  local db="$1" out="$2"
  if [[ -z "$db" || -z "$out" ]]; then
    print -u2 "sqliteDumpTo: usage: sqliteDumpTo <db-file> <out-file>"
    return 2
  fi
  sqlite3 "$db" .dump >"$out"
}

function sqliteLoadFrom() {
  emulate -L zsh
  local db="$1" in="$2"
  if [[ -z "$db" || -z "$in" ]]; then
    print -u2 "sqliteLoadFrom: usage: sqliteLoadFrom <db-file> <in-file>"
    return 2
  fi
  sqlite3 "$db" <"$in"
}

# Port for a work environment, from the W_DB_PORT_BY_ENV map (variables.zsh).
function get_port_for_env() {
  emulate -L zsh
  print -r -- "${W_DB_PORT_BY_ENV[$1]}"
}

#################################
# Generating database diagrams  #
#################################

# First arg: environment (dev|qat|uat)
function generateDbDiagramFor() {
  if [[ -z "$1" ]]; then
    echo "Usage: generateDbDiagramFor <env>"
    return 1
  fi

  port=$(get_port_for_env "$1")
  today=$(date +"%Y-%m-%d")

  dir="$W_PATH/diagrams/$1/$today"
  mkdir -p "$dir"

  create_db_schema_diagram "$port" postgres adminTerraform "$dir"
}
