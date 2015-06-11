#!/bin/bash

# Define colors
color_normal="\x1B[0m"
color_red="\x1B[31m"
color_green="\x1B[32m"
color_yellow="\x1B[33m"
color_blue="\x1B[34m"
color_magenta="\x1B[35m"
color_cyan="\x1B[36m"
color_white="\x1B[37m"

# Inject content between 2 delimiters
# usage : inject sectionName newContent fileName
inject() {
  sectionName=$1
  newContent=$2
  fileName=$3

  # remove previous content
  sed -i.bak  '/## yoobic:'$sectionName'/,/## yoobic:'$sectionName'/d' $fileName
  # add new content


  printf "%s\n" "## yoobic:"$sectionName >> $fileName
  printf "${newContent}\n" >> $fileName
  printf "%s\n" "## yoobic:"$sectionName >> $fileName
  
}

# Echo a message in color (default to normal color)
# usage: echo_color message
# usage: echo_color message $color_red
echo_color() {
  message=$1
  color=${2:-$color_normal}
  printf "$color$message $color_normal\n"
}

# Echo a title in color 
# usage: echo_title message
# usage: echo_title message color
echo_title() {
  message="***** $1 *****\n"
  color=${2:-$color_green}
  echo_color "$message" "$color"
}

inquirer_software() {
  if [ "$TRAVIS" == "true" ]; then
    choice="all"
  else
   cmd=(dialog --backtitle "Select your stack" \
              --title "Your stack" --clear \
              --checklist "Select your favorite softwares  " 20 61 15)

    options=("Alfred" "Alfred" on
           "Docker" "Docker" on
           "Dropbox" "Dropbox" on
           "Fonts" "Fonts (m-plus, clear-sans, roboto)" on
           "GoogleChrome" "Google Chrome" on
           "iTerm2" "iTerm2" on
           "LimeChat" "LimeChat" on
           "Mongo" "Mongodb" on
           "Rethinkdb" "Rethinkdb" on
           "Skype" "Skype" on
           "Slack" "Slack" on
           "Spectacle" "Spectacle" on
           "SublimeText3" "Sublime Text 3" on
           "TeamViewer" "TeamViewer" on
           "VirtualBox" "Virtual Box" on
           "Bower" "Bower" on
           "Browserify" "browserify" on
           "BrowserSync" "browser-sync" on
           "Cordova" "Cordova" on
           "Eslint" "Eslint" on
           "Grunt" "grunt" on           
           "Gulp" "gulp" on
           "Jscs" "Jscs" on
           "Jshint" "Jshint" on
           "Karma" "karma" on
           "Mocha" "mocha" on
           "NodeInspector" "node-inspector" on
           "Nodemon" "nodemon" on
           "Npm" "Npm" on
           "NpmCheckUpdates" "npm-check-updates" on
           "StrongLoop" "strongloop" on
           )

    choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
  fi
}

configure_sublime() {
  

  ln -s "$applicationsPrefix/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
  mkdir "$applicationsSupportPrefix/Sublime Text 3"
  mkdir "$applicationsSupportPrefix/Sublime Text 3/Packages"
  mkdir "$applicationsSupportPrefix/Sublime Text 3/Packages/User"
  mkdir "$applicationsSupportPrefix/Sublime Text 3/Installed Packages"

  packagecontrol="$applicationsSupportPrefix/Sublime Text 3/Installed Packages/Package Control.sublime-package"
  curl -L "https://packagecontrol.io/Package%20Control.sublime-package" > "$packagecontrol"
  printf "\nDownloaded package control\n"

  packagesettings="$applicationsSupportPrefix/Sublime Text 3/Packages/User/Package Control.sublime-settings"
  if [[ -f "$packagesettings" ]]; then
    cp "$packagesettings" "$packagesettings.old"
    printf "\nBacked up of package settings file in $packagesettings.old\n"
  fi
  curl -L "https://raw.githubusercontent.com/thaiat/generator-sublime/master/templates/sublime/Package%20Control.sublime-settings" > "$packagesettings"
  printf "\nDownloaded package control settings\n"

  preferences="$applicationsSupportPrefix/Sublime Text 3/Packages/User/Preferences.sublime-settings"
  if [[ -f "$preferences" ]]; then
    cp "$preferences" "$preferences.old"
    printf "\nBacked up old preferences file in $preferences.old\n"
  fi
  curl -L "https://raw.githubusercontent.com/thaiat/generator-sublime/master/templates/sublime/Preferences.sublime-settings" > "$preferences"
  printf "\nDownloaded user preferences\n"
}

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
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
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
brew install dialog
inquirer_software
# if [[ $choice == "" ]]
# then
#   echo "Your stack is empty, nothing to install, exiting...";
#   exit
# fi 
############ DIALOG ############


