#!/bin/zsh
source ./echo_utils.sh
clear

inquirer_software() {
  if [ "$TRAVIS" == "true" ]; then
    choice="all"
  else
   cmd=(dialog --backtitle "Select your stack" \
              --title "Your stack" --clear \
              --checklist "Select your favorite softwares  " 20 61 15)

    options=(
        "Dropbox" "Dropbox" on
        "Flycut" "Flycut" on
        "Fonts" "Fonts (m-plus, clear-sans, roboto)" on
        "GoogleChrome" "Google Chrome" on
        "GoogleChromeCanary" "Google Chrome Canary" off
        "iTerm2" "iTerm2" on
        "Mongo" "Mongodb" on
        "Robo3T" "Robo 3T" on
        "Spectacle" "Spectacle" on
        "SublimeText3" "Sublime Text 3" on
        "VSCode" "VS Code" on
        "TeamViewer" "TeamViewer" on
      # "Alfred" "Alfred" on
      # "Docker" "Docker" on
      # "Skype" "Skype" on
      # "Slack" "Slack" on
      # "VirtualBox" "Virtual Box" on
      # "Bower" "Bower" on
      # "Browserify" "browserify" on
      # "BrowserSync" "browser-sync" on
      # "Cordova" "Cordova" on
      # "Eslint" "Eslint" on
      # "Grunt" "grunt" on           
      # "Gulp" "gulp" on
      # "Jscs" "Jscs" on
      # "Jshint" "Jshint" on
      # "Karma" "karma" on
      # "Mocha" "mocha" on
      # "NodeInspector" "node-inspector" on
      # "Nodemon" "nodemon" on
      # "Npm" "Npm" on
      # "NpmCheckUpdates" "npm-check-updates" on
      # "StrongLoop" "strongloop" on
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

inquirer_software

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
if ([[ $choice == *"all"* ]] || [[ $choice == *"flycut"* ]]); then
  brew cask install flycut --force
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"SublimeText3"* ]]); then
  brew cask install sublime-text --force
  #configure_sublime
  echo_color "When running sublime, it will look broken, ignore it. Press OK on alerts and wait for sublime to install its packages. Press ctrl+\` to see the installation log." $color_yellow
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"iTerm2"* ]]); then
  brew cask install iterm2 --force
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"VSCode"* ]]); then
  brew cask install visual-studio-code --force
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"Robo3T"* ]]); then
  brew cask install robo-3t --force
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"GoogleChrome"* ]]); then  
  brew cask install google-chrome --force
fi
if ([[ $choice == *"GoogleChromeCanary"* ]]); then  
  brew cask install google-chrome-canary --force
fi
# if ([[ $choice == *"all"* ]] || [[ $choice == *"VirtualBox"* ]]); then
#   brew cask install virtualbox --force
# fi
# if ([[ $choice == *"all"* ]] || [[ $choice == *"Alfred"* ]]); then
#   brew cask install alfred --force
# fi
# if ([[ $choice == *"all"* ]] || [[ $choice == *"Dropbox"* ]]); then
#   brew cask install dropbox --force
# fi
# if ([[ $choice == *"all"* ]] || [[ $choice == *"Skype"* ]]); then
#   brew cask install skype --force
# fi
# if ([[ $choice == *"all"* ]] || [[ $choice == *"Slack"* ]]); then
#   brew cask install slack --force
# fi
#if ([[ $choice == *"all"* ]] || [[ $choice == *"LimeChat"* ]]); then  
#  brew cask install limechat --force
#fi
#brew cask install spotify
#brew cask install u-torrent
#brew cask install source-tree
#brew cask install mou
#brew cask install filezilla
#brew cask install kaleidoscope
#brew cask install firefox-aurora
#brew cask install opera-next
echo_title "END INSTALLING SOFTWARE"
############ SOFTWARE ############

# ############ DOCKER ############
# if ([[ $choice == *"all"* ]] || [[ $choice == *"Docker"* ]]); then
#   echo_title "BEGIN INSTALLING DOCKER"
#   brew install docker
#   brew install boot2docker
#   boot2docker init
#   boot2docker up
#   echo_title "END INSTALLING DOCKER"
# fi
# ############ DOCKER ############

############ MONGO ############
if ([[ $choice == *"all"* ]] || [[ $choice == *"Mongo"* ]]); then
  echo_title "BEGIN INSTALLING MONGO"
  brew install mongodb
  brew cask install robomongo
  mkdir -p /data/db
  chown -R `whoami` /data
  #ln -sfv /usr/local/opt/mongodb/*.plist ~/Library/LaunchAgents
  brew services start mongodb
  echo_title "END INSTALLING MONGO"
fi
############ MONGO ############

############ RETHINKDB ############
if ([[ $choice == *"all"* ]] || [[ $choice == *"Rethinkdb"* ]]); then
  echo_title "BEGIN INSTALLING RETHINKDB"
  brew install rethinkdb
  #ln -sfv /usr/local/opt/rethinkdb/*.plist ~/Library/LaunchAgents
  brew services start rethinkdb
  echo_title "END INSTALLING RETHINKDB"
fi
############ RETHINKDB ############

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