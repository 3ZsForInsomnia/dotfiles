openNvim() {
  if [ -z $1 ]
  then
    nvim .
  else
    nvim $1
  fi
}
alias v='openNvim'

alias goToNvimPlugins='cd ~/.local/share/nvim/site/pack/packer/'

alias genTags='ctags -R --excmd=number'

alias aliases='cd ~/code/dotfiles; nvim'
# nvim -S ~/vim-sessions/.aliases.vim'

alias mux='tmux send-keys 'aliases' C-m \; split-window -h -p 70 \; send-keys 'v' C-m \; split-window -v -p 30 \;'
alias tux='tmux -u'
