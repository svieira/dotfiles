tap "homebrew/bundle"

brew "bash"
brew "bash-completion@2"
brew "coreutils"
brew "gawk"
brew "findutils"
brew "gnu-sed"
brew "grep"
brew "moreutils"

brew "git"
brew "netcat"

brew "fd"
brew "fzf"
brew "jq"
brew "nvm"
brew "inetutils"
brew "oath-toolkit"
brew "pandoc"
brew "pip-completion"
brew "pipx"
brew "pyenv"
brew "pyenv-virtualenv"
brew "pngpaste"
brew "ripgrep"
brew "rlwrap"
brew "rustup"
brew "terminal-notifier"
brew "tesseract"
brew "tree"
brew "vcprompt"
brew "vim"
brew "wget"
brew "xh"
brew "xsv"
brew "yarn"
brew "yarn-completion"

brew "ammonite-repl"
brew "pipx"
brew "dive"

# file "~/dotfiles/local/Brewfile.local"
# See https://github.com/Homebrew/homebrew-bundle/issues/521#issuecomment-509023309 for why
# We have to do this and not the more sensible thing
instance_eval(begin File.read("#{ENV["HOME"]}/dotfiles/local/Brewfile.local") rescue "" end)
