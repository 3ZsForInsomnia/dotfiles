isMacLinuxOrWin() {
  unameExists=$(command -v uname)
  if [ -z "$unameExists" ]; then
    echo "windows"
  fi
  output=$(uname -s)
  if [ "$output" == "Darwin" ]; then
    echo "mac"
  elif [ "$(expr substr "$output" 1 5)" == "Linux" ]; then
    echo "linux"
  fi
}

system=$(isMacLinuxOrWin)
export INSTALLING_ON=$system

if [ "$system" == 'mac' ]; then
  brew update && brew upgrade
  if ! [ -x "$(command -v git)" ]; then
    brew install git
  fi
  if ! [ -x "$(command -v wget)" ]; then
    brew install wget
  fi
  if ! [ -x "$(command -v curl)" ]; then
    brew install curl
  fi
  brew install stow
elif [ "$system" == 'linux' ]; then
  sudo apt update && sudo apt upgrade
  if ! [ -x "$(command -v git)" ]; then
    sudo apt install git
  fi
  if ! [ -x "$(command -v wget)" ]; then
    sudo apt install wget
  fi
  if ! [ -x "$(command -v curl)" ]; then
    sudo apt install curl
  fi
  sudo apt install stow
fi

cd "$HOME"
mkdir code
cd code
git clone --recurse-submodules https://github.com/3ZsForInsomnia/dotfiles
source ./dotfiles/bash/.bashrc
unstowAll
cd "$HOME"

source "$HOME/.startup/utils.sh"
source "$HOME/.startup/helpers.sh"
source "$HOME/.startup/core-items.sh"
source "$HOME/.startup/unique-items.sh"
source "$HOME/.startup/package-managers.sh"
source "$HOME/.startup/save-managed-packages.sh"

installAllCoreItems

# Setup RSA key
# Log into lastpass CLI
git config --global core.excludesfile "$HOME/.gitignore_global"
git config --global user.name "Zachary Levine"
git config --global user.email "Zach@ZJLevine.dev"
git config --global init.templatedir '$HOME/.git_template'

# These must be run manually as they depend on git/dotfiles/lastpass
installRest() {
  installApps
  installUniqueItems
  installAllPackagersAndLibraries
}

# Log into: Chrome, Lastpass in Chrome, Tidal
# Swap escape and caps lock
# Setup Obsidian vault plus sync

# Neovim - packer
# delete "$HOME"/.local/share/nvim/site/pack/packer/start/packer.nvim and rerun PackerSync
# nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
#  - helpful thing to open nvim and auto run PackerSync
#    so I can then delete the packer.nvim file and rerun
