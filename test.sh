#!/bin/bash
#
# Define colors
color_normal="\x1B[0m"
color_red="\x1B[31m"
color_green="\x1B[32m"
color_yellow="\x1B[33m"
color_blue="\x1B[34m"
color_magenta="\x1B[35m"
color_cyan="\x1B[36m"
color_white="\x1B[37m"


if [ "$TRAVIS" == "true" ]; then
    app_folder="/Applications"
else
    app_folder="/Applications"
fi

echo_color() {
  message=$1
  color=${2:-$color_normal}
  printf "$color$message $color_normal\n"
}

check_file(){
    #echo_color "checking file: $2"
    if [ ! -z "$2" ]; then
       echo_color "checking file: $2"
    else
       echo_color "checking file: $1"
    fi
    if [ -e "$1" ]; then
        echo_color "File found: $1" $color_green
    else
        echo_color "File not found: $1" $color_red
        exit 1
    fi
}

check_program(){
    echo_color "checking program: $1"
    which -s $1 && echo_color "File found: $1" $color_green || ( echo_color "File not found: $1" $color_red && exit 1 )
}
echo_color "Start test" $color_yellow

cat ~/.zshrc

check_program "zsh" # check that zsh is in $PATH
check_program "brew" # check that brew is in $PATH
check_program "tree" # check that tree is in $PATH
check_program "wget" # check that wget is in $PATH
check_program "convert" # check that imagemagick is in $PATH
check_program "git" # check that git is in $PATH
check_program "python" # check that python is in $PATH
check_program "subl" # check that Sublime Text is in $PATH
check_program "code" # check that VSCode is in $PATH
check_file $HOME/.zshrc
check_file "$app_folder/Sublime Text.app" # check Sublime Text software
check_file "$app_folder/iTerm.app" # check iTerm2 software
check_file "$app_folder/Spectacle.app" # check iTerm2 software
check_file "$app_folder/Flycut.app" # check iTerm2 software
#check_file "$app_folder/alfred.app" # check iTerm2 software
check_file "$app_folder/Dropbox.app" # check Dropbox software
check_file "$app_folder/Skype.app" # check Skype software
check_file "$app_folder/VirtualBox.app" # check VirtualBox software
# check_file "$app_folder/Slack.app" # check Slack software
check_file "$app_folder/Google Chrome.app" # check Google Chrome software
#check_file "$app_folder/LimeChat.app" # check Lime Chat software
check_file "$app_folder/TeamViewer.app" # check Team Viewer software
check_file "$app_folder/Robomongo.app" # check Robomongo software

check_program "npm"
check_program "eslint"
# check_program "gulp"
# check_program "grunt"
check_program "browser-sync"
check_program "browsersync"
# check_program "karma"
check_program "mocha"
check_program "browserify"
check_program "watchify"
check_program "nodemon"
# check_program "node-inspector"
check_program "npm-check-updates"
check_program "cordova"
check_program "phonegap"
# check_program "boot2docker"
check_program "loopback-cli"

grep -qc 'bsync' ~/.gitconfig || ( echo_color "Could not find bsync in gitconfig" && exit 1)

echo_color "End test" $color_yellow