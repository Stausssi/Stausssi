#!/usr/bin/env bash

# Change dir directly so that we don't have to use '..' in paths
cd .. || exit

log_file="scripts/logs/setup_git.log"
rm -f "${log_file}"

echo "Configuring git..."
if [[ -f ~/.gitconfig ]]; then
  mv ~/.gitconfig configs/backup/.gitconfig
fi
cp configs/.gitconfig ~/.gitconfig

read -rp "Which name do you want to use? " name
git config --global user.name "${name}"

read -rp "Which E-Mail would you like to use with git? " mail
git config --global user.email "${mail}"

echo "Generating a singing key for git..."
gpg_key_config_file="configs/backup/gpg_key_config"
{
  echo "Key-Type: RSA"
  echo "Key-Length: 4096"
  echo "Name-Real: ${name}"
  echo "Name-Email: ${mail}"
  echo "Expire-Date: 0"
  echo "%commit"
} > ${gpg_key_config_file}
gpg --full-generate-key --batch "${gpg_key_config_file}" &> /dev/null
gpg --list-secret-keys --keyid-format=long
read -rp "Please copy the ID of the key you want to use for git: " key_id
git config --global user.signingkey "${key_id}"

echo "Installing GitHub CLI..."
brew install gh &>> ${log_file}
gh auth login -p https -s write:gpg_key -w
gh auth setup-git
gh config set editor nano

echo "Uploading signing key to GitHub..."
exported_key_file="configs/backup/signing_key.pub"
gpg --armor --export "${key_id}" &> ${exported_key_file}
gh gpg-key add "${exported_key_file}" -t "${name} @ $(uname -n) ($(uname -s))"

echo "Note: The key files can be found under 'configs/backup/'"