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
if [ "$CI" != "true" ]; then
  if ! xcodebuild -version; then
    echo_color "Please install the latest Xcode version from the App Store." $color_red
    exit 1
  fi
  xcodeVersion=`xcodebuild -version | grep Xcode | cut -d' ' -f2 | cut -d'.' -f1`
  if [ "$xcodeVersion" -lt "11" ]; then
    echo_color "Your Xcode version is lower than 6. Please install the latest Xcode version from the App Store." $color_red
    exit 1
  fi
fi
############ Xcode ############

############ ZSH ############
echo_title "BEGIN INSTALLING ZSH"
if [ "$CI" != "true" ]; then
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

## BREW
echo_title "BEGIN INSTALLING BREW"
which -s brew
IS_BREW_INSTALLED="$?"
if [[ "${IS_BREW_INSTALLED}" -ne 0 ]] then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  UNAME_MACHINE="$(/usr/bin/uname -m)"
  if [[ "${UNAME_MACHINE}" == "arm64" ]] then
    HOMEBREW_PREFIX="/opt/homebrew"
    case "${SHELL}" in
    */bash*)
      if [[ -r "${HOME}/.bash_profile" ]]
      then
        shell_profile="${HOME}/.bash_profile"
      else
        shell_profile="${HOME}/.profile"
      fi
      ;;
    */zsh*)
      shell_profile="${HOME}/.zprofile"
      ;;
    *)
      shell_profile="${HOME}/.profile"
      ;;
    esac
    echo 'eval "\$(${HOMEBREW_PREFIX}/bin/brew shellenv)"' >> ${shell_profile}
    eval "\$(${HOMEBREW_PREFIX}/bin/brew shellenv)"
  fi
fi
brew update
echo_title "END INSTALLING BREW"

## GCLOUD
echo_title "BEGIN INSTALLING GCLOUD SDK"
curl https://sdk.cloud.google.com > gcloud-install.sh
which -s gcloud || bash gcloud-install.sh --disable-prompts
# gcloud components update
echo_title "END INSTALLING GCLOUD SDK"

## Dialog
which -s dialog || brew install dialog

## GIT
which -s git || brew install git

## Python
which -s python || brew install python

## GH (Github cli)
which -s gh || brew install gh

which -s tree || brew install tree
which -s wget || brew install wget
which -s magick || brew install imagemagick

cd bin
############ SOFTWARE ############
./installsoftware.sh
############ SOFTWARE ############

############ VSCODE ##############
./vscode.sh
############ VSCODE ##############

############ GIT ALIASES ############
./git-config.sh
############ GIT ALIASES ############


cd ..

brew cleanup
