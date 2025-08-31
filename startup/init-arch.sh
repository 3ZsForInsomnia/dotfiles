############################
# Variables                #
############################

paths_to_check=("$HOME/.cache" "$HOME/.local/state" "$HOME/.local/bin" "$HOME/.local/share" "$HOME/.config" "$HOME/.local/bin" "$HOME/src" "$HOME/Downloads/slack" "$HOME/Downloads/postman" "$HOME/Pictures/screenshots" "$HOME/Documents/test data" "$HOME/Documents/sync" "$HOME/.local/state/psql" "$HOME/.cache/zsh" "$HOME/.local/state/zsh" "$HOME/.local/state/python" "$HOME/.local/share/psql" "$HOME/.local/state/less" "$HOME/.local/share/bookmarks" "$HOME/src/work" "$HOME/.local/share/npm" "$HOME/.local/share/pyenv")

# Cross-platform packages available in Arch repos
pacman_packages=("zsh" "eza" "fzf" "fd" "ripgrep" "go" "delve" "stow" "bat" "docker" "kubectl" "github-cli" "imagemagick" "ffmpeg" "yazi" "p7zip" "poppler" "zoxide" "glow" "fx" "nodejs" "npm" "ninja" "cmake" "gettext" "curl" "pyenv" "newsboat" "tokei" "graphviz" "git-delta" "tmux" "hyperfine" "pandoc" "speedtest-cli" "python-pipx" "helm" "yq" "i3-wm" "i3blocks" "i3status" "i3lock" "rofi" "dunst" "xorg-server" "xorg-xinit" "xorg-xmodmap" "alacritty")

# AUR packages (will need yay or another AUR helper)
aur_packages=("luacheck" "powerlevel10k-git" "espanso" "lastpass-cli" "jira-cli" "lazydocker" "overmind")

# Cross-platform GUI applications (some available as Flatpak/AUR)
gui_applications=("copyq" "obsidian" "google-chrome" "slack-desktop" "postman-bin")

npm_packages_to_install=("eslint_d" "@fsouza/prettierd" "git-split-diffs" "jsonlint" "nx@latest" "commitizen" "markdownlint" "mcp-hub@latest" "@bytebase/dbhub" "nx-mcp@latest" "task-master-ai")

pip_packages_to_install=("yamllint" "shell-gpt")

uv_packages_to_install=("vectorcode" "basic-memory")

stowed_folder_locations=("$HOME/.config/bat" "$HOME/.config/ctags" "$HOME/.config/espanso" "$HOME/.config/git" "$HOME/.config/luacheck" "$HOME/.config/nvim" "$HOME/.local/bin/notes" "$HOME/.config/newsboat" "$HOME/.local/bin/8ball" "$HOME/.config/silicon" "$HOME/.config/ripgrep" "$HOME/.config/wezterm" "$HOME/.config/yazi" "$HOME/.zsh" "$HOME/.config/i3" "$HOME/.config/dunst" "$HOME/.config/rofi" "$HOME/.config/systemd" "$HOME/.icons" "$HOME/.Xmodmap" "$HOME/.XCompose")

installed_applications=("postman" "obsidian" "google-chrome" "slack" "copyq")

dotfiles_to_unstow=(
  ctags
  espanso
  git
  neovim
  notes
  personal-scripts
  rss
  yazi
  zsh
  i3wm
  alacritty
)

PERSONAL_EMAIL="comrade.topanga@gmail.com"
WORK_EMAIL="zachary.levine@centrobenefits.com"

NPM_PACKAGES="$HOME/.local/share/npm"
BOOKMARKS_FILE="$HOME/.local/share/bookmarks/.bookmarks"
TIMEZONE="America/New_York"

SCREENSHOTS_DIR="$HOME/Pictures/screenshots"

ssh_keys_to_create=("PERSONAL")

############################
# Helper scripts           #
############################

