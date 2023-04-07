alias brewPack='rmrf Brewfile; brew bundle dump'
alias voltaPack='rmrf volta-requirements.txt; volta list --format=plain > volta-requirements.txt'
alias pip2Pack='rmrf pip2-requirements.txt; pip2 freeze > pip2-requirements.txt'
alias pip3Pack='rmrf pip3-requirements.txt; pip3 freeze > pip3-requirements.txt'
alias rubyPack='rmrf ruby-requirements.txt; gem list > ruby-requirements.txt'

alias brewInstall='brew bundle install'
alias pip2Install='pip2 install -r pip2-requirements.txt'
alias pip3Install='pip3 install -r pip3-requirements.txt'

alias savePackages='cd ~/src/dotfiles/packagers/; brewPack; voltaPack; pip2Pack; pip3Pack; rubyPack'
alias installPackages='cd ~/src/dotfiles/packagers/; brewInstall; pip2Install; pip3Install'

alias goToNvimPlugins='cd ~/.local/share/nvim/site/pack/packer/'
