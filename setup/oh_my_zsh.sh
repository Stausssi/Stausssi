#!/usr/bin/env bash

cd

function install_zsh_linux {
  sudo apt install zsh -y
}

function install_zsh_mac {
  if ! command -v brew; then
    echo "Installing Homebrew first"

  fi

  brew install zsh
}

echo "Setting up Oh My Zsh..."
if ! command -v zsh; then
  echo "Installing ZSH"
  case "$OS" in
    Linux*) install_zsh_linux;;
    Mac*) install_zsh_mac;;
  esac
fi

if [[ "${SHELL}" =~ .*"zsh".* ]]; then
  echo "ZSH is already default"
else
  echo "Setting ZSH as default"
  chsh -s "$(which zsh)"
  echo "Restart the terminal and start the setup again to continue!"
  exit 2
fi

sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Configuring .zshrc"
cp ./.zshrc ~/.zshrc.test

# TODO: Activate script
