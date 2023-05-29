powershellSymlink() {
  New-Item -ItemType SymbolicLink -Path "$1" -Target "$2"
}
