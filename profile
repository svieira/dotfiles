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

case "$-" in *i*) if [ -r ~/.bashrc ]; then . ~/.bashrc; fi;; esac

# Load all the customizations
. $CONFIGDIR/shell-options
. $CONFIGDIR/environment
. $CONFIGDIR/bash_colors
. $CONFIGDIR/bash_completions
. $CONFIGDIR/aliases
. $CONFIGDIR/functions
. $CONFIGDIR/prompt
. $CONFIGDIR/tools

