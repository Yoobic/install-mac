#!/bin/sh

source ./bin/echo_utils.sh
clear

# get special folders
applicationsSupportPrefix="$(osascript \
  -e 'tell application "System Events"' \
  -e 'get POSIX path of (path to application support folder from user domain)' \
  -e 'end tell')"
applicationsPrefix="$(osascript \
  -e 'tell application "System Events"' \
  -e 'get POSIX path of (path to applications folder)' \
  -e 'end tell')"

echo_color "Application Support: $applicationsSupportPrefix" $color_yellow
printf "\n"
echo_color "Applications: $applicationsPrefix" $color_yellow
printf "\n"

############ Xcode ############
if [ "$TRAVIS" != "true" ]; then
  if ! xcodebuild -version; then
    echo_color "Please install the latest Xcode version from the App Store." $color_red
    exit 1
  fi
  xcodeVersion=`xcodebuild -version | grep Xcode | cut -d' ' -f2 | cut -d'.' -f1`
  if [ "$xcodeVersion" -lt "6" ]; then
    echo_color "Your Xcode version is lower than 6. Please install the latest Xcode version from the App Store." $color_red
    exit 1
  fi
fi
############ Xcode ############

############ ZSH ############
echo_title "BEGIN INSTALLING ZSH"
if [ !"$TRAVIS" == "true" ]; then
  curl -L http://install.ohmyz.sh | sh
fi
##cd ~/.oh-my-zsh/custom/plugins
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
##cd $CURRENT_DIRECTORY
# forces terminal to use zsh
#echo "\nzsh && exit 0" >> ~/.bash_profile
#source ~/.bash_profile
echo_title "END INSTALLING ZSH"
############ ZSH ############

############ BREW ############
echo_title "BEGIN INSTALLING BREW"
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
brew update
echo_title "END INSTALLING BREW"
############ BREW ############

############ BREW CASK ############
echo_title "BEGIN INSTALLING BREW CASK"
brew install caskroom/cask/brew-cask
brew tap caskroom/versions
# configure cask installation in /Applications
if [ -f "$HOME/.zshrc" ]; then
    contentCask="export HOMEBREW_CASK_OPTS=\"--appdir="$applicationsPrefix"\""
    echo $contentCask
    inject "cask" "$contentCask" "$HOME/.zshrc"
    source "$HOME/.zshrc"
fi

echo_title "END INSTALLING BREW CASK"
############ BREW CASK ############

############ DIALOG ############
if test ! $(which dialog); then
  brew install dialog
fi
# if [[ $choice == "" ]]
# then
#   echo "Your stack is empty, nothing to install, exiting...";
#   exit
# fi 
############ DIALOG ############

############ SOFTWARE ############
zsh ./bin/installsoftware.sh
############ SOFTWARE ############

############ NODE ############
zsh ./bin/installnode.sh
############ NODE ############

############ GIT ALIASES ############
zsh ./bin/git-config.sh
############# GIT ALIASES ############

### CONFIGURE ALIASES
if [ -f "$HOME/.zshrc" ]; then
    contentAlias="alias rethinkdbstart=\"brew services start rethinkdb\""
    contentAlias=$contentAlias"\n"
    contentAlias=$contentAlias"alias rethinkdbstop=\"brew services stop rethinkdb\""
    contentAlias=$contentAlias"\n"
    contentAlias=$contentAlias"alias mongodbstart=\"brew services start  mongodb\""
    contentAlias=$contentAlias"\n"
    contentAlias=$contentAlias"alias mongodbstop=\"brew services stop mongodb\""
  
    inject "alias" "$contentAlias" "$HOME/.zshrc"
    source "$HOME/.zshrc"
fi
###

brew cleanup
