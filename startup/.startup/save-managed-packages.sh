alias brewPack='cd ~/.startup/package-lists/; rmrf Brewfile; brew bundle dump'
alias npmPack='cd ~/.startup/package-lists/; rmrf npm-requirements.txt; npm ls -g T -n +2 C -d " " -f 2 > npm-requirements.txt'
alias pip2Pack='cd ~/.startup/package-lists/; rmrf pip2-requirements.txt; pip2 freeze > pip2-requirements.txt'
alias pip3Pack='cd ~/.startup/package-lists/; rmrf pip3-requirements.txt; pip3 freeze > pip3-requirements.txt'
alias rubyPack='cd ~/.startup/package-lists/; rmrf ruby-requirements.txt; gem list > ruby-requirements.txt'
alias aptgetPack='cd ~/.startup/package-lists/; rmrf apt-get.txt; apt list --installed T -n +2 | awk -F/ "{print \$1}" > apt-get.txt'
alias cargoPack='cd ~/.startup/package-lists/; rmrf cargo.txt; ls ~/.cargo/bin/ C -d " " -f 15 > cargo.txt'
alias luaPack='cd ~/.startup/package-lists/; rmrf luarocks.txt; luarocks list --porcelain C -f 1 > luarocks.txt'

brewOrApt() {
  if ! command -v brew &> /dev/null
  then
    aptgetPack
  else
    brewPack
  fi
}

alias savePackages='(
cd ~/.startup/package-lists/;
npmPack;
pip2Pack;
pip3Pack;
rubyPack;
cargoPack;
luaPack;
brewOrApt;
cd ~;
)'
