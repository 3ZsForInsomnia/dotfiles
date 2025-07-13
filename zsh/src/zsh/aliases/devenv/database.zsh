function pullDb() {
  pg_dump -h "$W_DB_HOST" -U "$W_DB_BP_USERNAME" -p "${W_DB_PORTS[2]}" -n broker -n meta -d "$W_DB_NAME" >"$W_PATH"/dbs/main_db.sql
}

function loadDb() {
  psql -U $W_DB_NAME -h $W_DB_HOST -f $W_PATH/dbs/main_db.sql
}

function refreshDb() {
  pullDb
  loadDb
}

function pullQuotesDb() {
  pg_dump -h $W_DB_HOST -U $W_DB_CT_USERNAME -p ${W_DB_PORTS[2]} -n carriertracker -d $W_DB_NAME >$W_PATH/dbs/quotes_db.sql
}

function loadQuotesDb() {
  psql -U $W_DB_NAME -h $W_DB_HOST -f $W_PATH/dbs/quotes_db.sql
}

function refreshQuotesDb() {
  pullQuotesDb
  loadQuotesDb
}

function _viewAppDb() {
  local service=$1
  local env=$2

  # Select username based on app
  local username
  case "$service" in
  bp) username="$W_DB_BP_USERNAME" ;;
  ct) username="$W_DB_CT_USERNAME" ;;
  *)
    echo "Invalid app: $service (must be 'bp' or 'ct')" >&2
    return 1
    ;;
  esac
  if [[ "$env" == "local" ]]; then
    username="postgres"
  fi

  # Select port index based on environment
  local port_index
  case "$env" in
  local) port_index=1 ;;
  dev) port_index=2 ;;
  qat) port_index=3 ;;
  uat) port_index=4 ;;
  prod) port_index=5 ;;
  *)
    echo "Invalid environment: $env (must be 'local', 'dev', 'qat', 'uat', or 'prod')" >&2
    return 1
    ;;
  esac

  viewDB "$username" "${W_DB_PORTS[$port_index]}" "$W_DB_NAME" "$W_DB_HOST"
}

# Single function to access any database
function viewDb() {
  local service=${1:-bp}
  local env=${2:-dev}

  _viewAppDb "$service" "$env"
}

alias viewLocalBpDb='_viewAppDb bp local'
alias viewDevBpDb='_viewAppDb bp dev'
alias viewQatBpDb='_viewAppDb bp qat'
alias viewUatBpDb='_viewAppDb bp uat'
alias viewProdBpDb='_viewAppDb bp prod'

alias viewDevCtDb='_viewAppDb ct dev'
alias viewQatCtDb='_viewAppDb ct qat'
alias viewUatCtDb='_viewAppDb ct uat'
alias viewProdCtDb='_viewAppDb ct prod'
