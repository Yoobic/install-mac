#!/bin/bash
clear
echo "Installing zsh"

curl -L http://install.ohmyz.sh | sh
cd ~/.oh-my-zsh/custom/plugins
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git
cd $CURRENT_DIRECTORY
# forces terminal to use zsh
echo "\nzsh && exit 0" >> ~/.bash_profile
source ~/.bash_profile
