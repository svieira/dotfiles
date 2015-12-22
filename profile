# Ideas sourced from:
# * https://github.com/brandon-rhodes/homedir
# * https://github.com/mitsuhiko/dotfiles
# * https://github.com/mathiasbynens/dotfiles
# * https://github.com/fredsmith/dotfiles
# (Among others)

# If not running interactively, don't do anything
[ -z "$PS1" ] && return
fd=0   # stdin
if ! [[ -t "$fd" || -p /dev/stdin ]]; then
   return
fi

# set configdir to be ~/dotfiles
export CONFIGDIR=$HOME;
if [ -d $HOME/dotfiles ]; then
  export CONFIGDIR="$HOME/dotfiles";
else
  export CONFIGDIR="$HOME/dotfiles";
  git clone https://github.com/svieira/dotfiles $CONFIGDIR
  mv ~/.bashrc ~/.bashrc.old
  ln -s $CONFIGDIR/bashrc ~/.bashrc
  mv ~/.profile ~/.profile.old
  ln -s $CONFIGDIR/profile ~/.profile
  mv ~/.inputrc ~/.inputrc.old
  ln -s $CONFIGDIR/inputrc ~/.inputrc
  . ~/.bashrc
fi

export XDG_CONFIG_HOME=$CONFIGDIR
COMMENT


if [ -r ~/.profile ]; then . ~/.profile; fi
case "$-" in *i*) if [ -r ~/.bashrc ]; then . ~/.bashrc; fi;; esac

# Recursive globbing, e.g. `echo **/*.txt`
# Spelling corrections on CD
# Spelling corrections on word-completion for directories
shopt -s globstar cdspell dirspell

export PATH
_P=/usr/local
_O=$_P/opt
_B=$(brew --prefix)
PATH="~/.local/bin:$_P/bin:$_P/sbin:$_O/ruby/bin:$_O/python3/bin:$PATH"

if [ -f $_B/share/bash-completion/bash_completion ]; then
    . $_B/share/bash-completion/bash_completion
fi
complete -C aws_completer aws

if [ -f ~/.bash_colors ]; then
    . ~/.bash_colors
fi

_vc_status() {
    vcprompt -t 200 -f " on %n:%b (%r) %m%u"
}

## Environment Variables

export PS1="\n{\j} [\!] \u in \[$Yellow\]\W\[$Color_Off\]\${VIRTUAL_ENV:+ with }\[$Blue\]\${VIRTUAL_ENV##*/}\[$Color_Off\]\[$Green\]\$(_vc_status)\[$Color_Off\]\n\$ "

# Since we are handling the virtual environment information ourselves lets disable the status
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Ignore both leading space commands and duplicates
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=500000
export HISTFILESIZE=500000
export EDITOR=vim

# A better, reasonably fast, less
# Case insensitive search unless the search term has uppers in it
# Put the found search term at the 49% point on the screen
# Output color escape codes raw to the terminal (show colors by default)
export LESS="-i -j.49 -R"

# Grep is better in color
export GREP_OPTIONS='--color=auto'

# Prefer US English and use UTF-8
export LANG="en_US.UTF-8";
export LC_ALL="en_US.UTF-8";

# `cd` shortcuts via http://unix.stackexchange.com/q/1469/5217
export CDPATH=~/.local/opt/cdpath

# Node Version Management
export NVM_DIR=~/.local/opt/.nvm
. `brew --prefix nvm`/nvm.sh

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_66.jdk/Contents/Home/

export PGDATA=/usr/local/var/postgres
export PGDATABASE=ingo
export PGUSER=ingouser

export HOMEBREW_GITHUB_API_TOKEN='41eb07094869fc61b3f473f6f36963a9244342cd'
export SBT_OPTS='-Xmx1G -Xss4M -XX:+CMSClassUnloadingEnabled'

export WORKON_HOME=~/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=python3

. /usr/local/bin/virtualenvwrapper_lazy.sh

export LIQUIBASE_HOME=`brew --prefix liquibase`/libexec

export INGO_AWS_KEYPATH=~/.ssh/ingo.global
export INGO_LOGBACK_CONFIG_PATH=file:/Users/sean/Documents/Development/logback.config.xml
export TOTP_SEED_PATH=~/.config/totp.conf

## Alias Definitions

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias serve='python3 -m http.server'

# Remove any and all target directories from the descendents of this directory
# to ensure that everything works when re-built
# Needed when SBT does foolish things (see http://stackoverflow.com/q/4483230/135978)
alias cleanjvmbuild='find . -name target -type d -exec rm -rf {} \;'

# Some useful voice shortcuts for OS X
alias robotic="say -v Trinoids"
alias cultivated="say -v Daniel"
alias lilt="say -v Fiona"

