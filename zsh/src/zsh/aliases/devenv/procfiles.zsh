function bpfebe() {
  if [[ -z "$1" ]]; then
    echo "Usage: bpfebe <backend env> <db env?>"
    echo "Can be \"dev\" or \"qat\", or \"local.qat\""
    return 1
  fi

  if [[ -n "$2" ]]; then
    echo "Using BE env: $1, DB env: $2"
    BE_ENV="$1"
    DB_ENV="$2"
  else
    echo "Using BE and DB env: $1"
    BE_ENV="$1"
    DB_ENV="$1"
  fi

  echo "PROC_BE=$BE_ENV\nPROC_DB=$DB_ENV" >./procfiles/.env

  echo "Make sure to set your auth setup properly!\n\n"
  forego start -f ./procfiles/local_fe_be -e ./procfiles/.env
}
function ctbpfebe() {
  if [[ -z "$1" ]]; then
    echo "Usage: bpfebe <environment>"
    return 1
  fi

  useLocalBpAuth "$1"
  forego start -f ./procfiles/local_fe_be_ct -e ./procfiles/.env
}

autoload -Uz _dev_env_completion
compdef _dev_env_completion bpfebe ctbpfebe
