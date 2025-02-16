# First arg: Port
# Second arg: User
get_pg_password() {
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
create_db_schema_diagram() {
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

  java                            \
    -jar "$SCHEMASPY_LOCATION"    \
    -t pgsql -all                 \
    -dp "$POSTGRES_JDBC_LOCATION" \
    -db "$database_name"          \
    -host localhost               \
    -port "$port"                 \
    -u "$username" -p "$PASSWORD" \
    -o "$output_directory" 
}
