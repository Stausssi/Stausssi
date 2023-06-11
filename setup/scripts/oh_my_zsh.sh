#!/usr/bin/env bash

# Change dir directly so that we don't have to use '..' in paths
cd .. || exit

log_file="scripts/logs/oh_my_zsh.log"
rm -f "${log_file}"

echo "Setting up (Oh My) Zsh..."
if ! command -v zsh &> /dev/null; then
  echo "Installing ZSH"
  brew install zsh &>> ${log_file}
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

echo "Cloning plugins..."
{
  git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
} &>> ${log_file}

# Insert Linuxbrew stuff into zshrc
if [[ "${OS}" == "Linux" && -z ${HOMEBREW_PREFIX} ]]; then
  echo "Configuring (Linux)brew..."
  {
    echo "# Linuxbrew configuration"
    echo "eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    echo ""
    cat ~/.zshenv
  } > tempfile && mv tempfile ~/.zshenv
fi

echo "Setting up Spaceship..."
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1 &>> ${log_file}
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme" &>> ${log_file}
copy_with_backup configs/.spaceshiprc.zsh ~/.spaceshiprc.zsh
if [[ "${OS}" == "Linux" ]]; then
  {
    echo ""
    echo "# Temporary bugfix for https://github.com/spaceship-prompt/spaceship-prompt/issues/1193"
    echo "export SPACESHIP_PROMPT_ASYNC=false"
  } >> ~/.spaceshiprc.zsh
fi

echo "Please run 'omz reload' to apply the configuration and then restart the setup script"
exit 3