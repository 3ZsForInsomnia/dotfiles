if [[ $(uname) == "Darwin" ]]; then
  export MY_SYSTEM="mac"
elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
  export MY_SYSTEM="linux"
fi

export FZF_DEFAULT_COMMAND='fd -H --type f'
export FZF_DEFAULT_OPTS='--height 80% --layout=reverse --border --bind "ctrl-d:preview-down" --bind "ctrl-u:preview-up"'
export VISUAL=nvim
export EDITOR="$VISUAL"

source ~/.dash-g-aliases.sh
source ~/.bash_profile
source ~/.utils.sh
source ~/.nvim-tmux-etc.sh
source ~/.java.sh

alias ..='cd ../'
alias ...='..; ..;'
alias ....='..; ..; ..;'
alias ~='cd ~'
alias sudo='sudo '
alias addcreds='ssh-add -K'

alias :q='exit'
alias q='exit'

if [[ "$MY_SYSTEM" == "mac" ]]; then
  alias cat='bat'
elif [[ "$MY_SYSTEM" == "linux" ]]; then
  alias cat='bat'
fi
alias lua='lua-5.1'

alias c='clear'
alias rmrf='rm -rf'
alias cls='c; ls'

alias bashrc='v ~/code/dotfiles/.bashrc'
alias bashpro='v ~/code/dotfiles/.bash_profile'
alias vimrc='v ~/code/dotfiles/neovim/.config/nvim/init.lua'
alias zshrc='v ~/code/dotfiles/zsh/.zshrc'
alias wezrc='v ~/code/dotfiles/wezterm/.wezterm.lua'

alias rebash='source ~/.bashrc'
alias repro='source ~/.bash_profile'
alias rezsh='exec zsh'

alias unstow='stow --target=$HOME'
function unstowAll() {
  cd ~/code/dotfiles/
  for d in */; do
    unstow $d
  done
}

function default() {
  if [[ -z "$1" ]]; then
    echo "$2"
  else
    echo "$1"
  fi
}
. "$HOME/.cargo/env"
