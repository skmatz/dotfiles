bindkey "\ef" emacs-forward-word

bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "^[[3~" delete-char

bindkey -v

bindkey -M viins "jj" vi-cmd-mode

bindkey -M viins "^U" backward-kill-line
bindkey -M viins "^W" backward-kill-word
bindkey -M viins "^K" kill-line

fzf::branch() {
  git switch $(git branch -a | tr -d " " | fzf --height 100% --preview "git log --color=always {}" | head -n 1 | sed -e "s/^\*\s*//g" | perl -pe "s/remotes\/origin\///g")
}
zle -N fzf::branch
bindkey "^B" fzf::branch

fzf::cd() {
  local dir=$(fd --type directory | fzf --preview "tree {}")
  [[ -n "$dir" ]] && cd $dir
}
zle -N fzf::cd
bindkey "^T" fzf::cd

fzf::docker-remove-images() {
  local images="$(docker images | tail +2 | sort | fzf --multi | awk '{print $3}')"
  [[ -z "$images" ]] && return
  docker rmi $(echo $images | tr "\n" " ")
}

fzf::docker-run-container() {
  local image="$(docker images | tail +2 | sort | fzf | awk '{print $3}')"
  echo -n "command: "
  read command
  docker run -it --rm $image $command
}

fzf::history() {
  BUFFER=$(history -n -r 1 | fzf --no-sort +m --query "$LBUFFER")
  CURSOR=$#BUFFER
}
zle -N fzf::history
bindkey "^H" fzf::history

fzf::ghq() {
  cd $(ghq list -p | fzf --bind alt-j:preview-down,alt-k:preview-up --preview "glow --style dark {}/README.*")
}
zle -N fzf::ghq
bindkey "^G" fzf::ghq

fzf::ghq-vscode() {
  local dir=$(ghq list -p | fzf --bind alt-j:preview-down,alt-k:preview-up --preview "glow --style dark {}/README.*")
  [[ -n "$dir" ]] && code $dir
}
zle -N fzf::ghq-vscode
bindkey "^V" fzf::ghq-vscode

fzf::kill() {
  local pid=$(ps -fu "$UID" | sed 1d | fzf -m | awk '{print $2}')
  [[ -n "$pid" ]] && echo $pid | xargs kill -${1:-9}
}
zle -N fzf::kill
bindkey "^K" fzf::kill

fzf::open() {
  local file=$(fd --type file | fzf --bind alt-j:preview-down,alt-k:preview-up --preview "bat --color always --style header {}")
  [[ -n "$file" ]] && $EDITOR $file
}
zle -N fzf::open
bindkey "^O" fzf::open
