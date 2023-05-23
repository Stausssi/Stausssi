#!/usr/bin/env bash

# Change dir directly so that we don't have to use '..' in paths
cd .. || exit

log_file="scripts/logs/oh_my_zsh.log"

echo "Setting up (Oh My) Zsh..."
if ! command -v zsh &> /dev/null; then
  echo "Installing ZSH"
  brew install zsh &> ${log_file}
fi

if [[ "${SHELL}" =~ .*"zsh".* ]]; then
  echo "ZSH is already default"
else
  echo "Setting ZSH as default"
  chsh -s "$(which zsh)"
  sudo chsh -s "$(which zsh)"
  echo "Restart the terminal and start the setup again to continue!"
  exit 2
fi

if [[ -z "${ZSH}" ]]; then
  sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "Copying configuration files and creating backups"
function copy_with_backup {
  origin="$1"
  destination="$2"

  if [[ -f "${destination}" ]]; then
    mv "${destination}" "configs/backup/$(basename "${destination}")"
  fi
  cp "${origin}" "${destination}"
}

copy_with_backup configs/.zshrc ~/.zshrc
copy_with_backup configs/.zshenv ~/.zshenv
cp -r configs/completions ~/.oh-my-zsh/

echo "Please run 'omz reload' to apply the configuration and then restart the setup script"
exit 3