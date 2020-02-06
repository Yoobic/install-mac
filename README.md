# install-mac
[![Build Status](https://travis-ci.org/Yoobic/install-mac.svg?branch=master)](https://travis-ci.org/Yoobic/install-mac)

## Description
This repo contains a simple bash script that installs the dev tools for a mac.

![install-mac](https://cloud.githubusercontent.com/assets/4806944/5983453/368a062e-a8d6-11e4-873a-29f303efcbf6.png)

## Prerequisites
* Make sure you have `zsh` (normally it is installed by default on every mac, check with `which zsh`)
* Make sure `zsh` is the default shell
  
    ```bash
    sudo dscl localonly -changei /Local/Default/Users/root UserShell 1 $(which zsh)
    ```
* Restart the computer
* Make sure you download XCode from the app store

## Installation
To install the package run the following commands:
```bash
# This assumes your development directory is `~/Documents/yoobic/`. If it is not, then substitute as appropriate
cd ~/Documents/yoobic/
git clone https://github.com/Yoobic/install-mac.git
cd install-mac
./install.sh
```

The script will then start downloading & installing the software. When prompted, use the keyboard to select which applications and global npm packages you want to install, or just hit **[Enter]** with `<Ok>` selected to take the defaults.

Finally, when prompted you should input your github credentials to ensure that you will be able to use git with our private repos correctly.

### Infrastructure Software installed:
* brew
* git
* imagemagick
* nvm (node)
* ohmyzsh
* python
* tree
* wget

### Software installed:
* Dropbox
* Flycut
* Fonts (m-plus, clear-sans, roboto)
* Google Chrome
* iTerm2
* Mongodb (latest version of mongodb-community (4.x) and mongodb-community-shell for remote operations)
* Robo 3T
* Skype
* Spectacle
* Sublime Text 3

### Npm Packages installed:
* browserify
* browser-sync
* cordova
* eslint
* mocha
* node-inspector
* nodemon
* npm-check-updates
