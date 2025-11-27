source $ZSH_CONFIG_DIR/tools/zsh-defer/zsh-defer.plugin.zsh
source "$HOME/src/powerlevel10k/powerlevel10k.zsh-theme"
source "$ZSH_CONFIG_DIR/.p10k.zsh"
source "$ZSH_CONFIG_DIR/path-modifiers.zsh"
source "$ZSH_CONFIG_DIR/.env"
source "$HOME/.global-py/bin/activate"

source "$ZSH_CONFIG_DIR/tools/lazy-loading.zsh"
source "$ZSH_CONFIG_DIR/tools/compile-large-files.zsh"

export MY_ZSH_PLUGINS=(
  ["zsh-defer"]="romkatv/zsh-defer master zsh-defer.plugin.zsh"
  ["fast-syntax-highlight"]="zdharma-continuum/fast-syntax-highlighting master fast-syntax-highlighting.plugin.zsh"
  ["zsh-autosuggestions"]="zsh-users/zsh-autosuggestions master zsh-autosuggestions.zsh"
  # ["zsh-autocomplete"]="marlonrichert/zsh-autocomplete.git main fast-syntax-highlighting.plugin.zsh"
  ["zsh-you-should-use"]="MichaelAquilina/zsh-you-should-use master you-should-use.plugin.zsh"
  ["zshmarks"]="jocelynmallon/zshmarks master zshmarks.plugin.zsh"
  ["zsh-vi-mode"]="jeffreytse/zsh-vi-mode master zsh-vi-mode.plugin.zsh"
)

for package in "${(@k)MY_ZSH_PLUGINS}"; do
  local repo_info=("${(s: :)MY_ZSH_PLUGINS[$package]}")
  local file_to_source="${repo_info[3]}"
  zsh-defer source "$ZSH_CONFIG_DIR/tools/${package##*/}/$file_to_source"
done

zsh-defer setup_deferred_env
zsh-defer source "$ZSH_CONFIG_DIR/tools/reveal-alias.zsh"
zsh-defer source "$ZSH_CONFIG_DIR/tools/help/zh.zsh"
zsh-defer eval "$(zoxide init zsh)"
zsh-defer zsh_compile_with_cache

lazyload command "update-zsh-tools" "$ZSH_CONFIG_DIR/tools/update-zsh-tools.zsh" "Load zsh tools updater"

source "$ZSH_CONFIG_DIR/aliases/index.zsh"
