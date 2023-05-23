#!/usr/bin/env bash

log_file="logs/setup_os.log"

function setup_linux {
  if [[ -n ${configure_brew} ]]; then
    echo "Configuring (Linux)brew..."
    (echo; echo "eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)") >> ~/.zprofile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    sudo apt install -y build-essential | sudo tee "${log_file}"
  fi
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
  configure_brew=true
fi

case "${OS}" in
  Linux*) setup_linux;;
  Mac*) setup_mac;;
esac

echo "Installing GNUPG (might take some time)..."
brew install gnupg &> "${log_file}"
