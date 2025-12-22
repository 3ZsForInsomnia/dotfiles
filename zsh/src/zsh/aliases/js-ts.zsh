function detectNpmOrYarn() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    if [[ -f $(groot)"/yarn.lock" ]]; then
      echo "yarn"
    else
      echo "npm"
    fi
  else
    echo "npm"
  fi
}

function getLockfile() {
  manager=$(detectNpmOrYarn)

  if [[ $manager == "npm" ]]; then
    echo "package-lock.json"
  else
    echo "yarn.lock"
  fi
}

function cleanDeps() {
  lockfile=$(getLockfile)

  goToGroot
  rm -rf node_modules
  rm -f "$lockfile"
}

function installDeps() {
  manager=$(detectNpmOrYarn)

  if [[ $manager == "npm" ]]; then
    npm install --no-fund
  else
    yarn install
  fi
}

alias cleanAndInstall="cleanDeps; installDeps;"

alias version='cat package.json J ".version"'

alias n="npm"
alias y="yarn"

function nr() {
  manager=$(detectNpmOrYarn)
  command="$manager run $1"

  eval "$command"
}

function nrd() {
  manager=$(detectNpmOrYarn)
  command="$manager run dev"

  eval "$command"
}

function nrb() {
  manager=$(detectNpmOrYarn)
  command="$manager run build"

  eval "$command"
}

function nrt() {
  manager=$(detectNpmOrYarn)
  command="$manager run test"

  eval "$command"
}

function nrl() {
  manager=$(detectNpmOrYarn)
  command="$manager run lint"

  eval "$command"
}

function nrsto() {
  manager=$(detectNpmOrYarn)
  command="$manager run storybook"

  eval "$command"
}

function ni() {
  manager=$(detectNpmOrYarn)
  if [[ $manager == "npm" ]]; then
    command="$manager install $1"
  else
    command="$manager $1"
  fi

  eval "$command"
}

function niglobal() {
  manager=$(detectNpmOrYarn)
  if [[ $manager == "npm" ]]; then
    command="$manager install -g $1"
  else
    command="$manager global add $1"
  fi

  eval "$command"
}
alias ng='niglobal'

function nin() {
  manager=$(detectNpmOrYarn)

  if [[ $manager == "npm" ]]; then
    command="$manager install --save"
  else
    command="$manager add"
  fi

  eval "$command"
}

function nins() {
  manager=$(detectNpmOrYarn)

  if [[ $manager == "npm" ]]; then
    command="$manager install --save-dev"
  else
    command="$manager add --dev"
  fi

  eval "$command"
}

alias nxs="nx serve"
alias nxt="nx test"
alias nxb="nx build"
alias nxg="nx generate"
alias nxl="nx lint"

alias http='npx http-server'

alias shadadd='npx shadcn@latest add '

alias jup='jest --updateSnapshot'

# watch $1=Folder $2=Extension
function watch() {
  eval 'nodemon --exec "forego start" --watch $1 -e $2'
}
