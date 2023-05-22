#!/usr/bin/env bash

function brew_install {
  software_name="$1"
  software_command="$2"
  if ! command -v "${software_command}" &> /dev/null; then
    echo "Installing ${software_name}..."
    brew install "${software_name}"
  fi
}

function linux_specific {
  true
}

function mac_specific {
  brew_install gnu-sed
}


brew install python@3.11
brew_install jenv jenv
brew_install kubectl kubectl

# Specific software
case "${OS}" in
  Linux*) linux_specific;;
  Mac*) mac_specific;;
esac