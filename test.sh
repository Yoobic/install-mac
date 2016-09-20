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
    fi
    if [ -e "$1" ]; then
        echo_color "File found: $1" $color_green
    else
        echo_color "File not found: $1" $color_red
        exit 1
    fi
}
echo_color "Start test" $color_yellow

cat ~/.zshrc

check_file "$(which zsh)" "zsh" # check zsh version
check_file "$(which brew)" "brew" # check brew version
check_file "$(which tree)" "tree" # check tree version
check_file "$(which wget)" "wget" # check wget version
check_file "$(which convert)" "convert" # check imagemagick version
check_file "$(which git)" "git" # check git version
check_file "$(which python)" "python" # check python version
check_file "$(which subl)" "subl" # check Sublime Text version
check_file $HOME/.zshrc
check_file "$app_folder/Sublime Text.app" # check Sublime Text software
check_file "$app_folder/iTerm.app" # check iTerm2 software
check_file "$app_folder/Spectacle.app" # check iTerm2 software
check_file "$app_folder/Flycut.app" # check iTerm2 software
#check_file "$app_folder/alfred.app" # check iTerm2 software
check_file "$app_folder/Dropbox.app" # check Dropbox software
check_file "$app_folder/Skype.app" # check Skype software
check_file "$app_folder/VirtualBox.app" # check VirtualBox software
check_file "$app_folder/Slack.app" # check Slack software
check_file "$app_folder/Google Chrome.app" # check Google Chrome software
#check_file "$app_folder/LimeChat.app" # check Lime Chat software
check_file "$app_folder/TeamViewer.app" # check Team Viewer software
check_file "$app_folder/Robomongo.app" # check Robomongo software

check_file "$(which npm)" "npm"
check_file "$(which eslint)" "eslint"
check_file "$(which gulp)" "gulp"
check_file "$(which grunt)" "grunt"
check_file "$(which browser-sync)" "browser-sync"
#check_file "$(which browsersync)" "browsersync"
check_file "$(which karma)" "karma"
check_file "$(which mocha)" "mocha"
check_file "$(which browserify)" "browserify"
check_file "$(which watchify)" "watchify"
check_file "$(which nodemon)" "nodemon"
check_file "$(which node-inspector)" "node-inspector"
check_file "$(which npm-check-updates)" "npm-check-updates"
check_file "$(which cordova)" "cordova"
check_file "$(which phonegap)" "phonegap"
check_file "$(which boot2docker)" "boot2docker"
check_file "$(which slc)" "strongloop"

echo_color "End test" $color_yellow