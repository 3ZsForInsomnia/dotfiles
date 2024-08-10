alias cleanemb='emptyhere && rmrf bower_components/ && y cache clean && y'
alias cleanheren='emptyhere && n ci'
alias cleanherey='emptyhere && yin --frozen-lockfile'
alias emptyhere='rmrf $nmod'

alias version='cat package.json J ".version"'

s=start
b=build
w=watch
nmod=node_modules
plock=package-lock.json
ylock=yarn.lock

alias y='yarn'
alias yin='y install'
alias gfapuy='gupfa; yin'
alias yb='y $b'
alias yd='y dev'
alias yr='y run'
alias yrs='yr $s'
alias yw='y $w'
alias ys='y $s'
alias yt='y test'
alias yty='y typeCheck'
alias yspf='ys --prerender=false'
alias yl='y lint'
alias ybys='yb && ys'
alias ydev='y dev'
alias ylibd='y library:dev'
alias ystory='echo "no" | y storybook'
alias yan='y analyze'

alias n='npm'
alias ni='n i'
alias gfapun='gupfa; ni'
alias nis='ni --save'
alias nisd='ni --save-dev'
alias nr='n run'
alias nrb='nr build'
alias nrs='nr start'
# alias nrsl='isLocal=true nrs'
alias nrsl='nr startWithLocalConfig:watch'
alias nrt='nr test'
alias nrtw='nr test:watch'
alias nrl='nr lint'
alias nrlscss='nr lint:scss'
alias nrlall='nrl && nrlscss'
alias nrsto='nr storybook'
alias nw='nr watch'
alias nrno='nr nodemon:yalc'
alias nstory='nr storybook'
alias nrsass='n rebuild node-sass --force'

alias pn='pnpm'
alias pnd='pn dev'
alias pni='pn i'
alias pnc="pn changeset"
alias pncc="git add .; git commit -m \"Changeset\""
alias pnt='pn test'

# alias ngc='ng g c'
alias ngc='nx g c'
alias ngs='ng g service'
alias ngp='ng g pipe'
alias ngm='ng g module'

alias jup='jest --updateSnapshot'

alias lerb='lerna bootstrap'
lernadd() {
  eval 'lerna add $1 packages/$2'
}
lernadddev() {
  eval 'lerna add $1 packages/$2 --dev'
}

# alias yalp='yalc publish'
# alias yala='yalc add'
# alias yalr='yalc remove --all'

cra() {
  eval 'npx create-react-app $1 --typescript'
}

alias fgo='forego'
alias fgos='fgo start'
# watch $1=Folder $2=Extension
watch() {
  eval 'nodemon --exec "forego start" --watch $1 -e $2'
}

# countsByFileTypeForFE() {
#     # Line counts by file type
#     total=$(lineCountForFolder T -1 | xargs G "[0-9]"  C -d " " -f1)
#     ts=$(lineCount **/*.ts T -1 | xargs G "[0-9]" C -d " " -f1)
#     html=$(lineCount **/*.html T -1 | xargs G "[0-9]" C -d " " -f1)
#     css=$(lineCount **/*.scss T -1 | xargs G "[0-9]" C -d " " -f1)

#     # number of entities
#     components=$(grep "@Component" -r . | wc -l)
#     reducers=$(grep "createReducer(" -r . | wc -l)

#     echo "Total: ${total}\tTS: ${ts}\tHTML: ${html}\tCSS: ${css}\n"
#     echo "Components: ${components}\tReducers: ${reducers}"
# }

alias http='npx http-server'

alias noSlack='node ~/site-block.js email'
alias noFood='node ~/site-block.js seamless'
alias noChat='node ~/site-block.js socialMedia'

alias shadadd='npx shadcn-ui@latest add '
