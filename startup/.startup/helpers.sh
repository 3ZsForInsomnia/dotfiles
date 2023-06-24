writeLog() {
  logLocation = "/var/log/startup.log"
  if [ "$INSTALLING_ON" == "windows" ]; then
    logLocation = "$HOME\\AppData\\Local\\Startup\\startup.log"
  fi

  echo $1 >> $logLocation
}

# $1 package manager
# $2 specific package
logBeforeInstalling() {
  writeLog "$1: Installing $2\n"
}

# $1 package manager
# $2 specific package
logAfterInstalling() {
  writeLog "$1: Finished installing $2\n"
}

# $1 package manager command
# $2 file with list of items to be installed
installItemsForManager() {
  while read in; do
    logBeforeInstalling $1 $in
    $($1 $in) | writeLog
    logAfterInstalling $1 $in
  done < $2
}

# Based on: https://help.mobilock.in/article/6nxqky35rv-install-dmg-files-using-scripts
# $1 app name
# $2 url to download from
installApp() {
  if [ "$INSTALLING_ON" == "mac" ]; then
    installAppForMac $1 $2;
  elif [ "$INSTALLING_ON" == "linux" ]; then
    installAppForLinux $1 $2;
  fi
}

installAppForLinux() {
  writeLog "App $1: Starting installer for DEB from $2";
  http_code="$(curl -w '%{http_code}\n' -o "$1" $2)"

  if [ ! "$http_code" = 200 ]; then
    writeLog "App $1: Failed to download file. Failed with error: $http_code";
    exit 1;
  fi

  writeLog "App $1: Starting installation"

  cd ~/Downloads/
  sudo dpkg -i $1

  writeLog "App $1: Successfully installed"
}

installAppForMac() {
  writeLog "App $1: Starting installer for DMG from $2";
  http_code="$(curl -w '%{http_code}\n' -o "$1" $2)"

  if [ ! "$http_code" = 200 ]; then
    writeLog "App $1: Failed to download file. Failed with error: $http_code";
    exit 1;
  fi

  writeLog "App $1: Starting installation"

  VOLUME=`hdiutil attach -nobrowse "$2" | grep Volumes | sed 's/.*\/Volumes\//\/Volumes\//'`
  writeLog "App $1: Volume found : $VOLUME"
  cd "$VOLUME"
  \\cp -rf *.app /Applications
  INSTALLED=$?
  cd ..
  hdiutil detach "$VOLUME"

  cd ~/Downloads/

  if [ $INSTALLED -ne 0 ]; then
    writeLog "App $1: Failed to install"
    rm "$1"
    exit 1
  fi

  writeLog "App $1: Successfully installed"
}

installViaBrewCaskOrSnap() {
  if [ "$INSTALLING_ON" == 'linux' ]; then
    sudo snap install $1;
  elif [ "$INSTALLING_ON" == 'mac' ]; then
    brew install --cask $1;
  fi;
  
  cd ~;
}
