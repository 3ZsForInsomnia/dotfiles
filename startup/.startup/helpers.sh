installNewsboat() {
  if [ isMacLinuxOrWin != 'win' ] then
  installNewSystem newsboat;
  cd ~/.newsboat;
  newsboat -i=./rss-feeds.opml
  fi;
}

installZsh() {
  installNewSystem zsh zsh-syntax-highlighting zsh-completions;
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k;
}

installTmux() {
  installNewSystem tmux;
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  source ~/.tmux.conf
}

installNeovim() {
  installNewSystem fzf ripgrep;
  system=isMacLinuxOrWin;
  if [ $system == 'mac'] then
    installNewSystem --HEAD neovim
  elif [ $system == 'linux' ] then
    sudo add-apt-repository ppa:neovim-ppa/unstable
    sudo apt-get update
    installNewSystem neovim
  fi
}

installEspanso() {
  cd ~/tools;
  system=isMacLinuxOrWin;
  if [ $system == 'mac' ] then

  elif [ $system == 'linux' ] then
    wget https://github.com/federico-terzi/espanso/releases/download/v2.1.8/espanso-debian-x11-amd64.deb
    sudo apt install ./espanso-debian-x11-amd64.deb
  elif [ $system == 'win' ] then
    # Requires running powershell in admin, mostly here for documentation
    url="C:\\Users\\comra\\code\\dotfiles\\espanso\\Library\\Application Support\\espanso\\"
    powershellSymlink "$urlconfig\\default.yml" "default.yml"
    powershellSymlink "$urlmatch\\base.yml" "base.yml"
  fi;
}

installJsTs() {
  installNewSystem node npm;
  npm install -g typescript eslint_d @fsouza/prettierd
}

installLua() {
  luarocks install --server=https://luarocks.org/dev luaformatter
  cargo install stylua --features lua51
}

installCtags() {
  cd ~/tools;
  git clone https://github.com/universal-ctags/ctags.git
  cd ctags
  ./autogen.sh 
  ./configure
  make
  sudo make install
}

installRust() {
  curl https://sh.rustup.rs -sSf | sh -s -- -y
}
