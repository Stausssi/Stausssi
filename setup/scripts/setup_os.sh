#!/usr/bin/env bash

log_file="logs/setup_os.log"

function setup_linux {
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  echo "Installing build essentials"
  # shellcheck disable=SC2024
  sudo apt install -y build-essential &> "${log_file}"
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

echo "Installing GNUPG (might take some time)..."
brew install gnupg &> "${log_file}"
