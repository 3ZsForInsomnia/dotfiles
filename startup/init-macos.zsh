############################
# Variables                #
############################

paths_to_check=("$HOME/.cache" "$HOME/.local/state" "$HOME/.local/bin" "$HOME/.local/share" "$HOME/.config" "$HOME/.local/bin" "$HOME/src" "$HOME/Downloads/slack" "$HOME/Downloads/postman" "$HOME/Pictures/screenshots" "$HOME/Documents/test data" "$HOME/Documents/sync" "$HOME/.local/state/psql" "$HOME/.cache/zsh" "$HOME/.local/state/zsh" "$HOME/.local/state/python" "$HOME/.local/share/psql" "$HOME/.local/state/less" "$HOME/.local/share/bookmarks" "$HOME/src/work" "$HOME/.local/share/npm" "$HOME/.local/share/pyenv")

brew_taps="espanso/espanso ankitpokhrel/jira-cli"
brew_packages=("eza" "fzf" "fd" "ripgrep" "go" "delve" "stow" "powerlevel10k" "luacheck" "bat" "docker" "kubernetes-cli" "lazydocker" "gh" "jira" "imagemagick" "ffmpeg" "yazi" "sevenzip" "poppler" "zoxide" "glow" "fx" "node" "luarocks" "ninja" "cmake" "gettext" "curl" "pyenv" "newsboat" "espanso" "tokei" "graphviz" "git-delta" "tmux" "overmind" "pngpaste" "hyperfine" "pandoc" "speedtest-cli" "zoxide" "helm" "yq" "ollama")
brew_packages_with_cask=("witch" "obsidian" "google-chrome" "slack" "postman" "font-fira-code-nerd-font" "font-symbols-only-nerd-font" "lastpass-cli" "maccy")
# copyq is replaced by maccy
# rectangle's functionality is now part of MacOS

npm_packages_to_install=("eslint_d" "@fsouza/prettierd" "jsonlint" "nx@latest" "commitizen" "markdownlint" "mcp-hub@latest" "@bytebase/dbhub" "nx-mcp@latest" "task-master-ai" "@johnlindquist/worktree" "anki-mcp-http")

# All Python packages to install in global venv
python_packages_to_install=("yamllint" "shell-gpt" "vectorcode" "basic-memory")

stowed_folder_locations=("$HOME/.config/bat" "$HOME/.config/ctags" "$HOME/.config/espanso" "$HOME/.config/git" "$HOME/.config/luacheck" "$HOME/.config/nvim" "$HOME/.local/bin/notes" "$HOME/.config/newsboat" "$HOME/.local/bin/8ball" "$HOME/.config/silicon" "$HOME/.config/ripgrep" "$HOME/.config/wezterm" "$HOME/.config/yazi" "$HOME/.zsh")

installed_applications=("postman" "obsidian" "google-chrome" "wezterm" "espanso" "slack")

dotfiles_to_unstow=(
  ctags
  espanso
  git
  neovim
  notes
  personal-scripts
  rss
  wezterm
  zsh
)

PERSONAL_EMAIL="comrade.topanga@gmail.com"
WORK_EMAIL="zachary.levine@centrobenefits.com"

NPM_PACKAGES="$HOME/.local/share/npm"
BOOKMARKS_FILE="$HOME/.local/share/bookmarks/.bookmarks"
TIMEZONE="America/New_York"

ssh_keys_to_create=("PERSONAL")

############################
# Helper scripts           #
############################

function array_diff {
  local -a array_1=("$@")
  local -a array_2
  local -a array_3=()

  # Split input parameters into array_1 and array_2
  array_1=("${(@P)1}")  # Fetch the first array by name
  array_2=("${(@P)2}")  # Fetch the second array by name

  for element in "${array_1[@]}"; do
    if (( ${array_2[(I)$element]} == 0 )); then
      array_3+=("$element")
    fi
  done

  echo "${array_3[@]}"
}

echo_each_element() {
  # Iterate over the array elements and print each with indentation
  for element in "$@"; do
    printf "        %s\n" "$element"
  done
}

echo_on_verbose() {
  if [[ -n "$SHOULD_ECHO_ON_VERBOSE" ]]; then
    echo "$1"
  fi
}

echo_on_success() {
  if [[ -n "$SHOULD_ECHO_ON_SUCCESS" ]]; then
    echo "$1"
  fi
}

curl_this_gist() {
  curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/gists/06976a1e2ae3f7f73814ec187e308d9a | jq -r '.files["init-macos.zsh"].content' > "$HOME/init-macos.zsh" && source "$HOME/init-macos.zsh"
}

check_command_is_installed() {
  if command -v "$1" >/dev/null 2>&1; then
    return 0;
  else
    return 1;
  fi
}

# Used after Brew install is complete to check that all packages installed.
# It will put all packages that failed to install into $BREW_FAILED_PACKAGES when done
check_brew_installed() {
  local packages=("$@")
  BREW_FAILED_PACKAGES=()

  for package in "${packages[@]}"; do            # Iterate over each package name
    # Check if the package is installed
    if ! brew list | grep -q "${package}"; then
      BREW_FAILED_PACKAGES+=("$package")         # Add missing packages to the array
    fi
  done
}

