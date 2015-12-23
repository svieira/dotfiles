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

# Load all the customizations
. $CONFIGDIR/environment
. $CONFIGDIR/bash_colors
. $CONFIGDIR/bash_completions
. $CONFIGDIR/aliases
. $CONFIGDIR/functions

. `brew --prefix nvm`/nvm.sh
. /usr/local/bin/virtualenvwrapper_lazy.sh

_vc_status() {
    vcprompt -t ${VCPROMPT_TIMEOUT:-200} -f " on %n:%b (%r) %m%u"
}

export PS1="\n{\j} [\!] \u@\[$Yellow\]\h\[$Color_Off\] in \[$Cyan\]\W\[$Color_Off\]\${VIRTUAL_ENV:+ with }\[$Blue\]\${VIRTUAL_ENV##*/}\[$Color_Off\]\[$Green\]\$(_vc_status)\[$Color_Off\]\n\$ "

