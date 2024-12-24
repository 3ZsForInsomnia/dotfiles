source ~/.bash_profile

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
alias alarc='v ~/code/dotfiles/alacritty/.config/alacritty/alacritty.toml'
# alias wezrc='v ~/code/dotfiles/wezterm/.wezterm.lua'

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
