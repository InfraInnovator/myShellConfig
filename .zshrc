# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"


# macOS-specific configurations
if [[ "$OSTYPE" == "darwin"* ]]; then
    plugins=(zsh-autosuggestions zsh-syntax-highlighting zsh-completions 1password catimg command-not-found git copyfile copypath direnv nmap starship web-search macos aliases docker docker-compose iterm2)
fi
# Linux-specific configurations
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    plugins=(zsh-autosuggestions zsh-syntax-highlighting zsh-completions 1password catimg command-not-found git copyfile copypath direnv nmap starship web-search docker docker-compose)
fi

# SSH-specific configurations
if [[ -n $SSH_CONNECTION ]]; then
    plugins=(zsh-autosuggestions zsh-syntax-highlighting zsh-completions 1password catimg command-not-found git direnv nmap starship docker docker-compose)
fi

source $ZSH/oh-my-zsh.sh


####################
# User configuration
####################

autoload -Uz compinit
compinit
bindkey "^I" expand-or-complete

# macOS Specific:
if command -v pyenv 1>/dev/null 2>&1; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi
export PATH="$HOME/bin:$PATH"


# macOS-specific configurations
if [[ "$OSTYPE" == "darwin"* ]]; then
  test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
  export PATH="/usr/local/opt/mysql-client/bin:$PATH"
  alias rm_ds='find ./ -name ".DS_Store*" -type f -delete'
  # alias o='open .'

  function updatebrew() {
      brew update && brew upgrade && brew cleanup
  }

  function o() {
    open "$@"
  }

  function cdf() {
    target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
    if [ "$target" != "" ]; then
      cd "$target"; pwd
    else
      echo 'No Finder window found' >&2
    fi
  }

  ssfull() {
      screencapture -x "$1"
  }

  ssselect() {
      screencapture -s "$1"
  }

  ssclipboard() {
      screencapture -c "$1"
  }

  export AWS_PAGER=""
  export EDITOR='subl'
  export VISUAL='code'

  #Fix for content types - was breaking sed
  export LC_CTYPE=C
  export LANG=C

fi

# Linux-specific configurations
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  export EDITOR='nano'
  export VISUAL='nano'

  function update() {
      sudo apt update && sudo apt upgrade -y
  }
fi

# SSH-specific configurations
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
fi


# General Aliases
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias l='ls'
alias ll='ls -lah'
alias lll='function _blah(){ ls -lah $@ | lolcat; };_blah'

alias h='history'
alias hh='history 1'

alias c='clear'
alias p='pwd'

alias mkpyenv='python -m venv ./ ; source bin/activate'

alias dus='du -hd 1 ./ | sort -h'
alias ytdl='yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"'

# Git Aliases
alias gs='git status'

function duh() {
    CMD="du -hd ${1:-1} | sort -rh"
    echo "Executing: $CMD"
    eval $CMD
}

function backup() {
    [[ -f "$1" ]] && cp "$1" "$1.bak"
}

function psg() {
    ps aux | grep "$1" | grep -v grep
}

function mkcd() {
    mkdir -p "$1" && cd "$1"
}

function myip() {
    curl http://ipecho.net/plain; echo
}

function countfiles() {
    echo $(ls -1A | wc -l)
}

function largest() {
    du -ah . | sort -rh | head -10
}

function connections() {
    netstat -an | grep ESTABLISHED
}

function connections_listening() {
    netstat -an | grep LISTEN
}

function watchit() {
    while true; do
        clear
        "$@"
        sleep 2
    done
}

function fsearch() {
    local file
    file=$(find . -type f | fzf --preview 'bat --color "always" {}')
    [[ -n $file ]] && echo $file
}

function weather() {
    local city="${1:-Reading,PA}"
    curl -4 wttr.in/"${city}"
}


# Check for direnv and enable if available
if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
else
    echo "direnv not found. Consider installing it if you rely on its functionality."
fi

# Start ssh-agent if not running
if ! pgrep ssh-agent > /dev/null; then
    eval $(ssh-agent -s)
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
