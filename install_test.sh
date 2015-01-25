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
  
  #$(echo -e "## yoobic:"$sectionName >> $fileName)
  #$(echo -e $newContent >> $fileName)
  #$(echo -e "## yoobic:"$sectionName >> $fileName)
  

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

clear


############ NVM ############
echo_title "BEGIN INSTALL NVM"
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
#contentNvm=$(echo "export NVM_DIR=\"/Users/$USER/.nvm\"")
#contentNvm=$(echo $contentNvm"\n[ -s \"\$NVM_DIR/nvm.sh\" ] && . \"\$NVM_DIR/nvm.sh\"  # This loads nvm")

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
echo $contentNvm


if [ -f "$HOME/.zshrc" ]; then
    contentCask="HOMEBREW_CASK_OPTS=\"--appdir=/Applications\""
    inject "cask" "export $contentCask" "$HOME/.zshrc"
    source "$HOME/.zshrc"
fi

echo_title "END INSTALLING NVM"
############ NVM ############

