#!/bin/zsh

inquirer_packages() {
  if [ "$TRAVIS" == "true" ]; then
    choices="browserify watchify browser-sync cordova cordova-ios cordova-android ionic eslint eslint-plugin-nodeca babel-eslint grunt grunt-cli gulp ios-sim ios-deploy mocha phonegap node-inspector nodemon npm-check-updates loopback-cli"
  else
   cmd=(dialog --backtitle "Select your stack" \
              --title "Your stack" --clear \
              --checklist "Select your favorite softwares  " 20 61 15)

    options=(
      "browserify watchify" "Browserify" on
      "browser-sync" "BrowserSync" on
      "cordova cordova-ios cordova-android" "Cordova" on
      "ionic" "Cordova" on
      "eslint eslint-plugin-nodeca babel-eslint" "Eslint" on
      "grunt grunt-cli" "Grunt" on           
      "gulp" "Gulp" on
      "ios-sim" "iOS Sim" on
      "ios-deploy" "iOS Deploy" on
      "jscs" "Jscs" off
      "jshint" "Jshint" off
      "karma karma-cli" "Karma" off
      "mocha" "Mocha" on
      "phonegap" "Phonegap" on
      "node-inspector" "Node Inspector" on
      "nodemon" "Nodemon" on
      "npm-check-updates" "NpmCheckUpdates" on
      "loopback-cli" "Loopback CLI" on
    )

    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
  fi
}

inquirer_packages

############ NPM ############
echo_title "BEGIN INSTALLING NPM GLOBAL PACKAGES"
npm install -g "${choices[@]}"


if [ -f "$HOME/.zshrc" ]; then
  local -A ALIAS_LIST=(
    # additional aliases can be added as
    # 'alias' 'command'
    'browsersync' 'browser-sync start --server --files "**/*.html, **/*.js, **/*.css"'
  )
  for a in ${(@k)ALIAS_LIST}; do
    grep -qc $a "$HOME/.zshrc" || echo "\nalias $a='${=${ALIAS_LIST[$a]}}'\n" >> "$HOME/.zshrc"
  done
fi

echo_title "END INSTALLING NPM GLOBAL PACKAGES"
############ NPM ############
