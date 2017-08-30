#!/bin/zsh
source ./echo_utils.sh
clear

############ NVM ############
echo_title "BEGIN INSTALL NVM NODE"
#curNodeVersion=$(node --version)
#if [[ ! $curNodeVersion =~ ^v[0-9]+.[0-9]+.[0-9]+$ ]]; then
#curNodeVersion="6"
#fi

if [[ -f "$HOME/.zshrc" ]]; then
  PROFILE="$HOME/.zshrc"
fi

curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | NODE_VERSION="lts/*" PROFILE="$PROFILE" zsh

if [ -f "$HOME/.zshrc" ]; then
  source  "$HOME/.zshrc"
  nvm alias default $curNodeVersion
fi

echo_title "END INSTALLING NVM NODE"
############ NVM ############

############ INSTALL NPM ############
zsh ./installnpm.sh
############ INSTALL NPM ############