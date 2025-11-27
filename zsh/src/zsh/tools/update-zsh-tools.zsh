function update_zsh_tools() {
  if [[ ! -d "zsh/src/zsh/tools" ]]; then
      if [[ -d "$HOME/src/dotfiles/zsh/src/zsh/tools" ]]; then
          cd "$HOME/src/dotfiles" || {
              echo "Error: Could not change to dotfiles directory"
              exit 1
          }
      fi
  fi

  TOOLS_PREFIX="zsh/src/zsh/tools"

  add_subtree() {
      local name="$1"
      local repo_url="https://github.com/${$MY_ZSH_PLUGINS[$name]% *}"
      local branch="${$MY_ZSH_PLUGINS[$name]##* }"

      echo "Adding subtree: $name"
      git subtree add --prefix="$TOOLS_PREFIX/$name" "$repo_url" "$branch" --squash
  }

  update_subtree() {
      local name="$1"
      local repo_url="https://github.com/${$MY_ZSH_PLUGINS[$name]% *}"
      local branch="${$MY_ZSH_PLUGINS[$name]##* }"

      echo "Updating subtree: $name"
      git subtree pull --prefix="$TOOLS_PREFIX/$name" "$repo_url" "$branch" --squash
  }

  case "${1:-}" in
      init)
          echo "Initializing zsh tool subtrees..."
          for package in "${(@k)$MY_ZSH_PLUGINS}"; do
              if [[ ! -d "$TOOLS_PREFIX/$package" ]]; then
                  add_subtree "$package"
              else
                  echo "Skipping $package (already exists)"
              fi
          done
          ;;
      update)
          echo "Updating zsh tool subtrees..."
          for package in "${(@k)$MY_ZSH_PLUGINS}"; do
              if [[ -d "$TOOLS_PREFIX/$package" ]]; then
                  update_subtree "$package"
              else
                  echo "Adding missing subtree: $package"
                  add_subtree "$package"
              fi
          done

          # Squash all updates into single commit
          if git diff --cached --quiet; then
              echo "No changes to commit"
          else
              git commit -m "Update zsh dependencies"
          fi
          ;;
      *)
          echo "Usage: $0 {init|update}"
          echo "  init   - Add git subtrees for all zsh tools"
          echo "  update - Update all subtrees and commit changes"
          exit 1
          ;;
  esac
}
