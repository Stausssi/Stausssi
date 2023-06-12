export ZSH="$HOME/.oh-my-zsh"
export PATH="$(brew --prefix)/opt/gnu-sed/libexec/gnubin:$PATH"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
command -v jenv >/dev/null || export PATH="$HOME/.jenv/bin:$PATH"

export EDITOR=nano
. "$HOME/.cargo/env"
export GPG_TTY=$(tty)
export SUMMON_PROVIDER="gopass-summon-provider"

# Python
export PYENV_ROOT="$HOME/.pyenv"
export WORKON_HOME="$HOME/.virtualenvs"
