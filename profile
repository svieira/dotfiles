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
# Append to history file
shopt -s histappend
# Save multi-line commands as one line
shopt -s cmdhist
# reedit a history substitution line if it failed
shopt -s histreedit
# edit a recalled history line before executing
shopt -s histverify

# Load all the customizations
. $CONFIGDIR/environment
. $CONFIGDIR/bash_colors
. $CONFIGDIR/bash_completions
. $CONFIGDIR/aliases
. $CONFIGDIR/functions
. $CONFIGDIR/prompt

. /usr/local/opt/nvm/nvm.sh
. /usr/local/bin/virtualenvwrapper_lazy.sh


