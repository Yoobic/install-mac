#!/bin/zsh
source ~/.zshrc
source ./echo_utils.sh
clear

code --install-extension ../yoobic_extension_pack/*.vsix

cd ~/Library/Application\ Support/Code/User

rm -rf keybindings.json
touch keybindings.json
echo "// Place your key bindings in this file to override the defaults
[
    {
        \"key\": \"shift+cmd+h\",
        \"command\": \"editor.action.formatDocument\",
        \"when\": \"editorTextFocus && !editorReadonly\"
    },
    {
        \"key\": \"shift+alt+f\",
        \"command\": \"-editor.action.formatDocument\",
        \"when\": \"editorTextFocus && !editorReadonly\"
    },
    {
        \"key\": \"shift+cmd+a\",
        \"command\": \"editor.action.fixAll\"
    }
]" > keybindings.json
cat keybindings.json
cd -
