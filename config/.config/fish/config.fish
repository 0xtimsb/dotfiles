# nvim
alias vim "nvim"

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# zoxide
zoxide init fish | source

# gretting
set -g fish_greeting ""

# code
alias cursor "~/apps/cursor.AppImage --no-sandbox"

# java
#set -x JAVA_HOME /usr/lib/jvm/java-17-openjdk-17.0.13.0.11-1.fc40.x86_64
#set -x PATH $JAVA_HOME/bin $PATH 

# android
#set -x ANDROID_SDK_ROOT /home/$USER/Android/Sdk
#set -x PATH $PATH $ANDROID_SDK_ROOT/platform-tools
