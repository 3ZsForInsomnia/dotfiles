alias gob="go build"

alias got="go test -v"
alias gotc="go test -v -cover"

function gocov() {
  local out_dir="${GIT_ROOT}/coverage"
  mkdir -p "${out_dir}"
  go test -v -coverprofile="${out_dir}/coverage.out" ./...
  go tool cover -html="${out_dir}/coverage.out" -o "${out_dir}/coverage.html"
}

function gocov_open() {
  local out_dir="${GIT_ROOT}/coverage"
  if [[ -f "${out_dir}/coverage.html" ]]; then
    open "${out_dir}/coverage.html"
  else
    echo "Coverage report not found. Please run 'gocov' first."
  fi
}
