#!/usr/bin/env bash

function setup_linux {
  echo "Configuring (Linux)brew..."
  (echo; echo "eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)") >> ~/.zprofile
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  sudo apt install -y build-essential
}

function setup_mac {
  echo "Upgrading bash..."
  brew install bash
  bash_path="$(which bash)"
  echo "${bash_path}" | sudo tee /etc/shells > /dev/null
}

# Use homebrew on both linux and mac
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

case "${OS}" in
  Linux*) setup_linux;;
  Mac*) setup_mac;;
esac