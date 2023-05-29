isMacLinuxOrWin() {
  unameExists = $(command -v uname)
  if [ -z "$unameExists" ]; then
    return "windows"
  fi
  output = $(uname -s)
  if [ "$output" == "Darwin" ]; then
    return "mac";
  elif [ "$(expr substr $output 1 5)" == "Linux" ]; then
    return "linux";
  fi
}

system=$(isMacLinuxOrWin);
export INSTALLING_ON=$system

if [ "$system" == 'mac'] then
  brew update && brew upgrade;
  if ! [ -x "$(command -v git)" ]; then
    brew install git;
  fi
  if ! [ -x "$(command -v wget)" ]; then
    brew install wget;
  fi
  if ! [ -x "$(command -v curl)" ]; then
    brew install curl;
  fi
  brew install stow;
elif [ "$system" == 'linux' ] then
  sudo apt update && sudo apt upgrade;
  if ! [ -x "$(command -v git)" ]; then
    sudo apt install git;
  fi
  if ! [ -x "$(command -v wget)" ]; then
    sudo apt install wget;
  fi
  if ! [ -x "$(command -v curl)" ]; then
    sudo apt install curl;
  fi
  sudo apt install stow;
fi

cd ~;
mkdir code;
cd code;
git clone https://github.com/3ZsForInsomnia/dotfiles;
source ./dotfiles/bash/.bashrc;
unstowAll;
cd ~;

source ~/.startup/utils.sh
source ~/.startup/helpers.sh
source ~/.startup/core-items.sh
source ~/.startup/unique-items.sh
source ~/.startup/package-managers.sh
source ~/.startup/save-managed-packages.sh

installAllCoreItems;

# Setup RSA key
# Log into lastpass CLI

# These must be run manually as they depend on git/dotfiles/lastpass
installRest() {
  installApps;
  installUniqueItems;
  installAllPackagersAndLibraries;
}

# Log into: Chrome, Lastpass in Chrome, Tidal
# Swap escape and caps lock
# Setup Obsidian vault plus sync

# Neovim - packer
# delete "$HOME"/.local/share/nvim/site/pack/packer/start/packer.nvim and rerun PackerSync
# nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
#  - helpful thing to open nvim and auto run PackerSync
#    so I can then delete the packer.nvim file and rerun