function array_diff {
  local array1_name="$1"
  local array2_name="$2"
  local result=()

  # Get array references using declare -n (bash 4.3+)
  declare -n array1_ref="$array1_name"
  declare -n array2_ref="$array2_name"

  for element in "${array1_ref[@]}"; do
    local found=0
    for check_element in "${array2_ref[@]}"; do
      if [[ "$element" == "$check_element" ]]; then
        found=1
        break
      fi
    done
    if [[ $found -eq 0 ]]; then
      result+=("$element")
    fi
  done

  echo "${result[@]}"
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
    https://api.github.com/gists/06976a1e2ae3f7f73814ec187e308d9a | jq -r '.files["init-arch.sh"].content' >"$HOME/init-arch.sh" && source "$HOME/init-arch.sh"
}

check_command_is_installed() {
  if command -v "$1" >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

# Used after pacman install is complete to check that all packages installed.
# It will put all packages that failed to install into $PACMAN_FAILED_PACKAGES when done
check_pacman_installed() {
  local packages=("$@")
  PACMAN_FAILED_PACKAGES=()

  for package in "${packages[@]}"; do
    # Check if the package is installed
    if ! pacman -Q "$package" >/dev/null 2>&1; then
      PACMAN_FAILED_PACKAGES+=("$package")
    fi
  done
}

# Used after AUR install is complete to check that all packages installed.
# It will put all packages that failed to install into $AUR_FAILED_PACKAGES when done
check_aur_installed() {
  local packages=("$@")
  AUR_FAILED_PACKAGES=()

  for package in "${packages[@]}"; do
    # Check if the package is installed (remove -git suffix for checking)
    local clean_pkg="${package/-git/}"
    if ! pacman -Q "$package" >/dev/null 2>&1; then
      AUR_FAILED_PACKAGES+=("$package")
    fi
  done
}

# Used after npm install is complete to check that all packages installed.
# It will put all packages that failed to install into $NPM_FAILED_PACKAGES when done
check_npm_installed() {
  local packages=("$@")
  NPM_FAILED_PACKAGES=() # Initialize the variable to hold missing packages

  for package in "${packages[@]}"; do
    local clean_pkg="${package/@latest/}"
    if ! npm list -g --depth=0 "$clean_pkg" >/dev/null 2>&1; then
      NPM_FAILED_PACKAGES+=("$clean_pkg")
    fi
  done
}

create_ssh_keys() {
  local ssh_keys_to_create=("$@")
  local key_name email first_name last_name file_name lower_case_key

  # Iterate over the array of key identifiers
  for key_name in "${ssh_keys_to_create[@]}"; do
    # Dynamically access the email associated with the key name
    email_var_name="${key_name}_EMAIL"
    email="${!email_var_name}"

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
    lower_case_key="${key_name,,}"

    # Construct the desired file name
    file_name="id_rsa_${lower_case_key}_${first_name}_${last_name}"

    # Generate the SSH key pair
    ssh-keygen -t rsa -b 4096 -C "$email" -f "$file_name" -N ""
  done
}

download_gist() {
  local gist_id=$1
  local destination_path=$2
  local file_name=$3

  # Check if gh command is available
  if ! command -v gh &>/dev/null; then
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
  if echo "$gist_content" >"$destination_path"; then
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
  done <"$file_path"
}

retrieve_hidden_gists() {
  ############################
  # Retrieve hidden gists    #
  ############################

  echo "Retrieving hidden gists..."

  if check_command_is_installed gh; then
    echo "gh CLI is installed, you will be able to load your hidden gists"
  else
    echo "gh CLI is not installed. Please install it or manually place your gists to complete this step"
    return 1
  fi

  if check_if_file_or_folder_exists "$HOME/hidden-gists.txt"; then
    echo "Hidden gists file exists, continuing..."
  else
    echo "The hidden gists file does not exist. Please create it and run this script again. It must live at \"$HOME/hidden-gists.txt\""
    return 1
  fi

  handle_all_gists "$HOME/hidden-gists.txt"

  echo "Finished retrieving hidden gists!"
}

alias unstow='stow --target=$HOME'
function unstowAll() {
  cd "$XDG_CODE_HOME/dotfiles/"

  for element in "${dotfiles_to_unstow[@]}"; do
    echo "Unstowing: $element..."
    unstow "$element"
  done
}

check_if_file_or_folder_exists() {
  if [ -e "$1" ]; then
    return 0
  else
    return 1
  fi
}

find_non_existent_paths() {
  NON_EXISTENT_PATHS=()
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
  APPLICATIONS_NOT_INSTALLED=()

  for application in "${applications[@]}"; do
    application_lower="${application,,}"
    # Check both pacman and flatpak installations
    if ! pacman -Q "$application_lower" >/dev/null 2>&1 && ! flatpak list | grep -qi "$application_lower"; then
      APPLICATIONS_NOT_INSTALLED+=("$application_lower")
    fi
  done
}

############################
# Step 0 functions         #
############################

show_help() {
  echo "Hi there! This script automates much of the setup of a new Arch Linux computer with i3wm."
  echo "The default expected usage is to source this file and run \`run_all_steps\`."
  echo "This will run all 10 automated setup steps and the healthcheck, as well as tell you what manual steps must be taken."
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
  show_steps

  setup_filesystem
  install_pacman
  install_aur_helper
  install_pacman_packages
  install_aur_packages
  install_npm_packages
  install_python_packages
  install_misc_dependencies
  generate_ssh_keys
  install_neovim
  unstow_dotfiles

  set_arch_settings

  print_manual_steps
  print_arch_steps

  run_healthcheck
}

step_functions=(
  setup_filesystem
  install_pacman
  install_aur_helper
  install_pacman_packages
  install_aur_packages
  install_npm_packages
  install_python_packages
  install_misc_dependencies
  generate_ssh_keys
  install_neovim
  unstow_dotfiles
  set_arch_settings
  print_manual_steps
  print_arch_steps
  run_healthcheck
)

run_specific_steps() {
  if [ $# -eq 0 ]; then
    echo "No steps provided. Please specify step numbers to run."
    return
  fi

  for step_num in "$@"; do
    if ((step_num >= 1 && step_num <= 15)); then
      echo "Executing Step $step_num..."
      ${step_functions[step_num - 1]}
    else
      echo "Invalid step number: $step_num"
    fi
  done
}

show_steps() {
  echo "It looks like you are setting up a new Arch Linux computer with i3wm!"
  echo "The first thing to do is copy this file to your local filesystem, make it executable, and source it, as shown below:"
  echo 'curl -L -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/gists/06976a1e2ae3f7f73814ec187e308d9a | jq -r '\''.files["init-arch.sh"].content'\'' > "~/init-arch.sh" && chmod +x ~/init-arch.sh && source "~/init-arch.sh"'
  echo ""
  echo ""
  echo "This script can perform the following steps..."
  echo ""
  echo "Step 1: Creating standard folder structure"
  echo "Step 2: Updating pacman and installing base-devel"
  echo "Step 3: Installing AUR helper (yay)"
  echo "Step 4: Installing pacman packages"
  echo "Step 5: Installing AUR packages"
  echo "Step 6: Installing npm packages"
  echo "Step 7: Installing Python packages (pip/pipx and uv)"
  echo "Step 8: Installing miscellaneous dependencies"
  echo "Step 9: Creating SSH keys"
  echo "Step 10: Installing Neovim from source"
  echo "Step 11: Cloning dotfiles repo and unstowing dotfiles"
  echo "Step 12: Set Arch/i3wm settings that can be handled via CLI"
  echo ""
  echo "At this point, the steps become manual and are broken up into two parts:"
  echo ""
  echo "Step 13: Manual steps to complete setup"
  echo "Step 14: Update Arch/i3wm settings (also manual)"
  echo ""
  echo "Step 15: Run healthcheck to see what failed"
  echo "And then you should be done!"

  show_help
}

show_manual_steps() {
  print_manual_steps
  print_arch_steps
}

setup_filesystem() {
  ############################
  # XDG                      #
  ############################

  echo "Step 1: Starting off by creating standard folder structure, starting in $HOME"

  cd "$HOME"

  mkdir "$HOME"/.cache
  mkdir "$HOME"/.config
  mkdir -p "$HOME"/.local/share
  mkdir "$HOME"/.local/state
  mkdir "$HOME"/.local/bin
  mkdir "$HOME"/.local/data
  mkdir "$HOME"/src

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

  mkdir "$XDG_STATE_HOME/zsh"
  mkdir "$XDG_CACHE_HOME/zsh"
  mkdir "$XDG_STATE_HOME/less"

  ############################
  # PSQL                     #
  ############################

  mkdir "$XDG_DATA_HOME/psql"
  mkdir "$XDG_STATE_HOME/psql"

  ############################
  # Golang                   #
  ############################

  mkdir "$XDG_DATA_HOME/go"

  ############################
  # Rust/Cargo               #
  ############################

  mkdir "$XDG_DATA_HOME/cargo"
  mkdir "$XDG_DATA_HOME/rustup"

  ############################
  # Python                   #
  ############################

  mkdir "$XDG_STATE_HOME/python"
  mkdir "$XDG_DATA_HOME/pyenv"

  ############################
  # Node/npm                 #
  ############################

  mkdir "$XDG_DATA_HOME/npm"

  ############################
  # Work                     #
  ############################

  mkdir -p "$XDG_CODE_HOME"/work/configs
  mkdir "$XDG_CODE_HOME"/work/dbs

  ############################
  # Misc                     #
  ############################

  mkdir "$HOME"/Downloads/slack
  mkdir "$HOME"/Downloads/postman

  mkdir "$HOME"/Pictures/screenshots
  mkdir "$HOME/Documents/test data"

  echo "Step 1: Finished creating XDG and other basic folders!"
}

install_pacman() {
  ############################
  # Update pacman            #
  ############################

  echo "Step 2: Updating pacman and installing base-devel"

  if ! check_command_is_installed pacman; then
    echo "Step 2: This script requires Arch Linux with pacman. Exiting..."
    exit 1
  fi

  echo "Step 2: Updating package database..."
  sudo pacman -Sy

  echo "Step 2: Installing base-devel group..."
  sudo pacman -S --needed base-devel

  echo "Step 2: Finished updating pacman and installing base-devel!"
}

install_aur_helper() {
  ############################
  # Install AUR Helper       #
  ############################

  echo "Step 3: Installing AUR helper (yay)"

  if check_command_is_installed yay; then
    echo "Step 3: yay is already installed, continuing."
  else
    echo "Step 3: yay is not yet installed. Installing yay..."

    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd "$HOME"
  fi

  if check_command_is_installed yay; then
    echo "Step 3: Finished installing yay!"
  else
    echo "Step 3: Failed to install yay. You can continue but AUR packages won't be installed automatically."
    export YAY_FAILED=true
  fi
}

install_pacman_packages() {
  ############################
  # Install Pacman Packages  #
  ############################

  echo "Step 4: Installing pacman packages"

  if ! check_command_is_installed pacman; then
    echo "Step 4: pacman is not available. Please run on Arch Linux."
    return 1
  fi

  echo "Step 4: Installing pacman packages..."

  sudo pacman -S --needed "${pacman_packages[@]}"

  echo "Step 4: Finished installing pacman packages!"
}

install_aur_packages() {
  ############################
  # Install AUR Packages     #
  ############################

  echo "Step 5: Installing AUR packages"

  if ! check_command_is_installed yay; then
    echo "Step 5: yay is not installed. Please ensure step 3 completed successfully first."
    return 1
  fi

  echo "Step 5: Installing AUR packages..."

  yay -S --needed "${aur_packages[@]}"

  echo "Step 5: Finished installing AUR packages!"
}

install_npm_packages() {
  ############################
  # Install Node/npm Deps    #
  ############################

  echo "Step 6: Installing npm packages"

  if ! check_command_is_installed npm; then
    echo "Step 6: npm is not installed. Please ensure Node.js is installed first."
    return 1
  fi

  echo "Step 6a: Configuring npm prefix..."

  npm config set prefix "$NPM_PACKAGES"

  echo "Step 6b: Installing global npm packages..."

  npm install -g "${npm_packages_to_install[@]}"

  echo "Step 6: Finished installing npm packages!"
}

install_python_packages() {
  ############################
  # Install Python Deps      #
  ############################

  echo "Step 7: Installing Python packages"

  echo "Step 7a: Installing pip packages via pipx..."

  if check_command_is_installed pipx; then
    pipx install "${pip_packages_to_install[@]}"
    echo "Step 7a: Finished installing pip packages via pipx!"
  else
    echo "Step 7a: pipx is not installed. Skipping pip package installation."
  fi

  echo "Step 7b: Installing Python uv and packages..."

  curl -LsSf https://astral.sh/uv/install.sh | sh
  uv tool install "${uv_packages_to_install[@]}"

  echo "Step 7: Finished installing Python packages!"
}

install_misc_dependencies() {
  ############################
  # Misc Dependencies        #
  ############################

  echo "Step 8: Installing miscellaneous dependencies"

  echo "Step 8a: Downloading schemaspy..."

  mkdir -p "$XDG_CODE_HOME/schemaspy"
  curl -L https://github.com/schemaspy/schemaspy/releases/download/v6.2.4/schemaspy-6.2.4.jar \
    --output "$XDG_CODE_HOME"/schemaspy/schemaspy.jar

  echo "Step 8b: Installing fonts from dotfiles..."

  # Create fonts directory if it doesn't exist
  mkdir -p "$HOME/.local/share/fonts"

  # Copy font files from dotfiles (assuming dotfiles are already cloned)
  if [[ -d "$XDG_CODE_HOME/dotfiles/fonts" ]]; then
    echo "Copying font files..."
    cp -r "$XDG_CODE_HOME/dotfiles/fonts"/* "$HOME/.local/share/fonts/"

    # Refresh font cache
    echo "Refreshing font cache..."
    fc-cache -fv

    echo "Step 8b: Finished installing fonts!"
  else
    echo "Step 8b: Font directory not found in dotfiles. Fonts will need to be installed manually."
  fi
  echo "Step 8: Finished installing miscellaneous dependencies!"

}

generate_ssh_keys() {
  ############################
  # Generate SSH Keys        #
  ############################

  echo "Step 9: Creating SSH keys..."

  echo "Step 9: Creating ssh keys for ${ssh_keys_to_create[@]}"
  create_ssh_keys "${ssh_keys_to_create[@]}"

  echo "Step 9: Finished creating SSH keys!"
}

install_neovim() {
  ############################
  # Install Neovim           #
  ############################

  echo "Step 10: Installing Neovim from source..."

  cd "$XDG_CODE_HOME"

  git clone https://github.com/neovim/neovim.git

  cd neovim
  rm -rf build/
  make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$XDG_CODE_HOME/neovim"
  make install
  export PATH="$XDG_CODE_HOME/neovim/bin:$PATH"

  if check_command_is_installed nvim; then
    echo "Step 10: Finished installing Neovim from source!"
  else
    echo "Step 10: Was unable to install Neovim from source. The script can and will continue, and report on this later."
    export NEOVIM_FAILED=true
  fi

  cd "$HOME"
}

unstow_dotfiles() {
  ############################
  # Unstow dotfiles          #
  ############################

  echo "Step 11: Cloning dotfiles repo and unstowing dotfiles..."

  cd "$XDG_CODE_HOME"
  git clone https://github.com/3ZsForInsomnia/dotfiles.git

  echo "Step 11a: Finished cloning dotfiles repo!"

  if check_command_is_installed stow; then
    echo "Step 11b: Stow is installed, unstowing dotfiles..."
    cd dotfiles
    unstowAll
    echo "Step 11b: Finished unstowing dotfiles!"
  else
    echo "Step 11b: Stow is not installed. We can continue and report on this later"
    export UNSTOW_FAILED=true
  fi

  echo "Step 11c: Initializing zshmarks file..."

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
    >"$BOOKMARKS_FILE"

  echo "Step 11c: Finished setting zshmarks!"

  cd "$HOME"
}

set_arch_settings() {
  ############################
  # Set Arch/i3wm settings   #
  ############################

  echo "Step 12: Setting Arch/i3wm settings that can be handled via CLI..."

  echo "Step 12a: Setting timezone..."

  sudo timedatectl set-timezone "$TIMEZONE"

  echo "Step 12b: Enabling systemd services..."

  # Enable time synchronization
  sudo systemctl enable systemd-timesyncd

  # Enable NetworkManager if installed
  if check_command_is_installed NetworkManager; then
    sudo systemctl enable NetworkManager
  fi

  echo "Step 12c: Setting screenshot save location..."

  # Ensure screenshots directory exists
  mkdir -p "$SCREENSHOTS_DIR"

  echo "Step 12d: Setting up xorg configuration..."

  # Create basic .xinitrc if it doesn't exist
  if [[ ! -f "$HOME/.xinitrc" ]]; then
    echo "exec i3" >"$HOME/.xinitrc"
  fi

  echo "Step 12e: Setting zsh as default shell..."

  # Check if zsh is installed and set as default shell
  if command -v zsh >/dev/null 2>&1; then
    # Change default shell to zsh
    chsh -s "$(which zsh)"
    echo "Default shell changed to zsh. You may need to log out and back in for this to take effect."
  else
    echo "zsh is not installed. Skipping shell change."
  fi
  echo "Step 12: Finished setting Arch/i3wm settings!"
  echo "Note: Most i3wm settings are handled by your dotfiles configuration."
  echo "You may want to reboot after completing all steps."
}

print_manual_steps() {
  ############################
  # Manual steps             #
  ############################

  echo "Step 13: Manual steps to complete setup:"
  echo "Step 13a: Log into Github and register ssh keys"
  echo "Step 13b: Clone learning repo with SSH: cd \$XDG_CODE_HOME && git clone git@github.com:3ZsForInsomnia/learning.git"
  echo "Step 13c: Log into gh cli and retrieve hidden gists"
  echo "To do this, use gh to pull down your gist containing the list of hidden gists, and run \`handle_all_gists <file>\`"
  echo "Or alternatively, run the \`retrieve_hidden_gists\` function after setting up gh auth"
  echo "Step 13d: Install fonts manually (nerd fonts): pacman -S ttf-fira-code nerd-fonts-fira-code"
  echo "Step 13e: Install GUI applications via AUR/Flatpak as desired:"

  gui_apps=("obsidian" "google-chrome" "slack-desktop" "postman-bin" "copyq")
  echo "        Available in AUR:"
  echo_each_element "${gui_apps[@]}"

  echo ""
  echo "Step 13f: Set up display manager or configure startx"
  echo "Step 13g: Configure audio (pulseaudio/pipewire)"

  other_apps=("Lastpass" "Browser extensions" "Development tools specific to your workflow")
  echo "Step 13h: Log into each of these manually: "
  echo_each_element "${other_apps[@]}"
}

print_arch_steps() {
  ############################
  # Arch/i3wm Settings       #
  ############################

  echo "Step 14: Configure the following Arch/i3wm settings:"
  echo "Step 14a: Configure display settings (xrandr/arandr for multi-monitor)"
  echo "Step 14b: Set up input remapping (your dotfiles include input-remapper-2 config)"
  echo "Step 14c: Configure systemd user services (copyq, redshift services are in your dotfiles)"
  echo "Step 14d: Set up power management (tlp, powertop, or similar)"
  echo "Step 14e: Configure firewall (ufw or iptables)"
  echo "Step 14f: Set up backup solutions"
  echo "Step 14g: Test i3wm keybindings and adjust as needed"
  echo ""
  echo "Note: Your i3wm dotfiles should handle most theming, keybindings, and window management settings automatically."
}

############################
# Handle failures          #
############################

healthcheck() {
  did_anything_fail=0
  echo ""
  echo_on_verbose "Checking if all paths were properly created..."
  find_non_existent_paths "${paths_to_check[@]}"
  if ((${#NON_EXISTENT_PATHS[@]} > 0)); then
    echo "  These paths were not created: "
    echo_each_element "${NON_EXISTENT_PATHS[@]}"
    echo ""
    ((did_anything_fail++))
  else
    echo_on_success "  All paths were created successfully!"
  fi

  echo_on_verbose "Checking if essential commands are installed..."
  essential_commands=("pacman" "yay" "stow" "gh" "npm" "git" "zsh")
  for cmd in "${essential_commands[@]}"; do
    if check_command_is_installed "$cmd"; then
      echo_on_success "  $cmd is installed!"
    else
      echo "  $cmd is not installed!"
      echo ""
      ((did_anything_fail++))
    fi
  done

  echo_on_verbose "Checking if pacman packages are installed..."
  updated_pacman_packages=($(array_diff pacman_packages installed_applications))
  check_pacman_installed "${updated_pacman_packages[@]}"

  if ((${#PACMAN_FAILED_PACKAGES[@]} > 0)); then
    echo "  These pacman packages failed to install: "
    echo_each_element "${PACMAN_FAILED_PACKAGES[@]}"
    echo ""
    ((did_anything_fail++))
  else
    echo_on_success "  All pacman packages were installed successfully!"
  fi

  echo_on_verbose "Checking if AUR packages are installed..."
  check_aur_installed "${aur_packages[@]}"

  if ((${#AUR_FAILED_PACKAGES[@]} > 0)); then
    echo "  These AUR packages failed to install: "
    echo_each_element "${AUR_FAILED_PACKAGES[@]}"
    echo ""
    ((did_anything_fail++))
  else
    echo_on_success "  All AUR packages were installed successfully!"
  fi

  echo_on_verbose "Checking if npm packages are installed..."
  check_npm_installed "${npm_packages_to_install[@]}"
  if ((${#NPM_FAILED_PACKAGES[@]} > 0)); then
    echo "  These npm packages failed to install: "
    echo_each_element "${NPM_FAILED_PACKAGES[@]}"
    echo ""
    ((did_anything_fail++))
  else
    echo_on_success "  All Npm packages were installed successfully!"
  fi

  echo_on_verbose "Checking if Neovim installed..."
  if check_command_is_installed nvim; then
    echo_on_success "  Neovim is installed!"
  else
    echo "  Neovim is not installed!"
    echo ""
    ((did_anything_fail++))
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
      ((did_anything_fail++))
    fi

    echo_on_verbose "Checking if i3 config exists..."
    if check_if_file_or_folder_exists "$HOME/.config/i3/config"; then
      echo_on_success "    i3 config exists!"
    else
      echo "    i3 config does not exist!"
      echo ""
      ((did_anything_fail++))
    fi

    echo_on_verbose "Checking if dotfiles were unstowed..."
    find_non_existent_paths "${stowed_folder_locations[@]}"

    if ((${#NON_EXISTENT_PATHS[@]} > 0)); then
      echo "    These dotfile paths were not created: "
      echo_each_element "${NON_EXISTENT_PATHS[@]}"
      echo ""
      ((did_anything_fail++))
    else
      echo_on_success "    All dotfile paths were created successfully! Everything was unstowed"
    fi
  else
    echo "  Dotfiles repo does not exist!"
    echo ""
    ((did_anything_fail++))
  fi

  echo_on_verbose "Checking ssh keys..."
  for key_name in "${ssh_keys_to_create[@]}"; do
    # Convert key name to lowercase
    lower_case_key="${key_name,,}"

    # Initialize found_files array
    found_files=()

    # Find SSH files (bash-compatible way)
    shopt -s nullglob
    found_files=(~/.ssh/*"${lower_case_key}"*)
    shopt -u nullglob

    # Check number of matching files
    if ((${#found_files[@]} == 0)); then
      echo "    No SSH files found for ${key_name}."
      ((did_anything_fail++))
    elif ((${#found_files[@]} == 1)); then
      echo_on_success "    Found SSH file for ${key_name}: ${found_files[0]##*/}"
    else
      echo "    Multiple SSH files found for ${key_name}:"
      echo_each_element "${found_files[@]}"
      ((did_anything_fail++))
    fi
  done

  echo_on_verbose "Checking if basic Arch settings were configured..."

  current_timezone=$(timedatectl show --property=Timezone --value)
  if [[ "$current_timezone" == "$TIMEZONE" ]]; then
    echo_on_success "  Timezone is set correctly!"
  else
    echo "  Timezone is not set to $TIMEZONE (currently: $current_timezone)!"
    echo ""
    ((did_anything_fail++))
  fi

  if check_if_file_or_folder_exists "$HOME/.xinitrc"; then
    echo_on_success "  .xinitrc exists!"
  else
    echo "  .xinitrc does not exist!"
    echo ""
    ((did_anything_fail++))
  fi

  echo_on_verbose "Checking if zsh is the default shell..."
  current_shell=$(getent passwd "$USER" | cut -d: -f7)
  if [[ "$current_shell" == *"zsh" ]]; then
    echo_on_success "  Default shell is zsh!"
  else
    echo "  Default shell is not zsh (currently: $current_shell)!"
    echo ""
    ((did_anything_fail++))
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
  echo "Step 15: Running full health check..."

  healthcheck

  echo "Step 15: Finished checking for failed installations!"
}