# Used after npm install is complete to check that all packages installed.
# It will put all packages that failed to install into $NPM_FAILED_PACKAGES when done
check_npm_installed() {
  local packages=("$@")
  NPM_FAILED_PACKAGES=()  # Initialize the variable to hold missing packages

  for package in "${packages[@]}"; do
    local clean_pkg="${package/@latest/}"
    if ! npm list -g --depth=0 "$clean_pkg" >/dev/null 2>&1; then
      NPM_FAILED_PACKAGES+=("$clean_pkg")
    fi
  done
}

create_ssh_keys() {
  local ssh_keys_to_create=("$@")              # Capture all arguments as an array
  local key_name email first_name last_name file_name lower_case_key

  # Iterate over the array of key identifiers
  for key_name in "${ssh_keys_to_create[@]}"; do
    # Dynamically access the email associated with the key name
    email_var_name="${key_name}_EMAIL"
    email="${(P)email_var_name}"

    # Check if the email is set
    if [[ -z "$email" ]]; then
      echo "No email found for key $key_name. Skipping..."
      continue
    fi

    # Extract first and second parts of the email
    first_name="${email%%.*}"
    last_name="${email#*.}"
    last_name="${last_name%@*}"

    # Convert key name to lowercase
    lower_case_key="${key_name:l}"

    # Construct the desired file name
    file_name="id_rsa_${lower_case_key}_${first_name}_${last_name}"

    # Generate the SSH key pair
    ssh-keygen -t rsa -b 4096 -C "$email" -f "$file_name" -N ""
  done
}

alias unstow='stow --target=$HOME'
function unstowAll() {
  cd "$XDG_CODE_HOME/dotfiles/"

  for element in "${dotfiles_to_unstow[@]}"; do
    echo "Unstowing: $element..."
    unstow "$element"
  done
}

download_gist() {
  local gist_id=$1
  local destination_path=$2
  local file_name=$3

  # Check if gh command is available
  if ! command -v gh &> /dev/null; then
    echo "Error: gh CLI is not installed. Please install it from https://cli.github.com/."
    return 1
  fi

  # Validate that both arguments are provided
  if [[ -z "$gist_id" || -z "$destination_path" ]]; then
    echo "Usage: download_gist <gist_id> <destination_path>"
    return 1
  fi

  # Fetch the gist contents using the gh CLI
  if ! gist_content=$(gh gist view "$gist_id" --files | awk '/: /{print $3}'); then
    echo "Error: Failed to fetch gist. Please ensure the gist ID is correct."
    return 1
  fi

  # Save the contents of the gist to the specified destination path
  if echo "$gist_content" > "$destination_path"; then
    echo "Gist $gist_id successfully saved to $destination_path"
    return 0
  else
    echo "Error: Failed to write the gist contents to $destination_path"
    return 1
  fi
}

clone_gist_folder() {
  local gist_id=$1
  local destination_path=$2
  local folder_name=$3

  # Check if gh command is available
  if ! command -v gh &>/dev/null; then
    echo "Error: gh CLI is not installed. Please install it from https://cli.github.com/."
    return 1
  fi

  # Validate that all arguments are provided
  if [[ -z "$gist_id" || -z "$destination_path" || -z "$folder_name" ]]; then
    echo "Usage: clone_gist_folder <gist_id> <destination_path> <folder_name>"
    return 1
  fi

  # Create destination directory if it doesn't exist
  mkdir -p "$destination_path"

  # Create a temporary directory for cloning
  local temp_dir=$(mktemp -d)

  # Clone the gist to temp directory
  if ! gh gist clone "$gist_id" "$temp_dir/gist_clone"; then
    echo "Error: Failed to clone gist $gist_id"
    rm -rf "$temp_dir"
    return 1
  fi

  # Copy all files from the cloned gist to the destination
  cp -r "$temp_dir/gist_clone/"* "$destination_path/"

  # Clean up temp directory
  rm -rf "$temp_dir"

  echo "Gist $gist_id successfully cloned to $destination_path"
  return 0
}

