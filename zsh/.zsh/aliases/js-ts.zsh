detectNpmOrYarn() {
  if [[ -f $(groot)"/package-lock.json" ]]; then
    echo "npm"
  else
    echo "yarn"
  fi
}

getLockfile() {
  manager=$(detectNpmOrYarn);

  if [[ $manager == "npm" ]]; then
    echo "package-lock.json"
  else
    echo "yarn.lock"
  fi
}

cleanDeps() {
  lockfile=$(getLockfile);
  
  goToGroot;
  rm -rf node_modules;
  rm -f "$lockfile";
}

installDeps() {
  manager=$(detectNpmOrYarn);

  if [[ $manager == "npm" ]]; then
    npm install;
  else
    yarn install;
  fi
}

alias cleanAndInstall="cleanDeps; installDeps;"

alias version='cat package.json J ".version"'

alias n="npm "
alias y="yarn "

nr() {
  manager=$(detectNpmOrYarn);
  command="$manager run $1"

  eval "$command"
}

nrd() {
  manager=$(detectNpmOrYarn);
  command="$manager run dev"

  eval "$command"
}

nrb() {
  manager=$(detectNpmOrYarn);
  command="$manager run build"

  eval "$command"
}

nrt() {
  manager=$(detectNpmOrYarn);
  command="$manager run test"

  eval "$command"
}

nrl() {
  manager=$(detectNpmOrYarn);
  command="$manager run lint"

  eval "$command"
}

nrsto() {
  manager=$(detectNpmOrYarn);
  command="$manager run storybook"

  eval "$command"
}

ni() {
  manager=$(detectNpmOrYarn);
  if [[ $manager == "npm" ]]; then
    command="$manager install"
  else
    command="$manager"
  fi

  eval "$command"
}

nin() {
  manager=$(detectNpmOrYarn);

  if [[ $manager == "npm" ]]; then
    command="$manager install --save"
  else
    command="$manager add"
  fi

  eval "$command"
}

nins() {
  manager=$(detectNpmOrYarn);

  if [[ $manager == "npm" ]]; then
    command="$manager install --save-dev"
  else
    command="$manager add --dev"
  fi

  eval "$command"
}

alias nxs="nx serve "

alias http='npx http-server'

alias shadadd='npx shadcn@latest add '

alias jup='jest --updateSnapshot'

# watch $1=Folder $2=Extension
watch() {
  eval 'nodemon --exec "forego start" --watch $1 -e $2'
}
