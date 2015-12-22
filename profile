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
  echo "Missing $HOME/dotfiles. Please install from GitHub."
fi

export XDG_CONFIG_HOME=$CONFIGDIR

case "$-" in *i*) if [ -r ~/.bashrc ]; then . ~/.bashrc; fi;; esac

# Recursive globbing, e.g. `echo **/*.txt`
# Spelling corrections on CD
# Spelling corrections on word-completion for directories
shopt -s globstar cdspell dirspell

# Load all the things we want and need
. $CONFIGDIR/environment
. $CONFIGDIR/bash_colors
. $CONFIGDIR/bash_completions
. $CONFIGDIR/aliases
. $CONFIGDIR/functions

. `brew --prefix nvm`/nvm.sh
. /usr/local/bin/virtualenvwrapper_lazy.sh

_vc_status() {
    vcprompt -t 200 -f " on %n:%b (%r) %m%u"
}

export PS1="\n{\j} [\!] \u@\[$Yellow\]\h\[$Color_Off\] in \[$Cyan\]\W\[$Color_Off\]\${VIRTUAL_ENV:+ with }\[$Blue\]\${VIRTUAL_ENV##*/}\[$Color_Off\]\[$Green\]\$(_vc_status)\[$Color_Off\]\n\$ "

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
    for venv in $PIPSI_HOME/*; do
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
