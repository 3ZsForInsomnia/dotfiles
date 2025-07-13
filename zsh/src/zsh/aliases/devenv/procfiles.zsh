function bpfebe() {
  if [[ -z "$1" ]]; then
    echo "Usage: bpfebe <environment>"
    return 1
  fi

  useLocalBpAuth "$1"
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
