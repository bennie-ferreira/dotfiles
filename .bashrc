#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

eval "$(starship init bash)"
alias cat='bat --paging=never'

fcat() {
  local file="$1"
  local ext="${file##*.}"

  if [[ ! -f "$file" ]]; then
    echo "Arquivo não encontrado: $file"
    return 1
  fi

  case "$ext" in
    json)     jq . "$file" | bat --language=json ;;
    yml|yaml) yq . "$file" | bat --language=yaml ;;
    sh|bash)  shfmt "$file" | bat --language=bash ;;
    py)       black --quiet --code "$(cat "$file")" | bat --language=python ;;
    js)       prettier --parser babel "$file" | bat --language=javascript ;;
    ts)       prettier --parser typescript "$file" | bat --language=typescript ;;
    html)     prettier --parser html "$file" | bat --language=html ;;
    css)      prettier --parser css "$file" | bat --language=css ;;
    md|markdown) bat --language=markdown "$file" ;;
    toml)     taplo format "$file" | bat --language=toml ;;
    xml)      xmllint --format "$file" | bat --language=xml ;;
    rs)       rustfmt "$file" | bat --language=rust ;;
    go)       gofmt "$file" | bat --language=go ;;
    java)     bat --language=java "$file" ;; # Precisa de formatador à parte
    php)      php-cs-fixer fix "$file" --quiet && bat --language=php "$file" ;;
    *)        bat "$file" ;; # fallback: só mostrar com highlight
  esac
}
# bash_completion
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    source /usr/share/bash-completion/bash_completion

# FZF autocomplete para ctrl+R, ctrl+T, alt+C
[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash


# Mostrar ASCII art aleatória ao abrir o terminal
ASCII_DIR="$HOME/.config/asciiart"

if [ -d "$ASCII_DIR" ]; then
  FILE=$(find "$ASCII_DIR" -type f | shuf -n 1)
  [ -f "$FILE" ] && sh "$FILE"
fi
