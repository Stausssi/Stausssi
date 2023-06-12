export ZSH="$HOME/.oh-my-zsh"
export EDITOR=nano
. "$HOME/.cargo/env"
export GPG_TTY=$(tty)
export SUMMON_PROVIDER="gopass-summon-provider"

# Python
export PYENV_ROOT="$HOME/.pyenv"
export WORKON_HOME="$HOME/.virtualenvs"

# Path
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$HOME/.jenv/bin:$PATH"
