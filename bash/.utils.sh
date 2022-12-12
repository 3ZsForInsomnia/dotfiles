alias j='jump'
alias b='bookmark'
alias shm='showmarks'

alias o='open'
alias makeExecutable='chmod +x'
alias seeMemory='free -m'
alias seeCpu='htop'

backup() {
  eval 'cp $1 $1.bak'
}

getPort() {
  eval 'lsof -nP -iTCP:$1 G LISTEN'
}
killPort() {
  str=$(getPort $1 A '{print $2}')
  $(kill $str)
}
killProcess() {
  process=$(ps P C -d " " -f 1)
  kill -9 $process
}
alias kp='killProcess'

alias lineCount='wc -l'
# $1=file extension
lineCountForFolder() {
  if [ -z $1 ]
  then
    find . -name '*.*' | xargs wc -l
  else
    find . -name "*.${1}" | xargs wc -l
  fi
}

runThenReturn() {
  pwd=$(pwd)
  eval $1
  cd $pwd
}
