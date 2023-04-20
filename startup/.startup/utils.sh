installForMac() {
  brew install $@;
}

installForLinux() {
  sudo apt install $@;
}

installForWin() {
  echo 'Windows is not yet supported';
}

isMacLinuxOrWin() {
  system='mac';
  if [ "$(uname)" == "Darwin" ]; then
    system='mac';
  elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    system='linux';
  elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    system='win';
  fi
  return $system;
}

installNewSystem() {
  system=$(isMacLinuxOrWin);
  if [ $system == "mac" ]; then
    installForMac $@;
  elif [ $system == "linux" ]; then
    installForLinux $@;
  elif [ $system == "win" ]; then
    installForWin $@;
  fi
}

powershellSymlink() {
  New-Item -ItemType SymbolicLink -Path "$1" -Target "$2"
}
