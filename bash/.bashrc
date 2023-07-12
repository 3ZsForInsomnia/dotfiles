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
source ~/work.sh

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
  alias cat='batcat'
fi
alias lua='lua-5.1'

alias c='clear'
alias rmrf='rm -rf'
alias cls='c; ls'

alias bashrc='v ~/src/dotfiles/.bashrc'
alias bashpro='v ~/src/dotfiles/.bash_profile'
alias vimrc='v ~/src/dotfiles/neovim/.config/nvim/init.lua'
alias zshrc='v ~/src/dotfiles/zsh/.zshrc'
alias wezrc='v ~/src/dotfiles/wezterm/.wezterm.lua'

alias rebash='source ~/.bashrc'
alias repro='source ~/.bash_profile'
alias rezsh='exec zsh'

alias unstow='stow --target=/Users/zachary/'
function unstowAll() {
  cd ~/src/dotfiles/
  for d in */ ; do
      unstow $d
  done
}