############ SOFTWARE ############
echo_title "BEGIN INSTALLING SOFTWARE"
if ( ! which tree >/dev/null); then
  brew install tree
fi 
if ( ! which wget >/dev/null); then
  brew install wget
fi 
if ( ! which convert >/dev/null); then
  brew install imagemagick
fi 
if ( ! which git >/dev/null); then
  brew install git
fi 
if ( ! which python >/dev/null); then
  brew install python
fi 
if ([[ $choice == *"all"* ]] || [[ $choice == *"TeamViewer"* ]]); then
  brew cask install teamviewer --force
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"Spectacle"* ]]); then
  brew cask install spectacle --force
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"SublimeText3"* ]]); then
  brew cask install sublime-text3 --force
  configure_sublime
  echo_color "When running sublime, it will look broken, ignore it. Press OK on alerts and wait for sublime to install its packages. Press ctrl+\` to see the installation log." $color_yellow
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"iTerm2"* ]]); then
  brew cask install iterm2 --force
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"VirtualBox"* ]]); then
  brew cask install virtualbox --force
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"Alfred"* ]]); then
  brew cask install alfred --force
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"Dropbox"* ]]); then
  brew cask install dropbox --force
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"Skype"* ]]); then
  brew cask install skype --force
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"Slack"* ]]); then
  brew cask install slack --force
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"LimeChat"* ]]); then  
  brew cask install limechat --force
fi
#brew cask install spotify
#brew cask install u-torrent
#brew cask install source-tree
#brew cask install mou
#brew cask install filezilla
#brew cask install kaleidoscope
#brew cask install firefox-aurora
if ([[ $choice == *"all"* ]] || [[ $choice == *"GoogleChrome"* ]]); then  
  brew cask install google-chrome -force
fi
#brew cask install google-chrome-canary
#brew cask install opera-next
echo_title "END INSTALLING SOFTWARE"
############ SOFTWARE ############

############ DOCKER ############
if ([[ $choice == *"all"* ]] || [[ $choice == *"Docker"* ]]); then
  echo_title "BEGIN INSTALLING DOCKER"
  brew install docker
  brew install boot2docker
  boot2docker init
  boot2docker up
  echo_title "END INSTALLING DOCKER"
fi
############ DOCKER ############

############ MONGO ############

if ([[ $choice == *"all"* ]] || [[ $choice == *"Mongo"* ]]); then
  echo_title "END INSTALLING MONGO"
  brew install mongodb
  mkdir -p /data/db
  chown -R `whoami` /data
  echo_title "END INSTALLING MONGO"
fi
############ MONGO ############

