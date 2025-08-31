#!/usr/bin/env zsh

# Simplified version using gh gist clone
clone_gist() {
    local gist_id=$1
    local destination_dir=$2
    
    # Check if gh command is available
    if ! command -v gh &>/dev/null; then
        echo "Error: gh CLI is not installed. Please install it from https://cli.github.com/."
        return 1
    fi
    
    # Validate arguments
    if [[ -z "$gist_id" ]]; then
        echo "Usage: clone_gist <gist_id> [destination_directory]"
        return 1
    fi
    
    # Set default destination if not provided
    local target_dir="${destination_dir:-$gist_id}"
    
    # Clone the gist
    if gh gist clone "$gist_id" "$target_dir"; then
        echo "Gist $gist_id successfully cloned to $target_dir"
        return 0
    else
        echo "Error: Failed to clone gist $gist_id"
        return 1
    fi
}

# Handle multiple gists from a file
# File format: one gist_id per line, or "gist_id destination_dir"
handle_all_gists_simple() {
    local file_path="$1"
    
    if [[ ! -f "$file_path" ]]; then
        echo "Error: File $file_path not found"
        return 1
    fi
    
    while IFS=' ' read -r gist_id destination_dir; do
        # Skip empty lines and comments
        [[ -z "$gist_id" || "$gist_id" =~ ^# ]] && continue
        
        clone_gist "$gist_id" "$destination_dir"
    done < "$file_path"
}

# Updated retrieve_hidden_gists function
retrieve_hidden_gists() {
    ############################
    # Retrieve hidden gists    #
    ############################
    
    echo "Retrieving hidden gists..."
    
    if ! command -v gh &>/dev/null; then
        echo "gh CLI is not installed. Please install it or manually place your gists to complete this step"
        return 1
    fi
    
    if [[ ! -f "$HOME/hidden-gists.txt" ]]; then
        echo "The hidden gists file does not exist. Please create it and run this script again."
        echo "It must live at \"$HOME/hidden-gists.txt\""
        return 1
    fi
    
    # Create a directory for all gists if it doesn't exist
    mkdir -p "$HOME/.config/gists"
    cd "$HOME/.config/gists"
    
    handle_all_gists_simple "$HOME/hidden-gists.txt"
    
    echo "Finished retrieving hidden gists!"
    cd "$HOME"
}