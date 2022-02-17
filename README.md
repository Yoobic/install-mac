# install-mac
[![Test](https://github.com/Yoobic/install-mac/actions/workflows/test.yml/badge.svg)](https://github.com/Yoobic/install-mac/actions/workflows/test.yml)

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
* Make sure you download XCode from the app store. If you did not have it installed before - install it, launch it, accept the user agreement. Then restart your computer.

## Installation
To install the package run the following commands:
```bash
# This assumes your development directory is `~/Documents/yoobic/`. If it is not, then substitute as appropriate
cd ~/Documents/yoobic/
git clone https://github.com/Yoobic/install-mac.git
cd install-mac
./install.sh
```

### Troubleshooting: if you get an error: 
```
xcode-select: error: tool 'xcodebuild' requires Xcode, but active developer directory '/Library/Developer/CommandLineTools' is a command line tools instance
```
running `./install.sh` after xcode was installed, run: 
```
sudo xcode-select -s /Applications/Xcode.app/Contents/Develope
```



The script will then start downloading & installing the software. When prompted, use the keyboard to select which applications and global npm packages you want to install, or just hit **[Enter]** with `<Ok>` selected to take the defaults.

Finally, when prompted you should input your github credentials to ensure that you will be able to use git with our private repos correctly.

### Infrastructure Software installed:
* brew
* git
* nvm (node)
* ohmyzsh
* python
* gh (Github CLI)
* tree
* wget
* imagemagick

### Applications installed:
* VSCode
* Slack
* Google Chrome
* Zoom
* iTerm2
* Postman
* Robo 3T
* Mongo
* Postgresql
* Heroku CLI
* Dropbox
* Flycut
* Fonts (clear-sans, roboto)
* Google Chrome Canary
* Spectacle
* TeamViewer
* Sublime Text 3

## Extras

You can run specific scripts directly as follow: 

- To setup Yoobic git aliases: 

`curl -L https://raw.githubusercontent.com/thaiat/generator-sublime/master/templates/app/bin/git-config.sh | sh` 

- To install nvm and core npm packages: 
`curl -L https://raw.githubusercontent.com/thaiat/generator-sublime/master/templates/app/bin/installnode.sh | sh`

