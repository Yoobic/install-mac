#install-mac
[![Build Status](https://travis-ci.org/Yoobic/install-mac.svg?branch=master)](https://travis-ci.org/Yoobic/install-mac)

## Description
This repo contains a simple bash script that installs the dev tools for a mac.

## Prerequisites
* Make sure you have `zsh`
* Make sure `zsh` is the default shell
  
    ```bash
    sudo dscl localonly -changei /Local/Default/Users/root UserShell 1 $(which zsh)
    ```
* Restart the computer
* Install oh-my-zsh

    ```bash
    curl -L http://install.ohmyz.sh | sh
    ```

    The installation will launch the installation of `XCode tools` if it is not installed. On the popup window press `Install` 

    Once `XCode tools` installation has completed, re-run the command for installing `oh-my-zsh`

## Installation
To install the package run the following command:
```bash
curl -L https://raw.githubusercontent.com/Yoobic/install-mac/master/install.sh | sh
```


It will install the following:
* brew
* zsh
* mongo
* nvm (node)
* git
* tree
* wget
* imagemagick
* iTerm2
* Alfred
* Skype
* Dropbox
* Sublime Text 3
* VirtualBox
* Slack
* LimeChat
* gulp
* karma
* mocha
* browser-sync
* jshint
* eslint
* jscs
* browserify
* watchify
* nodemon
* node-inspector
* cordova
* phonegap
* ionic