handle_all_gists() {
  local file_path="$1"
  while IFS=' ' read -r arg1 arg2 arg3; do
    # Skip empty lines and comments
    [[ -z "$arg1" || "$arg1" =~ ^# ]] && continue
    
    # Check if arg3 has a file extension (contains a dot) or ends with /
    if [[ "$arg3" == *"."* ]]; then
      # Single file gist
      download_gist "$arg1" "$arg2" "$arg3"
    else
      # Multi-file gist (folder)
      clone_gist_folder "$arg1" "$arg2" "$arg3"
    fi
  done < "$file_path"
}

check_if_file_or_folder_exists() {
  if [ -e "$1" ]; then
    return 0;
  else
    return 1;
  fi
}

find_non_existent_paths() {
  export NON_EXISTENT_PATHS=()
  local array=("$@")
  for dir_path in "${array[@]}"; do
    # Check if the path does not exist
    if [[ ! -e "$dir_path" ]]; then
      # Append non-existent path to the NON_EXISTENT_PATHS array
      NON_EXISTENT_PATHS+=("$dir_path")
    fi
  done
}

check_if_applications_installed() {
  local applications=("$@")
  export APPLICATIONS_NOT_INSTALLED=()

  for application in "${applications[@]}"; do
    application_lower="${(L)application}"
    if ! ls /Applications | grep -qi "^.*${application_lower}.*$"; then
      APPLICATIONS_NOT_INSTALLED+=("$application_lower")
    fi
  done
}

############################
# Step 0 functions         #
############################

show_help() {
  echo "Hi there! This script automates much of the setup of a new MacOS computer."
  echo "The default expected usage is to source this file and run \`run_all_steps\`."
  echo "This will run all 7 automated setup steps and the healthcheck, as well as tell you what manual steps must be taken."
  echo ""
  echo "Alternatively, you can run \`run_specific_steps\` to run only the steps you want."
  echo "For an example, \`run_specific_steps 1 2 3\` will run only steps 1, 2, and 3."
  echo ""
  echo "You can also run any step individually since you should have sourced this file!"
  echo ""
  echo "Lastly, the healthcheck does not affect anything, but will tell you what failed during setup, or what is currently missing/not set."
  echo ""
  echo "If you aren't sure what to do, run \`show_steps\` to see what each step does!"
}

run_all_steps() {
  show_steps;

  setup_filesystem;
  install_homebrew;
  install_homebrew_packages;
  install_npm_packages;
  create_global_python_venv;
  install_misc_dependencies;
  generate_ssh_keys;

  install_neovim;
  unstow_dotfiles;

  set_macos_settings;
  setup_services;

  print_manual_steps;
  print_macos_steps;

  run_healthcheck;
}

step_functions=(
  setup_filesystem
  install_homebrew
  install_homebrew_packages
  install_npm_packages
  create_global_python_venv
  install_misc_dependencies
  generate_ssh_keys
  install_neovim
  unstow_dotfiles
  set_macos_settings
  setup_services
  print_manual_steps
  print_macos_steps
  run_healthcheck
)

run_specific_steps() {
if [ $# -eq 0 ]; then
    echo "No steps provided. Please specify step numbers to run."
    return
  fi

  for step_num in "$@"; do
    if (( step_num >= 1 && step_num <= 14 )); then
      echo "Executing Step $step_num..."
      ${step_functions[step_num-1]}
    else
      echo "Invalid step number: $step_num"
    fi
  done
}

show_steps() {
  echo "It looks like you are setting up a new MacOS computer!"
  echo "The first thing to do is copy this file to your local filesytem run chmod +x {filename}.sh, and source it, as shown below"
  echo 'curl -L -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/gists/06976a1e2ae3f7f73814ec187e308d9a | jq -r '\''.files["init-macos.zsh"].content'\'' > "~/init-macos.zsh" && chmod +x ~/init-macos.zsh && source "~/init-macos.zsh"'
  echo ""
  echo ""
  echo "This script can perform the following steps..."
  echo ""
  echo "Step 1: Creating standard folder structure"
  echo "Step 2: Installing Homebrew package manager"
  echo "Step 3: Installing Homebrew packages and casks"
  echo "Step 4: Installing npm packages"
  echo "Step 5: Creating global Python venv and installing packages"
  echo "Step 6: Installing miscellaneous dependencies"
  echo "Step 7: Creating SSH keys"
  echo "Step 8: Installing Neovim from source"
  echo "Step 9: Cloning dotfiles repo and unstowing dotfiles"
  echo "Step 10: Set MacOS settings that can be handled via CLI"
  echo "Step 11: Setup services (ollama, chromadb)"
  echo ""
  echo "At this point, the steps become manual and are broken up into two parts:"
  echo ""
  echo "Step 12: Manual steps to complete setup"
  echo "Step 13: Update MacOS settings (also manual)"
  echo ""
  echo "Step 14: Run healthcheck to see what failed"
  echo "And then you should be done!"

  show_help;
}

show_manual_steps() {
  print_manual_steps;
  print_macos_steps;
}

setup_filesystem() {
  ############################
  # XDG                      #
  ############################

  echo "Step 1: Starting off by creating standard folder structure, starting in $HOME"

  cd "$HOME";

  mkdir "$HOME"/.cache;
  mkdir "$HOME"/.config;
  mkdir -p "$HOME"/.local/share;
  mkdir "$HOME"/.local/state;
  mkdir "$HOME"/.local/bin;
  mkdir "$HOME"/.local/data;
  mkdir "$HOME"/src;

  export XDG_CACHE_HOME=$HOME/.cache
  export XDG_CONFIG_HOME=$HOME/.config
  export XDG_DATA_HOME=$HOME/.local/share
  export XDG_STATE_HOME=$HOME/.local/state
  export XDG_BIN_HOME=$HOME/.local/bin
  export XDG_DATA_DIRS="$HOME/.local/data:$XDG_DATA_DIRS"
  export XDG_CODE_HOME=$HOME/src

  ############################
  # ZSH                      #
  ############################

  mkdir "$XDG_STATE_HOME/zsh";
  mkdir "$XDG_CACHE_HOME/zsh";
  mkdir "$XDG_STATE_HOME/less";

  ############################
  # PSQL                     #
  ############################

  mkdir "$XDG_DATA_HOME/psql";
  mkdir "$XDG_STATE_HOME/psql";

  ############################
  # Golang                   #
  ############################

  mkdir "$XDG_DATA_HOME/go";

  ############################
  # Rust/Cargo               #
  ############################

  mkdir "$XDG_DATA_HOME/cargo";
  mkdir "$XDG_DATA_HOME/rustup";

  ############################
  # Python                   #
  ############################

  mkdir "$XDG_STATE_HOME/python";
  mkdir "$XDG_DATA_HOME/pyenv";

  ############################
  # Node/npm                 #
  ############################

  mkdir "$XDG_DATA_HOME/npm";

  ############################
  # Work                     #
  ############################

  mkdir -p "$XDG_CODE_HOME"/work/configs;
  mkdir "$XDG_CODE_HOME"/work/dbs;

  ############################
  # Misc                     #
  ############################

  mkdir "$HOME"/Downloads/slack;
  mkdir "$HOME"/Downloads/postman;

  mkdir "$HOME"/Pictures/screenshots;
  mkdir "$HOME/Documents/\'test data\'";

  echo "Step 1: Finished creating XDG and other basic folders!"
}

install_homebrew() {
  ############################
  # Install Brew             #
  ############################

  echo "Step 2: Installing Homebrew package manager"
  echo "Step 2: Installing Homebrew if not present"

  if command -v brew >/dev/null 2>&1; then
    echo "Step 2: Homebrew is already installed, continuing."
  else
    echo "Step 2: Homebrew is not yet installed. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  if check_command_is_installed brew; then
    echo "Step 2: Finished installing Homebrew!"
  else
    echo "Step 2: Failed to install Homebrew, which is required to continue. Exiting..."
    exit 1;
  fi

  ############################
  # Brew Autoupdate          #
  ############################

  echo "Step 2: Installing and starting Homebrew autoupdate"

  brew tap domt4/autoupdate;
  brew autoupdate start;

  echo "Step 2: Finished setting up Homebrew!"
}

install_homebrew_packages() {
  ############################
  # Install Homebrew Deps    #
  ############################

  echo "Step 3: Installing Homebrew packages and casks"

  if ! check_command_is_installed brew; then
    echo "Step 3: Homebrew is not installed. Please run step 2 first."
    return 1
  fi

  echo "Step 3a: Tapping Homebrew repositories..."

  brew tap ${brew_taps}

  echo "Step 3a: Finished tapping Homebrew repositories!"

  echo "Step 3b: Installing Homebrew packages..."

  brew install "${brew_packages[@]}"

  echo "Step 3c: Installing Homebrew cask packages..."

  brew install --cask "${brew_packages_with_cask[@]}"

  echo "Step 3: Finished installing Homebrew packages and casks!"
}

install_npm_packages() {
  ############################
  # Install Node/npm Deps    #
  ############################

  echo "Step 4: Installing npm packages"

  if ! check_command_is_installed npm; then
    echo "Step 4: npm is not installed. Please ensure Node.js is installed first."
    return 1
  fi

  echo "Step 4a: Configuring npm prefix..."

  npm config set prefix "$NPM_PACKAGES"

  echo "Step 4b: Installing global npm packages..."

  npm install -g "${npm_packages_to_install[@]}"

  echo "Step 4: Finished installing npm packages!"
}

create_global_python_venv() {
  ############################
  # Create Global Python Venv #
  ############################

  echo "Step 5: Creating global Python venv and installing packages"

  echo "Step 5a: Installing uv if not present..."

  if ! check_command_is_installed uv; then
    echo "Step 5a: uv is not installed. Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.cargo/bin:$PATH"
  else
    echo "Step 5a: uv is already installed, continuing."
  fi

  echo "Step 5b: Creating global Python venv..."

  # Create global venv if it doesn't exist
  if [[ ! -d "$HOME/.global-py" ]]; then
    echo "Step 5b: Creating ~/.global-py venv..."
    uv venv "$HOME/.global-py"
  else
    echo "Step 5b: ~/.global-py venv already exists, continuing..."
  fi

  echo "Step 5c: Installing Python packages in global venv..."

  # Install packages using uv with the global venv
  for package in "${python_packages_to_install[@]}"; do
    echo "Installing $package..."
    uv pip install --python "$HOME/.global-py/bin/python" "$package"
  done

  echo "Step 5: Finished creating global Python venv and installing packages!"
}

install_misc_dependencies() {
  ############################
  # Misc Dependencies        #
  ############################

  echo "Step 6: Installing miscellaneous dependencies"

  echo "Step 6a: Downloading schemaspy..."

  mkdir -p "$XDG_CODE_HOME/schemaspy"
  curl -L https://github.com/schemaspy/schemaspy/releases/download/v6.2.4/schemaspy-6.2.4.jar \
    --output "$XDG_CODE_HOME"/schemaspy/schemaspy.jar

  echo "Step 6: Finished installing miscellaneous dependencies!"

}

generate_ssh_keys() {
  ############################
  # Generate SSH Keys        #
  ############################

  echo "Step 7: Creating SSH keys..."

  echo "Step 7: Creating ssh keys for ${ssh_keys_to_create[@]}"
  create_ssh_keys "${ssh_keys_to_create[@]}";

  echo "Step 7: Finished creating SSH keys!"
}

install_neovim() {
  ############################
  # Install Neovim           #
  ############################

  echo "Step 8: Installing Neovim from source..."

  cd "$XDG_CODE_HOME";

  git clone https://github.com/neovim/neovim.git

  cd neovim;
  rm -r build/
  make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$XDG_CODE_HOME/neovim";
  make install;
  export PATH="$XDG_CODE_HOME/neovim/bin:$PATH"

  if check_command_is_installed nvim; then
    echo "Step 8: Finished installing Neovim from source!"
  else
    echo "Step 8: Was unable to install Neovim from source. The script can and will continue, and report on this later."
    export NEOVIM_FAILED=true
  fi

  cd "$HOME";
}

unstow_dotfiles() {
  ############################
  # Unstow dotfiles          #
  ############################

  echo "Step 9: Cloning dotfiles repo and unstowing dotfiles..."

  cd "$XDG_CODE_HOME";
  git clone https://github.com/3ZsForInsomnia/dotfiles.git;


  echo "Step 9a: Finished cloning dotfiles repo!"

  if check_command_is_installed stow; then
    echo "Step 9b: Stow is installed, unstowing dotfiles..."
    cd dotfiles;
    unstowAll;
    echo "Step 9b: Finished unstowing dotfiles!"
  else
    echo "Step 9b: Stow is not installed. We can continue and report on this later"
    export UNSTOW_FAILED=true
  fi

  echo "Step 9c: Initializing zshmarks file..."

  printf "%s|src\n%s/dotfiles|dots\n%s/work|work\n%s|docs\n%s/sync|notes\n%s/test data/|tdata\n%s/screenshots|shots\n%s|dls\n%s/slack|dlslack\n" \
  "$HOME/src" \
  "$HOME/src" \
  "$HOME/src" \
  "$HOME/Documents" \
  "$HOME/Documents" \
  "$HOME/Documents" \
  "$HOME/Pictures" \
  "$HOME/Downloads" \
  "$HOME/Downloads" \
  > "$BOOKMARKS_FILE"

  echo "Step 9c: Finished setting zshmarks!"
  
  cd "$HOME";
}

retrieve_hidden_gists() {
  ############################
  # Retrieve hidden gists    #
  ############################

  echo "Step 10: Retrieving hidden gists..."

  if check_command_is_installed gh; then
    echo "gh CLI is installed, you will be able to load your hidden gists"
  else
    echo "gh CLI is not installed. Please install it or manually place your gists to complete this step"
    exit 1
  fi

  if check_if_file_or_folder_exists "$HOME/hidden-gists.txt"; then
    echo "Hidden gists file exists, continuing..."
  else
    echo "The hidden gists file does not exist. Please create it and run this script again. It must live at \"$HOME/hidden-gists.txt\""
    exit 1
  fi

  handle_all_gists "$HOME/hidden-gists.txt"

  echo "Step 10: Finished retrieving hidden gists!"
}

set_macos_settings() {
  ############################
  # Set MacOS settings       #
  ############################

  echo "Step 10: Setting MacOS settings that can be handled via CLI..."

  sudo -v

  echo "Step 10a: Unsetting smart quotes and dashes..."

  # Unset smart quotes and dashes
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

  echo "Step 10b: Setting dock and menu bar preferences..."

  defaults write com.apple.dock "autohide" -bool "true"
  defaults write com.apple.dock "show-recents" -bool "false"
  defaults write com.apple.dock "mru-spaces" -bool "false"
  killall Dock

  echo "Step 10c: Setting Finder preferences..."
  defaults write com.apple.finder "AppleShowAllFiles" -bool "true"
  defaults write NSGlobalDomain _HIHideMenuBar -bool true
  killall Finder

  echo "Step 10d: Setting sound and appearance settings..."
  osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
  osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/System/Library/Desktop Pictures/Solid Colors/Black.png"'

  echo "Step 10e: Setting miscellaneous preferences..."

  systemsetup -settimezone "$TIMEZONE" > /dev/null

  # Disable natural scrolling
  defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

  defaults write com.apple.screencapture location -string "$HOME/Pictures/screenshots"

  defaults write com.apple.spaces "spans-displays" -bool "true" && killall SystemUIServer

  echo "Step 10: Finished setting MacOS settings!"
  echo "Note, you should probably restart your laptop after running this step."
}

setup_services() {
  ############################
  # Setup Services           #
  ############################

  echo "Step 11: Setting up services..."

  echo "Step 11a: Starting ollama service..."

  if check_command_is_installed ollama; then
    echo "Step 11a: Starting ollama via brew services..."
    brew services start ollama
    
    # Wait a moment for service to start
    sleep 3
    
    echo "Step 11a: Downloading nomic-embed-text model..."
    ollama pull nomic-embed-text
    
    echo "Step 11a: Finished setting up ollama!"
  else
    echo "Step 11a: ollama is not installed. Skipping ollama setup."
  fi

  echo "Step 11b: Setting up ChromaDB service..."

  if check_command_is_installed docker; then
    # Create chroma data directory
    mkdir -p "$HOME/.local/share/chroma-data"
    
    # Create LaunchAgent directory if it doesn't exist
    mkdir -p "$HOME/Library/LaunchAgents"
    
    # Check if plist already exists
    if [[ -f "$HOME/Library/LaunchAgents/com.user.chromadb.plist" ]]; then
      echo "Step 11b: ChromaDB plist already exists, updating if needed..."
      # Unload existing service
      launchctl unload "$HOME/Library/LaunchAgents/com.user.chromadb.plist" 2>/dev/null || true
    fi
    
    # Create the plist file
    cat > "$HOME/Library/LaunchAgents/com.user.chromadb.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.user.chromadb</string>
  <key>ProgramArguments</key>
  <array>
    <string>/usr/local/bin/docker</string>
    <string>run</string>
    <string>--rm</string>
    <string>-v</string>
    <string>$HOME/.local/share/chroma-data:/data</string>
    <string>-p</string>
    <string>8000:8000</string>
    <string>chromadb/chroma:0.6.3</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
  <key>StandardOutPath</key>
  <string>/tmp/chromadb.log</string>
  <key>StandardErrorPath</key>
  <string>/tmp/chromadb.err</string>
</dict>
</plist>
EOF
    
    # Load the service
    launchctl load "$HOME/Library/LaunchAgents/com.user.chromadb.plist"
    
    echo "Step 11b: Finished setting up ChromaDB service!"
  else
    echo "Step 11b: Docker is not installed. Skipping ChromaDB setup."
  fi

  echo "Step 11: Finished setting up services!"
}

print_manual_steps() {
  ############################
  # Manual steps             #
  ############################

  echo "Step 12: Manual steps to complete setup:"
  echo "Step 12a: Log into Github and register ssh keys"
  echo "Step 12b: Clone learning repo with SSH: cd \$XDG_CODE_HOME && git clone git@github.com:3ZsForInsomnia/learning.git"
  echo "Step 12c: Log into gh cli and run script to pull hidden gists. There is a bash function included in this file that you can run to do this automatically once you have logged into gh"
  echo "To do this, use gh to pull down your gist containing the list of hidden gists, and run \`handle_all_gists <file>\`"
  echo "Or alternatively, run the \`retrieve_hidden_gists\` function after setting up gh auth"
  echo ""
  echo "Step 12d: Setup Obsidian sync"
  echo "Step 12e: Log into Chrome, make it default web browser"

  other_apps=("Slack" "Postman" "Lastpass" "Lastpass Cli" "Tidal" "Copilot in Neovim")
  echo "Step 12f: Log into each of these manually: "
  echo_each_element "${other_apps[@]}"
}

print_macos_steps() {
  ############################
  # MacOS Settings           #
  ############################

  echo "Step 13: Update the following MacOS settings:"
  echo "Step 13a: Set caps-lock to act as escape"
  echo "Step 13b: Add Hebrew keyboard layout"
  echo "Step 13c: Hide spotlight and siri from top bar"
  echo "Step 13d: Turn off automatic display brightness"
  echo "Step 13e: Turn off startup and interface sounds"
  echo "Step 13f: Turn on Night shift and configure schedule"
}

############################
# Handle failures          #
############################

healthcheck() {
  did_anything_fail=0
  echo ""
  echo_on_verbose "Checking if all paths were properly created..."
  find_non_existent_paths "${paths_to_check[@]}"
  if (( ${#NON_EXISTENT_PATHS[@]} > 0 )); then
    echo "  These paths were not created: "
    echo_each_element "${NON_EXISTENT_PATHS[@]}";
    echo ""
    (( did_anything_fail++ ))
  else
    echo_on_success "  All paths were created successfully!"
  fi

  echo_on_verbose "Checking if gh, stow, brew, and npm are installed..."
  if check_command_is_installed gh; then
    echo_on_success "  gh is installed!"
  else
    echo "  gh is not installed!"
    echo ""
    (( did_anything_fail++ ))
  fi
  if check_command_is_installed stow; then
    echo_on_success "  Stow is installed!"
  else
    echo "  Stow is not installed!"
    echo ""
    (( did_anything_fail++ ))
  fi
  if check_command_is_installed brew; then
    echo_on_success "  Brew is installed!"
  else
    echo "  Brew is not installed!"
    echo ""
    (( did_anything_fail++ ))
  fi
  if check_command_is_installed npm; then
    echo_on_success "  Npm is installed!"
  else
    echo "  Npm is not installed!"
    echo ""
    (( did_anything_fail++ ))
  fi

  echo_on_verbose "Checking if brew packages are installed..."
  updated_brew_packages=($(array_diff brew_packages installed_applications))
  check_brew_installed "${updated_brew_packages[@]}"

  if (( ${#BREW_FAILED_PACKAGES[@]} > 0 )); then
    echo "  These brew packages failed to install: "
    echo_each_element "${BREW_FAILED_PACKAGES[@]}";
    echo ""
    (( did_anything_fail++ ))
  else
    echo_on_success "  All Brew packages were installed successfully!"
  fi

  echo_on_verbose "Checking if brew cask packages are installed..."
  updated_brew_casks=($(array_diff brew_packages_with_cask installed_applications))
  check_brew_installed "${updated_brew_casks[@]}"

  if (( ${#BREW_FAILED_PACKAGES[@]} > 0 )); then
    echo "  These brew cask packages failed to install: "
    echo_each_element "${BREW_FAILED_PACKAGES[@]}";
    echo ""
    (( did_anything_fail++ ))
  else
    echo_on_success "  All Brew cask packages were installed successfully!"
  fi

  echo_on_verbose "Checking if brew installed applications are installed..."
  check_if_applications_installed "${installed_applications[@]}"
  if (( ${#APPLICATIONS_NOT_INSTALLED[@]} > 0 )); then
    echo "  These applications are not installed: "
    echo_each_element "${APPLICATIONS_NOT_INSTALLED[@]}";
    echo ""
    (( did_anything_fail++ ))
  else
    echo_on_success "  All installed applications are installed!"
  fi

  echo_on_verbose "Checking if npm packages are installed..."
  check_npm_installed "${npm_packages_to_install[@]}"
  if (( ${#NPM_FAILED_PACKAGES[@]} > 0 )); then
    echo "  These npm packages failed to install: "
    echo_each_element "${NPM_FAILED_PACKAGES[@]}";
    echo ""
    (( did_anything_fail++ ))
  else
    echo_on_success "  All Npm packages were installed successfully!"
  fi

  echo_on_verbose "Checking if global Python venv exists and packages are installed..."
  if check_if_file_or_folder_exists "$HOME/.global-py"; then
    echo_on_success "  Global Python venv exists!"
    
    # Check if packages are installed in the global venv
    PYTHON_FAILED_PACKAGES=()
    for package in "${python_packages_to_install[@]}"; do
      if ! "$HOME/.global-py/bin/python" -m pip list | grep -q "^$package "; then
        PYTHON_FAILED_PACKAGES+=("$package")
      fi
    done
    
    if (( ${#PYTHON_FAILED_PACKAGES[@]} > 0 )); then
      echo "  These Python packages failed to install in global venv: "
      echo_each_element "${PYTHON_FAILED_PACKAGES[@]}";
      echo ""
      (( did_anything_fail++ ))
    else
      echo_on_success "  All Python packages were installed successfully in global venv!"
    fi
  else
    echo "  Global Python venv does not exist!"
    echo ""
    (( did_anything_fail++ ))
  fi

  echo_on_verbose "Checking if Neovim installed..."
  if check_command_is_installed nvim; then
    echo_on_success "  Neovim is installed!"
  else
    echo "  Neovim is not installed!"
    echo ""
    (( did_anything_fail++ ))
  fi

  echo_on_verbose "Checking if dotfiles were unstowed..."
  if check_if_file_or_folder_exists "$HOME/src/dotfiles"; then
    echo_on_success "  Dotfiles repo exists!"

    echo_on_verbose "Checking if ~/.zshrc exists..."
    if check_if_file_or_folder_exists "$HOME/.zshrc"; then
      echo_on_success "    Zshrc exists!"
    else
      echo "    Zshrc does not exist!"
      echo ""
      (( did_anything_fail++ ))
    fi

    echo_on_verbose "Checking if dotfiles were unstowed..."
    find_non_existent_paths "${stowed_folder_locations[@]}"

    if (( ${#NON_EXISTENT_PATHS[@]} > 0 )); then
      echo "    These dotfile paths were not created: "
      echo_each_element "${NON_EXISTENT_PATHS[@]}";
      echo ""
      (( did_anything_fail++ ))
    else
      echo_on_success "    All dotfile paths were created successfully! Everything was unstowed"
    fi
  else
    echo "  Dotfiles repo does not exist!"
    echo ""
    (( did_anything_fail++ ))
  fi

  echo_on_verbose "Checking if Notes repo was retrieved..."
  if check_if_file_or_folder_exists "$HOME/Documents/sync"; then
    echo_on_success "  Notes repo exists!"
  else
    echo "  Notes repo does not exist!"
    echo ""
    (( did_anything_fail++ ))
  fi

  echo_on_verbose "Checking ssh keys..."
  for key_name in "${ssh_keys_to_create[@]}"; do
    # Convert key name to lowercase
    lower_case_key="${key_name:l}"

    # Initialize found_files array
    found_files=()

    # Use nullglob to ensure no errors if no files are found
    setopt nullglob
    found_files=(~/.ssh/*"${lower_case_key}"*)
    unsetopt nullglob

    # Check number of matching files
    if (( ${#found_files[@]} == 0 )); then
      echo "    No SSH files found for ${key_name}."
      (( did_anything_fail++ ))
    elif (( ${#found_files[@]} == 1 )); then
      echo_on_success "    Found SSH file for ${key_name}: ${found_files[1]##*/}"
    else
      echo "    Multiple SSH files found for ${key_name}:"
      echo_each_element "${found_files[@]}";
      (( did_anything_fail++ ))
    fi
  done

  echo_on_verbose "Checking if MacOS settings were set..."
  background_file=$(osascript -e 'tell app "finder" to get posix path of (get desktop picture as alias)')
  if [[ "$background_file" == "/System/Library/Desktop Pictures/Solid Colors/Black.png" ]]; then
    echo_on_success "  Desktop background is set to black!"
  else
    echo "  Desktop background is not set to black!"
    echo ""
    (( did_anything_fail++ ))
  fi

  is_dark_mode_enabled=$(defaults read -g AppleInterfaceStyle)
  if [[ "$is_dark_mode_enabled" == "Dark" ]]; then
    echo_on_success "  Dark mode is enabled!"
  else
    echo "  Dark mode is not enabled!"
    echo ""
    (( did_anything_fail++ ))
  fi

  are_smart_quotes_enabled=$(defaults read NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled)
  if [[ "$are_smart_quotes_enabled" == "0" ]]; then
    echo_on_success "  Smart quotes are disabled!"
  else
    echo "  Smart quotes are enabled!"
    echo ""
    (( did_anything_fail++ ))
  fi

  are_smart_dashes_enabled=$(defaults read NSGlobalDomain NSAutomaticDashSubstitutionEnabled)
  if [[ "$are_smart_dashes_enabled" == "0" ]]; then
    echo_on_success "  Smart dashes are disabled!"
  else
    echo "  Smart dashes are enabled!"
    echo ""
    (( did_anything_fail++ ))
  fi

  is_dock_set_to_autohide=$(defaults read com.apple.dock autohide)
  if [[ "$is_dock_set_to_autohide" == "1" ]]; then
    echo_on_success "  Dock is set to autohide!"
  else
    echo "  Dock is not set to autohide!"
    echo ""
    (( did_anything_fail++ ))
  fi

  is_dock_set_to_show_recents=$(defaults read com.apple.dock show-recents)
  if [[ "$is_dock_set_to_show_recents" == "0" ]]; then
    echo_on_success "  Dock is set to not show recents!"
  else
    echo "  Dock is set to show recents!"
    echo ""
    (( did_anything_fail++ ))
  fi

  are_mru_spaces_enabled=$(defaults read com.apple.dock mru-spaces)
  if [[ "$are_mru_spaces_enabled" == "0" ]]; then
    echo_on_success "  Dock is set to not show most recent used spaces!"
  else
    echo "  Dock is set to show most recent used spaces!"
    echo ""
    (( did_anything_fail++ ))
  fi

  show_all_files=$(defaults read com.apple.finder AppleShowAllFiles)
  if [[ "$show_all_files" == "1" ]]; then
    echo_on_success "  Finder is set to show all files!"
  else
    echo "  Finder is not set to show all files!"
    echo ""
    (( did_anything_fail++ ))
  fi

  hide_menu_bar=$(defaults read NSGlobalDomain _HIHideMenuBar)
  if [[ "$hide_menu_bar" == "1" ]]; then
    echo_on_success "  Menu bar is hidden!"
  else
    echo "  Menu bar is not hidden!"
    echo ""
    (( did_anything_fail++ ))
  fi

  timezone_should_be_ny=$(sudo systemsetup -gettimezone | grep -q "America/New_York")
  if $timezone_should_be_ny; then
    echo_on_success "  Timezone is set to New York!"
  else
    echo "  Timezone is not set to New York!"
    echo ""
    (( did_anything_fail++ ))
  fi

  is_natural_scrolling_enabled=$(defaults read NSGlobalDomain com.apple.swipescrolldirection)
  if [[ "$is_natural_scrolling_enabled" == "0" ]]; then
    echo_on_success "  Natural scrolling is disabled!"
  else
    echo "  Natural scrolling is enabled!"
    echo ""
    (( did_anything_fail++ ))
  fi

  screenshot_location=$(defaults read com.apple.screencapture location)
  if [[ "$screenshot_location" == "~/Pictures/screenshots" ]]; then
    echo_on_success "  Screenshot location is set to ~/Pictures/screenshots!"
  else
    echo "  Screenshot location is not set to ~/Pictures/screenshots!"
    echo ""
    (( did_anything_fail++ ))
  fi

  spans_displays=$(defaults read com.apple.spaces spans-displays)
  if [[ "$spans_displays" == "1" ]]; then
    echo_on_success "  Spaces spans displays!"
  else
    echo "  Spaces does not span displays!"
    echo ""
    (( did_anything_fail++ ))
  fi

  echo_on_verbose "Checking if services are running..."
  
  # Check ollama service
  if check_command_is_installed ollama; then
    if brew services list | grep -q "ollama.*started"; then
      echo_on_success "  Ollama service is running!"
    else
      echo "  Ollama service is not running!"
      echo ""
      (( did_anything_fail++ ))
    fi
  else
    echo "  Ollama is not installed!"
    echo ""
    (( did_anything_fail++ ))
  fi
  
  # Check ChromaDB service
  if check_if_file_or_folder_exists "$HOME/Library/LaunchAgents/com.user.chromadb.plist"; then
    if launchctl list | grep -q "com.user.chromadb"; then
      echo_on_success "  ChromaDB service is loaded!"
    else
      echo "  ChromaDB service plist exists but is not loaded!"
      echo ""
      (( did_anything_fail++ ))
    fi
  else
    echo "  ChromaDB service plist does not exist!"
    echo ""
    (( did_anything_fail++ ))
  fi
  echo ""
  echo "Healthcheck complete!"
  if [[ $did_anything_fail -gt 0 ]]; then
    echo "  There were failures during the setup process. Please review the output above to see what failed."
    echo "  There were $did_anything_fail failures."
  else
    echo "  Everything appears to have been set up successfully!"
  fi
}

run_healthcheck() {
  echo "Step 14: Running full health check..."

  healthcheck;

  echo "Step 14: Finished checking for failed installations!"
}
