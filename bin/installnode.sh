#!/bin/zsh
source ~/.zshrc
source ./echo_utils.sh
clear

############ NVM ############
echo_title "BEGIN INSTALL NVM NODE"
#curNodeVersion=$(node --version)
#if [[ ! $curNodeVersion =~ ^v[0-9]+.[0-9]+.[0-9]+$ ]]; then
#curNodeVersion="6"
#fi

curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | NODE_VERSION="lts/*" zsh

source ~/.zshrc
[ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh"  # This loads nvm

NVM_LTS_VERISON="$(nvm version-remote --lts)"
nvm install $NVM_LTS_VERISON
nvm alias default $NVM_LTS_VERISON

echo_title "END INSTALLING NVM NODE"
############ NVM ############

############ INSTALL NPM ############
zsh ./installnpm.sh
############ INSTALL NPM ############