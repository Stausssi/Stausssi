function setup_linux {
  true
}

function setup_mac {
  if ! command -v brew; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  echo "Upgrading bash..."
  brew install bash
}

case "${OS}" in
  Linux*) setup_linux;;
  Mac*) setup_mac;;
esac