# ES6 with node >= 0.11
alias es6='node --use-strict $(node --v8-options | grep harm | awk '"'"'{print $1}'"'"' | xargs)'

# Find this machine's external IP
alias external_ip='dig +short myip.opendns.com @resolver1.opendns.com'

## Function definitions

# Set the terminal emulator's title
title() {
    echo -ne "\033]0;"$*"\007"
}

# Simpler ssh tunnels
# tunnel some.host:8080 :9090
# tunnel another.host:5000 local.dev.host:8080
tunnel() {
    local remoteHost=${1/:*/}
    local remotePort=${1/*:/}
    local localHost=${2/:*/}
    local localPort=${2/*:/}

    localHost=${localHost:-localhost}
    echo "Mapping $remoteHost:$remotePort to $localHost:$localPort"

    ssh -N -L $localPort:${localHost}:$remotePort $remoteHost
}

current_date() {
    date +${1:-%Y-%m-%d}
}

current_time() {
    date +${1:-%H:%M:%S}
}

notify() {
  [[ $# -eq 0 ]] && echo "notify icon [title] message [terminal-notifier-args]" && return 0
  icon=$1
  title=$2
  message=$3
  if [[ -z $message ]]; then
    message=$title
    title=$icon
  fi
  [[ ! "$icon" =~ ^(~|/) ]] && icon=~/Pictures/icons/$icon
  [[ ! "$icon" =~ \.png$ ]] && icon=${icon}.png
  terminal-notifier -message "$message" -title "$title" -appIcon "$icon" "${@:4}"
}

# assign variableName command --string here
# echo $variableName
# Via http://stackoverflow.com/a/21636953/135978
assign() {
    local var=$1; shift;
    local channel=/tmp/assignfifo-${BASH_PID}-${BASH_SUBSHELL}
    mkfifo $channel
    exec 3<> $channel
    "$@" 1>&3
    local result=$?
    if [[ $result -eq 0 ]];
        then read -u3 ${var}
    fi
    exec 3>&-
    rm $channel
    return $result
}

# Save a few keystrokes
docker-startup() {
    boot2docker start
    # Disable assign for now until I make it more robust
    # assign DOCKER_HOST boot2docker shellinit
    # export DOCKER_HOST=${DOCKER_HOST##*=}
    export DOCKER_CERT_PATH=/Users/sean/.docker/boot2docker-vm
    export DOCKER_HOST=tcp://192.168.59.103:2376
    export DOCKER_TLS_VERIFY=1
}

docker-shutdown() {
    boot2docker stop
}


# Get the absolute path of a file or directory
# Via: http://stackoverflow.com/a/23002317/135978
abspath() {
   # $1 : relative filename
   if [ -d "$1" ]; then
     # dir
     echo $(cd "$1"; pwd)
   elif [ -f "$1" ]; then
     # file
     if [[ $1 == */* ]]; then
       echo $(cd "${1%/*}"; pwd)/${1##*/}
     else
       echo $(pwd)/$1
     fi
   fi
}

# Bookmark a directory so you can `cd {bookmark-name}` to it from anywhere
bmd() {
  local directory=`abspath ${1:-.}`
  local bookmark_name=${2:-${directory##*/}}
  ln -si $directory $CDPATH/$bookmark_name
}

# For those times when you need to wrap `set -e` around just *one* command.
try-or-fail() {
  $@
  local status=$?
  [ $status -ne 0 ] && echo "Failed to execute $@" && exit $status
}

confirm() {
    local msg=${1:-Are you sure}
    local choice=
    read -r -n 1 -p "$msg [y/N]? " choice
    echo
    case "$choice" in
      y*|Y* ) return 0;;
      * ) return 1;;
    esac
}

pause() {
  local ignored
  read -s -r -p "Press any key to continue..." -n 1 ignored
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
# VIA: https://github.com/mathiasbynens/dotfiles/blob/287f38e2196d8367cf2cb33b6f75860dbf17492a/.functions#L240-246
tre() {
    tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
}

# history with grep
#
# history list
# history <filter> greped history
# Taken from humanism.sh
history() {
    if [ $# -eq 0 ]; then
      builtin history
    else
      builtin history | grep $@
    fi
}

update() {
    brew update && brew upgrade --all
    for venv in ~/.local/venvs/*; do
        echo Upgrading pip in $venv
        . $venv/bin/activate && pip install --upgrade pip && deactivate
    done
    pipsi upgrade pipsi
    for package in $(pipsi list | sed -ne 's/^.*Package "\(.*\)".*/\1/p' | grep -v pipsi); do
        echo pipsi upgrade "$package"
        pipsi upgrade "$package"
    done
    if [[ "$1" == "--all" ]]; then
        boot2docker upgrade
        sudo softwareupdate --list
    fi
}
