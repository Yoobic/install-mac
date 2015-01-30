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
           "Skype" "Skype" on
           "Slack" "Slack" on
           "SublimeText3" "Sublime Text 3" on
           "VirtualBox" "Virtual Box" on
           "Gulp" "gulp" on
           "Grunt" "grunt" on
           "BrowserSync" "browser-sync" on
           "Karma" "karma" on
           "Mocha" "mocha" on
           "Browserify" "browserify" on
           "Nodemon" "nodemon" on
           "NodeInspector" "node-inspector" on
           "NpmCheckUpdates" "npm-check-updates" on
           "Cordova" "Cordova" on
           )

    choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

  fi
}

clear

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
    contentCask="export HOMEBREW_CASK_OPTS=\"--appdir=/Applications\""
    inject "cask" "$contentCask" "$HOME/.zshrc"
    source "$HOME/.zshrc"
fi

echo_title "END INSTALLING BREW CASK"
############ BREW CASK ############

############ DIALOG ############
brew install dialog
inquirer_software
if [[ $choice == "" ]]
then
  echo "Your stack is empty, nothing to install, exiting...";
  exit
fi 
############ DIALOG ############


############ SOFTWARE ############
echo_title "BEGIN INSTALLING SOFTWARE"
brew install tree
brew install wget 
brew install imagemagick
brew install git
brew install python

if ([[ $choice == *"all"* ]] || [[ $choice == "SublimeText3" ]]); then
  brew cask install sublime-text3 --force
fi
if ([[ $choice == *"all"* ]] || [[ $choice == "iTerm2" ]]); then
  brew cask install iterm2 --force
fi
if ([[ $choice == *"all"* ]] || [[ $choice == "VirtualBox" ]]); then
  brew cask install virtualbox --force
fi
if ([[ $choice == *"all"* ]] || [[ $choice == "Alfred" ]]); then
  brew cask install alfred --force
fi
if ([[ $choice == *"all"* ]] || [[ $choice == "Dropbox" ]]); then
  brew cask install dropbox --force
fi
if ([[ $choice == *"all"* ]] || [[ $choice == "Skype" ]]); then
  brew cask install skype --force
fi
if ([[ $choice == *"all"* ]] || [[ $choice == "Slack" ]]); then
  brew cask install slack --force
fi
if ([[ $choice == *"all"* ]] || [[ $choice == "LimeChat" ]]); then  
  brew cask install limechat --force
fi
#brew cask install spotify
#brew cask install u-torrent
#brew cask install source-tree
#brew cask install mou
#brew cask install filezilla
#brew cask install kaleidoscope
#brew cask install firefox-aurora
if ([[ $choice == *"all"* ]] || [[ $choice == "GoogleChrome" ]]); then  
  brew cask install google-chrome -force
fi
#brew cask install google-chrome-canary
#brew cask install opera-next
echo_title "END INSTALLING SOFTWARE"
############ SOFTWARE ############

############ DOCKER ############
if ([[ $choice == *"all"* ]] || [[ $choice == "Docker" ]]); then
  echo_title "BEGIN INSTALLING DOCKER"
  brew install docker
  brew install boot2docker
  boot2docker init
  boot2docker up
  echo_title "END INSTALLING DOCKER"
fi
############ DOCKER ############

############ MONGO ############

if ([[ $choice == *"all"* ]] || [[ $choice == "Mongo" ]]); then
  echo_title "END INSTALLING MONGO"
  brew install mongodb
  mkdir -p /data/db
  chown -R `whoami` /data
  echo_title "END INSTALLING MONGO"
fi

############ MONGO ############

############ NVM ############
echo_title "BEGIN INSTALL NVM"
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
    nvm install 0.10
    nvm alias default 0.10   
fi
echo_title "END INSTALLING NVM"
############ NVM ############

############ FONTS ############
if ([[ $choice == *"all"* ]] || [[ $choice == "Fonts" ]]); then
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
npm install -g npm
npm install -g bower
npm install -g jshint
npm install -g eslint
npm install -g jscs
if ([[ $choice == *"all"* ]] || [[ $choice == "Gulp" ]]); then
  npm install -g gulp
fi
if ([[ $choice == *"all"* ]] || [[ $choice == "Grunt" ]]); then
  npm install -g grunt
  npm install -g grunt-cli
fi
if ([[ $choice == *"all"* ]] || [[ $choice == "BrowserSync" ]]); then
npm install -g browser-sync
alias browsersync="browser-sync start --server --files \"**/*.html, **/*.js, **/*.css\""
fi
if ([[ $choice == *"all"* ]] || [[ $choice == "Karma" ]]); then
  npm install -g karma
  npm install -g karma-cli
fi
if ([[ $choice == *"all"* ]] || [[ $choice == "Mocha" ]]); then
  npm install -g mocha
fi
if ([[ $choice == *"all"* ]] || [[ $choice == "Browserify" ]]); then
  npm install -g browserify
  npm install -g watchify
fi
if ([[ $choice == *"all"* ]] || [[ $choice == "Nodemon" ]]); then
  npm install -g nodemon
fi
if ([[ $choice == *"all"* ]] || [[ $choice == "NodeInspector" ]]); then
  npm install -g node-inspector
fi
if ([[ $choice == *"all"* ]] || [[ $choice == "NpmCheckUpdates" ]]); then
  npm install -g npm-check-updates
fi
if ([[ $choice == *"all"* ]] || [[ $choice == "Cordova" ]]); then
  npm install -g cordova
  npm install -g phonegap
  npm install -g ionic
fi
echo_title "END INSTALLING NPM GLOBAL PACKAGES"
############ NPM ############

############ SUBLIME PACKAGE ############
folder_sublime_packages="~/Library/Application\ Support/Sublime\ Text\ 3"
ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
echo_color "Install the following package for Sublime Text 3" $color_yellow
echo_color "* Color Highlighter" $color_cyan
echo_color "* Emmet" $color_cyan
echo_color "* HTML-CSS-JS Prettify" $color_cyan
#git clone https://github.com/victorporof/Sublime-HTMLPrettify.git "$folder_sublime_packages/Packages/HTML-CSS-JS Prettify"
echo_color "* SCSS" $color_cyan
echo_color "* SideBarEnhancements" $color_cyan
echo_color "* SublimeLinter" $color_cyan
echo_color "* SublimeLinter-annotations" $color_cyan
echo_color "* SublimeLinter-contrib-eslint" $color_cyan
echo_color "* SublimeLinter-jshint" $color_cyan
echo_color "* SublimeLinter-jscs" $color_cyan
echo_color "* Sublimerge Pro" $color_cyan
echo_color "* Ternjs" $color_cyan
echo_color "* Seti_UI" $color_cyan
echo_color "* Cobalt2" $color_cyan

############ SUBLIME PACKAGE ############

############ GIT ALIASES ############
curl -L https://raw.githubusercontent.com/thaiat/generator-sublime/master/templates/app/bin/git-config.sh | sh
############# GIT ALIASES ############

brew cleanup