#!/usr/bin/env bash

log_file="logs/install_software.log"
rm -f "${log_file}"

function brew_install {
  software_name="$1"
  software_command="${2:-${software_name}}"
  if ! command -v "${software_command}" &> /dev/null; then
    echo "Installing ${software_name}..."
    brew install "${software_name}" &> "${log_file}"
  fi
}

function linux_specific {
  true
}

function mac_specific {
  brew_install gnu-sed
}

echo "Updating brew formulae..."
brew update &> "${log_file}"

echo "Setting up Python..."
{
  brew_install pyenv
  brew install pyenv-ccache

  # Temporary fix for OpenSSL build problems
  if [[ "${OS}" == "Linux" ]]; then
    brew remove --ignore-dependencies pkg-config &> /dev/null
  fi
  pyenv install 3.11
  if [[ "${OS}" == "Linux" ]]; then
      brew install pkg-config &> /dev/null
  fi

  pyenv global 3.11
  git clone https://github.com/pyenv/pyenv-update.git "$(pyenv root)/plugins/pyenv-update"
  git clone https://github.com/pyenv/pyenv-doctor.git "$(pyenv root)/plugins/pyenv-doctor"

  brew_install pipenv
} &> "${log_file}"

brew_install jenv
brew_install kubectl

# Specific software
case "${OS}" in
  Linux*) linux_specific;;
  Mac*) mac_specific;;
esac