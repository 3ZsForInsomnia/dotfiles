installNeovim() {
  if [ "$INSTALLING_ON" == 'mac'] then
    installNewSystem --HEAD neovim
  elif [ "$INSTALLING_ON" == 'linux' ] then
    sudo add-apt-repository ppa:neovim-ppa/unstable
    sudo apt-get update
    installNewSystem neovim
  fi
}

installEspanso() {
  cd ~/tools;

  if [ "$INSTALLING_ON" == 'mac' ] then
    # Actual download handled by Brew
    # Current folder setup is correct for Mac
  elif [ "$INSTALLING_ON" == 'linux' ] then
    wget https://github.com/federico-terzi/espanso/releases/download/v2.1.8/espanso-debian-x11-amd64.deb
    sudo apt install ./espanso-debian-x11-amd64.deb
  elif [ $"INSTALLING_ON" == 'win' ] then
    # Requires running powershell in admin, mostly here for documentation
    url="C:\\Users\\comra\\code\\dotfiles\\espanso\\Library\\Application Support\\espanso\\"
    powershellSymlink "$urlconfig\\default.yml" "default.yml"
    powershellSymlink "$urlmatch\\base.yml" "base.yml"
  fi;

  cd ~;
}

installGhCli() {
  # This is already installed automatically by brew, for Mac
  if [ "$INSTALLING_ON" == 'linux' ]; then
    type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y
  fi
}

installTmuxPlugins() {
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  source ~/.tmux.conf
}

installCtags() {
  cd ~/tools;
  git clone https://github.com/universal-ctags/ctags.git
  cd ctags
  ./autogen.sh 
  ./configure
  make
  sudo make install

  cd ~;
}

installNewsboat() {
  if [ "$INSTALLING_ON" == 'mac' ] then
    brew install newsboat;
  elif [ "$INSTALLING_ON" == 'linux' ] then
    sudo apt install newsboat;
  fi;

  cd ~/.newsboat;
  newsboat -i=./rss-feeds.opml;
  cd ~;
}

installCMake() {
  if [ "$INSTALLING_ON" == 'linux' ] then
    sudo apt install cmake g++ make;
  elif [ "$INSTALLING_ON" == 'mac' ] then
    brew install cmake;
  fi;
}

installPostman() {
  if [ "$INSTALLING_ON" == 'linux' ] then
    curl -o- "https://dl-cli.pstmn.io/install/linux64.sh" | sh
  elif [ "$INSTALLING_ON" == 'mac' ] then
    curl -o- "https://dl-cli.pstmn.io/install/osx_64.sh" | sh
  fi;
}

installDiscord() {
  installViaBrewCaskOrSnap "discord"
}

installSlack() {
  installViaBrewCaskOrSnap "slack"
}

installWhatsapp() {
  if [ "$INSTALLING_ON" == 'linux' ] then
    sudo snap install whatsapp-for-linux;
  elif [ "$INSTALLING_ON" == 'mac' ] then
    brew install --cask whatsapp;
  fi;
}

installWezterm() {
  if [ "$INSTALLING_ON" == 'linux' ] then
    sudo snap install whatsapp-for-linux;
  elif [ "$INSTALLING_ON" == 'mac' ] then
    brew tap homebrew/cask-versions
    brew install --cask wezterm-nightly

    ## Upgrade command:
    # brew upgrade --cask wezterm-nightly --no-quarantine --greedy-latest
  fi;
}

# This is handled simply as a dmg for Mac
installObsidianIfLinux() {
  if [ "$INSTALLING_ON" == 'linux' ] then
    wget https://github.com/obsidianmd/obsidian-releases/releases/download/v1.3.4/Obsidian-1.3.4.AppImage -O ~/obsidian.AppImage;
    wget https://forum.obsidian.md/uploads/default/original/2X/6/663886873dba65def747edf8ebf752a0a8d09db0.jpeg -O ~/obsidian.jpeg
    chmod +x obsidian.AppImage;
    cp ~/.startup/obsidianAppImageEntry ~/Obsidian.desktop
    cp ~/Obsidian.desktop /usr/share/applications/
  fi
}

installUniqueItems() {
  installNeovim;
  installEspanso;
  installTmuxPlugins;
  installCtags;
  installNewsboat;
  installCMake;
  installPostman;
  installDiscord;
  installSlack;
  installWhatsapp;
  installWezterm;
  installObsidianIfLinux;
}
