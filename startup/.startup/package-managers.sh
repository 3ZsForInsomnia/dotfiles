installApps() {
  while read in; do
    name = $($in C -f 1)
    url = $($in C -f 2)
    logBeforeInstalling "Apps: $name" $url
    installApp name url
    logAfterInstalling "Apps: $name" $url
  done < ~/.startup/package-lists/unmanaged-apps.txt
}

installBrew() {
  installItemsForManager "brew install " ~/.startup/package-lists/Brewfile
}

installAptGet() {
  installItemsForManager "sudo apt -y install " ~/.startup/package-lists/apt-get.txt
}

installNpm() {
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
  nvm install node;

  installItemsForManager "npm install -g " ~/.startup/package-lists/npm-requirements.txt
}

installLua() {
  if [ "$INSTALLING_ON" == 'linux' ]; then
    sudo apt install build-essential libreadline-dev unzip;
  elif [ "$INSTALLING_ON" == 'mac' ]; then
    brew install luarocks;
  fi
    
  curl -R -O http://www.lua.org/ftp/lua-5.3.5.tar.gz;
  tar -zxf lua-5.3.5.tar.gz;
  cd lua-5.3.5;
  make linux test;
  sudo make install;

  wget https://luarocks.org/releases/luarocks-3.8.0.tar.gz;
  tar zxpf luarocks-3.8.0.tar.gz;
  cd luarocks-3.8.0;

  ./configure --lua-version=5.1 --versioned-rocks-dir;
  make build;
  sudo make install;

  ./configure --lua-version=5.3 --versioned-rocks-dir
  make build
  sudo make install

  installItemsForManager "luarocks install " ~/.startup/package-lists/luarocks.txt

  cd ~
}

installCargo() {
  curl https://sh.rustup.rs -sSf | sh -s -- -y

  installItemsForManager "cargo install " ~/.startup/package-lists/cargo.txt
}

installPip2() {
  if ! [ -x "$(command -v python2)" ]; then
    if [ "$INSTALLING_ON" == 'linux' ]; then
      sudo apt install python2-minimal
      curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
      sudo python2 get-pip.py
      rm -f get-pip.py
    elif [ "$INSTALLING_ON" == 'mac' ]; then
      brew install python@2
    fi
  fi

  installItemsForManager "pip2 install " ~/.startup/package-lists/pip2-requirements.txt
}

installPip3() {
  # All systems I use should come with python3 by default
  if ! [ -x "$(command -v pip3)" ]; then
    sudo apt install python3-pip;
  fi

  installItemsForManager "pip3 install " ~/.startup/package-lists/pip3-requirements.txt
}

installGems() {
  installItemsForManager "gem install " ~/.startup/package-lists/ruby-requirements.txt
}

installAllPackagersAndLibraries() {
  if [ "$INSTALLING_ON" == 'linux' ]; then
    installAptGet;
  elif [ "$INSTALLING_ON" == 'mac' ]; then
    installBrew;
  fi

  installGems;
  installCargo;
  installNpm;
  installPip2;
  installPip3;
  # Lua must come after Rust/Cargo due to Stylua
  installLua;
}
