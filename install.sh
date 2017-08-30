#!/bin/zsh

source ~/.zshrc
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
if [ "$TRAVIS" != "true" ]; then
  upgrade_oh_my_zsh || curl -L http://install.ohmyz.sh | sh
fi
##cd ~/.oh-my-zsh/custom/plugins
update_syntax_highlighting() {
if [ -e ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
  cd ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
  git checkout master || (echo_color "Please clean or commit any changes in ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting before continuing" && exit 1)
  git pull origin
else
  git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi
}
( update_syntax_highlighting )
##cd $CURRENT_DIRECTORY
# forces terminal to use zsh
#echo "\nzsh && exit 0" >> ~/.bash_profile
#source ~/.bash_profile
echo_title "END INSTALLING ZSH"
############ ZSH ############

############ BREW ############
echo_title "BEGIN INSTALLING BREW"
which -s brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
echo_title "END INSTALLING BREW"
############ BREW ############

############ BREW CASK ############
echo_title "BEGIN INSTALLING BREW CASK"
brew tap caskroom/cask
# configure cask installation in /Applications
if [ -f "$HOME/.zshrc" ] && ! grep -qc "HOMEBREW_CASK_OPTS" "$HOME/.zshrc"; then
    contentCask="export HOMEBREW_CASK_OPTS=\"--appdir="$applicationsPrefix"\""
    echo $contentCask
    inject "cask" "$contentCask" "$HOME/.zshrc"
    source "$HOME/.zshrc"
fi

echo_title "END INSTALLING BREW CASK"
############ BREW CASK ############

############ DIALOG ############
which -s dialog || brew install dialog
# if [[ $choice == "" ]]
# then
#   echo "Your stack is empty, nothing to install, exiting...";
#   exit
# fi 
############ DIALOG ############
cd bin
############ SOFTWARE ############
./installsoftware.sh
############ SOFTWARE ############

############ NODE ############
./installnode.sh
############ NODE ############

############ GIT ALIASES ############
./git-config.sh
############ GIT ALIASES ############
cd ..

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
