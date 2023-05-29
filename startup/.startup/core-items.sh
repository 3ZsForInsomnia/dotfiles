installZsh() {
  if [ $INSTALLING_ON == 'linux'] then
    zshLocation = command -v zsh;
    sudo echo $zshLocation >> /etc/shells
    sudo chsh -s $(which zsh) $USER
  fi
  # lets see if this is already handled via the git submodule setup
  # git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k;
}

installXcode() {
  if [ $INSTALLING_ON == 'mac'] then
    xcode-select --install;
  fi
}

retrieveNotes() {
  cd ~/code
  git clone git@github.com:3ZsForInsomnia/notes.git;
  cd ~
}

installAllCoreItems() {
  installZsh;
  installXcode;
  retrieveNotes;
}
