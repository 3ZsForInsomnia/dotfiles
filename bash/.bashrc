export VISUAL=nvim
export EDITOR="$VISUAL"

source ~/.dash-g-aliases.sh
source ~/.bash_profile
source ~/.utils.sh
source ~/.nvim-tmux-etc.sh

alias sudo='sudo '
alias addcreds='ssh-add -K'
alias getclip='pbpaste'
alias setclip='pbcopy'

alias :q='exit'
alias q='exit'
alias ls='exa -lahUFm --git -I ".git" --icons'
alias lsg='ls G'
alias lsr='exa -lahRGFUm --git -I ".git"--icons'
alias lsd='exa -lahD --icons -I ".git"' 
alias c='clear'
alias rmrf='rm -rf'
alias cls='c; lss'
alias cdls='../ && lss'

alias bashrc='v ~/src/dotfiles/.bashrc'
alias bashpro='v ~/src/dotfiles/.bash_profile'
alias vimrc='v ~/src/dotfiles/neovim/.config/nvim/'
alias zshrc='v ~/src/dotfiles/zsh/.zshrc'
alias tmuxrc='v ~/src/dotfiles/tmux/.tmux.conf'
alias wezrc='v ~/src/dotfiles/iterm2/.wezterm.lua'

alias rebash='source ~/.bashrc'
alias repro='source ~/.bash_profile'
alias rezsh='exec zsh'

alias unstow='stow --target=/Users/zachary.levine/'
function unstowAll() {
  cd ~/src/dotfiles/
  for d in */ ; do
      unstow $d
  done
}
