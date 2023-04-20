source ~/.startup/utils.sh
source ~/.startup/helpers.sh

installNewSystem stow;

cd ~;
mkdir tools;
mkdir src;

cd src;
git clone https://github.com/3ZsForInsomnia/dotfiles;
source ./dotfiles/bash/.bashrc;
unstowAll;

installNeovim;
installEspanso;
installJsTs;
installTmux;
installZsh;
installNewsboat;
installCtags;
installRust;
### Rust must be installed first, to install Stylua
installLua;