############ RETHINKDB ############
if ([[ $choice == *"all"* ]] || [[ $choice == *"Rethinkdb"* ]]); then
  echo_title "END INSTALLING RETHINKDB"
  brew install rethinkdb
  ln -sfv /usr/local/opt/rethinkdb/*.plist ~/Library/LaunchAgents
  echo_title "END INSTALLING RETHINKDB"
fi
############ RETHINKDB ############

############ NVM ############
echo_title "BEGIN INSTALL NVM"
curNodeVersion=$(node --version)
if [[ ! $curNodeVersion =~ ^v[0-9]+.[0-9]+.[0-9]+$ ]]; then
  curNodeVersion = "0.10"
fi

curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
contentNvm="export NVM_DIR=\"/Users/$USER/.nvm\""
contentNvm=$contentNvm"\n[ -s \"\$NVM_DIR/nvm.sh\" ] && . \"\$NVM_DIR/nvm.sh\"  # This loads nvm"
if [ -f "$HOME/.zshrc" ]; then
    NVM_PROFILE="$HOME/.zshrc" 
    if (grep -qc 'nvm.sh' $NVM_PROFILE) && (! grep -qc  'yoobic:nvm' $NVM_PROFILE); then
      echo_color "Source string already in $NVM_PROFILE, please clean it" $color_red
    else
      echo_color "modifying $NVM_PROFILE" $color_yellow
      inject "nvm" "$contentNvm" "$HOME/.zshrc"
    fi
    source $NVM_PROFILE
    nvm install $curNodeVersion
    nvm install 0.10
    nvm alias default $curNodeVersion
fi
echo_title "END INSTALLING NVM"
############ NVM ############

############ FONTS ############
if ([[ $choice == *"all"* ]] || [[ $choice == *"Fonts"* ]]); then
  echo_title "BEGIN INSTALLING FONTS"
  fonts=(
    font-m-plus
    font-clear-sans
    font-roboto
  )
  brew tap caskroom/fonts 
  brew cask install ${fonts[@]}
  echo_title "END INSTALLING FONTS"
fi
############ FONTS ############

############ NPM ############
echo_title "BEGIN INSTALLING NPM GLOBAL PACKAGES"
if ([[ $choice == *"all"* ]] || [[ $choice == *"Npm"* ]]); then
  npm install -g npm
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"Bower"* ]]); then
  npm install -g bower
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"Browserify"* ]]); then
  npm install -g browserify
  npm install -g watchify
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"BrowserSync"* ]]); then
npm install -g browser-sync
alias browsersync="browser-sync start --server --files \"**/*.html, **/*.js, **/*.css\""
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"Cordova"* ]]); then
  npm install -g cordova
  npm install -g cordova-ios
  npm install -g phonegap
  npm install -g ionic
  npm install -g ios-sim
  npm install -g ios-deploy
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"Eslint"* ]]); then
  npm install -g eslint
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"Grunt"* ]]); then
  npm install -g grunt
  npm install -g grunt-cli
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"Gulp"* ]]); then
  npm install -g gulp
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"Jscs"* ]]); then
  npm install -g jscs
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"Jshint"* ]]); then
  npm install -g jshint
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"Karma"* ]]); then
  npm install -g karma
  npm install -g karma-cli
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"Mocha"* ]]); then
  npm install -g mocha
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"NodeInspector"* ]]); then
  npm install -g node-inspector
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"Nodemon"* ]]); then
  npm install -g nodemon
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"NpmCheckUpdates"* ]]); then
  npm install -g npm-check-updates
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"StrongLoop"* ]]); then
  npm install -g strongloop
fi
echo_title "END INSTALLING NPM GLOBAL PACKAGES"
############ NPM ############

############ SET GIT CREDENTIALS ############
echo_title "START SET GIT CREDENTIALS"
if [ "$TRAVIS" != "true" ]; then
  echo_color "Please enter your user name at Github:"
  read username < /dev/tty
  echo_color "Please enter your email at Github:"
  read email < /dev/tty
  git config --global user.name $username
  git config --global user.email $email
fi
echo_title "END SET GIT CREDENTIALS"
############ SET GIT CREDENTIALS ############

############ GIT ALIASES ############
curl -L https://raw.githubusercontent.com/thaiat/generator-sublime/master/templates/app/bin/git-config.sh | sh
############# GIT ALIASES ############

brew cleanup
