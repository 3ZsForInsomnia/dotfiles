#!/usr/bin/env zsh

# FZF Helpers - Common configurations and utility functions
# Preview functions have been moved to $ZSH_PREVIEWS_DIR for better subshell compatibility

### Universal FZF Configuration

# Set universal FZF defaults
export FZF_DEFAULT_OPTS="
  --multi
  --ansi
  --height=70%
  --border=rounded
  --preview-window=right:60%:wrap
  --bind='alt-p:toggle-preview'
  --bind='alt-v:execute(nvim {+})'
  --bind='alt-o:execute(open {+})'
  --bind='alt-y:execute(echo {+} | tr \" \" \"\n\" | pbcopy)'
  --bind='ctrl-s:execute(_fzf_inspect {})'
"

# History search configuration (keeps chronological order)
export FZF_CTRL_R_OPTS="--reverse --no-sort"

### Utility Functions

# Standard FZF options for different contexts
function fzf_git_opts() {
  echo "--reverse --ansi --height=70% --border=rounded --preview-window=right:65%:wrap"
}

function fzf_file_opts() {
  echo "--multi --ansi --height=70% --border=rounded --preview-window=right:60%:wrap"
}

function fzf_select_opts() {
  echo "--height=40% --border --reverse"
}
