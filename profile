# vim: set filetype=sh :
# If not running interactively, don't do anything
[ -z "$PS1" ] && return
fd=0   # stdin
if ! [[ -t "$fd" || -p /dev/stdin ]]; then
   return
fi

# Set configdir to be ~/dotfiles unless overridden
export CONFIGDIR=${CONFIGDIR:-$HOME/dotfiles};
if [ ! -d "$CONFIGDIR" ]; then
  echo "Missing $CONFIGDIR. Please install from GitHub."
fi

case "$-" in *i*) if [ -r ~/.bashrc ]; then . ~/.bashrc; fi;; esac

# Where should local configuration be loaded from?
# By default it is the git-ignored local/ directory
# under this folder (e. g. dotfiles)
export LOCAL_CONFIG_DIR=${LOCAL_CONFIG_DIR:-$CONFIGDIR/local}

# Try to load the local file first - if it doesn't exist
# load the default one.  The local config file should load
# the default configuration file at whatever point makes most
# sense for it (first, and then override, set defaults and then load,
# or something in-between).
load-file() {
  local filename="$1"
  local filepath="$LOCAL_CONFIG_DIR/$filename"
  if [ -f "$filepath" -o -L "$filepath" ]; then
    . "$filepath"
  else
    . "$CONFIGDIR/$filename"
  fi
}

# Give local configs an easy way to load their global file:
# load-global-config "$BASH_SOURCE"
load-global-config() {
  local filename="${1##*/}"
  if [ -z "$filename" ]; then
    echo >&2 "Filename must be provided"
    return 1;
  fi
  . "$CONFIGDIR/$filename"
}

# Load all the customizations
load-file shell-options
load-file environment
load-file bash_colors
load-file bash_completions
load-file aliases
load-file functions
load-file prompt
load-file tools

# Remove unnecessary functions after setup
unset -f load-file
unset -f load-global-config

