alias :q='exit'
alias q='exit'

alias ..='cd ../'
alias ...='..; ..;'
alias ....='..; ..; ..;'
alias ~='cd ~'
alias sudo='sudo '
alias addcreds='ssh-add -K'

alias c='clear'
alias rmrf='rm -rf'
alias cls='c; ls'

if [[ "$MY_SYSTEM" == "mac" ]]; then
  alias cat='bat'
elif [[ "$MY_SYSTEM" == "linux" ]]; then
  alias cat='bat'
fi

alias src='j src'
alias dots='j dots && v'
alias shots='j shots'
alias shared='j shared'
alias notes='j notes && v'

alias bashrc='v ~/code/dotfiles/.bashrc'
alias bashpro='v ~/code/dotfiles/.bash_profile'
alias vimrc='v ~/code/dotfiles/neovim/.config/nvim/init.lua'
alias zshrc='v ~/code/dotfiles/zsh/.zshrc'
alias alarc='v ~/code/dotfiles/alacritty/.config/alacritty/alacritty.toml'
# alias wezrc='v ~/code/dotfiles/wezterm/.wezterm.lua'

alias rebash='source ~/.bashrc'
alias repro='source ~/.bash_profile'
alias rezsh='exec zsh'

function wttr() {
  curl "wttr.in/$MY_LOCATION?u"
}
function wttr1() {
  curl "wttr.in/$MY_LOCATION?1"
}
function wttr3() {
  curl "wttr.in/$MY_LOCATION?3&u"
}
function wttrpng() {
  curl "wttr.in/$MY_LOCATION.png?u" >"$HOME/Downloads/wttr.png" && open "$HOME/Downloads/wttr.png"
}

function fup() {
  result=$(fuckitup -f "$@")
  echo "$result" PC
  echo "$result"
}
function fupc() {
  result=$(fuckitup -c "$@")
  echo "$result" PC
  echo "$result"
}

alias oreg='o https://regex101.com'
alias gogh='bash -c "$(curl -sLo- https://git.io/vQgMr)"'
alias ogogh='o http://mayccoll.github.io/Gogh/'

alias lpa='lpass'
alias lpas='lpa show --password'

# Neccessary as http-server (npx library) asserts its alias as http, which httpie uses
alias http='/opt/homebrew/bin/http' # This is httpie's script
alias http-server='$HOME/.npm/_npx/e5196fa6dc3cecbc/node_modules/.bin/http-server'

alias img='wezterm imgcat '

alias lzd="lazydocker"

alias rss='newsboat;'

alias unstow='stow --target=$HOME'
function unstowAll() {
  cd "$HOME/code/dotfiles/"

  for d in */; do
    unstow "$d"
  done
}

# alias mutt='neomutt'
# alias ms='mailsync; notmuch new; mutt; mailsync &'

# alias scon="/Applications/SelfControl.app/Contents/MacOS/selfcontrol-cli --uid $(id -u $(whoami))"
# alias scon="/Applications/SelfControl.app/Contents/MacOS/org.eyebeam.SelfControl $(id -u $(whoami)) --install"
# function selfControlBlock() {
#   if [[ -z "$1" ]]; then
#     block="socialMedia"
#   else
#     block=$1
#   fi
#
#   if [[ -z "$2" ]]; then
#     t="26"
#   else
#     t=$2
#   fi
#
#   d="$(date -v+"$t"M -u "+%Y-%m-%d %H:%M:%S")"
#   l="$SELFCONTROL_BLOCKLISTS$block.selfcontrol"
#   # scon start --blocklist "$l" --enddate "$d"
#   scon "$l" "$d"
# }
# alias scos="selfControlBlock"

# alias noSlack='node ~/site-block.js email'
# alias noFood='node ~/site-block.js seamless'
# alias noChat='node ~/site-block.js socialMedia'

# alias lux="luxafor"

# alias bright='brightnessctl s '

# alias alacreate='alacritty msg create-window '
