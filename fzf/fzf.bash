# Setup fzf
# ---------
if [[ ! "$PATH" == *$PACKAGE_MANAGER_PREFIX/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}$PACKAGE_MANAGER_PREFIX/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$PACKAGE_MANAGER_PREFIX/opt/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "$PACKAGE_MANAGER_PREFIX/opt/fzf/shell/key-bindings.bash"
