#!/usr/bin/env bash

log_file="logs/setup_os.log"
rm -f "${log_file}"

function setup_linux {
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  echo "Setting up build environment..."
  # shellcheck disable=SC2024
  {
    sudo apt update && sudo apt -y upgrade
    sudo apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
      libreadline-dev libsqlite3-dev curl  libncursesw5-dev xz-utils tk-dev \
      libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
  } &>> "${log_file}"
}

function setup_mac {
  echo "Upgrading bash..."
  brew install bash &>> "${log_file}"
  bash_path="$(which bash)"
  echo "${bash_path}" | sudo tee /etc/shells > /dev/null

  echo "Setting up build environment..."
  brew install openssl readline sqlite3 xz zlib tcl-tk &>> "${log_file}"
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
brew install gnupg &>> "${log_file}"
