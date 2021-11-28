#!/bin/zsh
source ~/.zshrc
source ./echo_utils.sh
clear
local choice
inquirer_software() {
  if [ "$CI" = "true" ]; then
    choice="all"
  else
    local cmd=(dialog --backtitle "Select your stack" \
              --title "Your stack" --clear --no-tags \
              --separate-output --output-separator " " \
              --checklist "Select your favorite softwares  " 20 61 15)

    local options=("Dropbox" "Dropbox" on
        "Flycut" "Flycut (Keyboard manager)" on
        "Fonts" "Fonts (m-plus, clear-sans, roboto)" on
        "GoogleChrome" "Google Chrome" on
        "GoogleChromeCanary" "Google Chrome Canary" off
        "iTerm2" "iTerm2" on
        "Mongo" "Mongodb (DB)" on
        "Postgresql" "Postgresql (DB)" on
        "Robo3T" "Robo 3T (Mongo UI)" on
        "Slack" "Slack" on
        "Spectacle" "Spectacle (Layout Manager)" on
        "Zoom" "Zoom" on
        "TeamViewer" "TeamViewer" off
        "VSCode" "VS Code" on
        "SublimeText3" "Sublime Text 3 (Text editor)" off
        "Postman" "Postman (API Tool)" on
        "Heroku" "Heroku CLI" off
    )

    choice="$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)"
  fi
}

inquirer_software

############ SOFTWARE ############
echo_title "BEGIN INSTALLING SOFTWARE"
which -s tree || brew install tree
which -s wget || brew install wget
which -s magick || brew install imagemagick
if ([[ $choice == *"all"* ]] || [[ $choice == *"TeamViewer"* ]]); then
  brew install  teamviewer --force
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"Spectacle"* ]]); then
  brew install  spectacle --force
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"Flycut"* ]]); then
  brew install  flycut --force
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"SublimeText3"* ]]); then
  brew install  sublime-text --force
  # configure_sublime
  # echo_color "When running sublime, it will look broken, ignore it. Press OK on alerts and wait for sublime to install its packages. Press ctrl+\` to see the installation log." $color_yellow
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"iTerm2"* ]]); then
  brew install iterm2 --force
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"VSCode"* ]]); then
  brew install  visual-studio-code --force
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"Postman"* ]]); then
  brew install  postman --force
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"Zoom"* ]]); then
  brew install  zoom --force
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"Robo3T"* ]]); then
  brew install  robo-3t --force
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"GoogleChrome"* ]]); then  
  brew install  google-chrome --force
fi
if ([[ $choice == *"all"* ]] || [[ $choice == *"Dropbox"* ]]); then
  brew install  dropbox --force
fi
if ([[ $choice == *"GoogleChromeCanary"* ]]); then  
  brew install  google-chrome-canary --force
fi
if ([[ $choice == *"Slack"* ]]); then
  brew install  slack --force
fi

echo_title "END INSTALLING SOFTWARE"
############ SOFTWARE ############

# ############ DOCKER ############
if ([[ $choice == *"Docker"* ]]); then
  echo_title "BEGIN INSTALLING DOCKER"
  brew install docker
  echo_title "END INSTALLING DOCKER"
fi
# ############ DOCKER ############

############ MONGO ############
if ([[ $choice == *"all"* ]] || [[ $choice == *"Mongo"* ]]); then
  echo_title "BEGIN INSTALLING MONGO"
  brew tap mongodb/brew
  #local operations
  brew install mongodb-community
  #remote operations
  brew install mongodb-community-shell
  #start the service
  if [ -f "$HOME/.zshrc" ]; then
    contentAlias=$contentAlias"alias mongodbstart=\"brew services start mongodb-community\""
    contentAlias=$contentAlias"\n"
    contentAlias=$contentAlias"alias mongodbstop=\"brew services stop mongodb-community\""
  
    inject "alias" "$contentAlias" "$HOME/.zshrc"
    source "$HOME/.zshrc"
  fi
  #brew services start mongodb-community
  echo_title "END INSTALLING MONGO"
fi
############ MONGO ############

############ HEROKU ############
if ([[ $choice == *"all"* ]] || [[ $choice == *"Heroku"* ]]); then
  echo_title "BEGIN INSTALLING Heroku"
  brew tap heroku/brew 
  brew install heroku
  echo_title "END INSTALLING Heroku"
fi
############ HEROKU ############


brew tap heroku/brew && brew install heroku

############ POSTGRESQL ############
if ([[ $choice == *"all"* ]] || [[ $choice == *"Postgresql"* ]]); then
  echo_title "BEGIN INSTALLING POSTGRESQL"
  brew install postgres
  brew services start postgresql
  createuser --superuser -d root
  createdb postgresqldb
  if [ -f "$HOME/.zshrc" ]; then
    contentAlias=$contentAlias"alias mongodbstart=\"brew services start mongodb-community\""
    contentAlias=$contentAlias"\n"
    contentAlias=$contentAlias"alias mongodbstop=\"brew services stop mongodb-community\""
    inject "alias" "$contentAlias" "$HOME/.zshrc"
    source "$HOME/.zshrc"
  fi
  echo_title "END INSTALLING POSTGRESQL"

fi
############ POSTGRESQL ############

# ############ RETHINKDB ############
# if ([[ $choice == *"all"* ]] || [[ $choice == *"Rethinkdb"* ]]); then
#   echo_title "BEGIN INSTALLING RETHINKDB"
#   brew install rethinkdb
#   #ln -sfv /usr/local/opt/rethinkdb/*.plist ~/Library/LaunchAgents
#   brew services start rethinkdb
#   echo_title "END INSTALLING RETHINKDB"
# fi
# ############ RETHINKDB ############

############ FONTS ############
if ([[ $choice == *"all"* ]] || [[ $choice == *"Fonts"* ]]); then
  echo_title "BEGIN INSTALLING FONTS"
  brew install svn
  fonts=(
    font-clear-sans
    font-roboto
  )
  brew tap homebrew/cask-fonts 
  brew install  ${fonts[@]}
  echo_title "END INSTALLING FONTS"
fi
############ FONTS ############
