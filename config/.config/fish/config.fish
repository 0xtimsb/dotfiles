
if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec startx -- -keeptty
    end
end

# nvim
alias vim "nvim"

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# zed
alias zed-debug='~/zed/target/debug/zed'

# zoxide
zoxide init fish | source

# gretting
set -g fish_greeting ""

# git
alias ga "git add"
alias gaa "git add --all"
alias gb "git branch"
alias gc "git commit -m"
alias gco "git checkout"
alias gd "git diff"
alias gl "git log"
alias gp "git push"
alias gpl "git pull"
alias gs "git status"
alias gst "git stash"

# cp
alias cp "rsync -ah --info=progress2"

# sync
alias watch 'watch "grep -e Dirty: -e Writeback: /proc/meminfo"'

# java
set -x JAVA_HOME /usr/lib/jvm/java-17-openjdk-17.0.13.0.11-1.fc40.x86_64
set -x PATH $JAVA_HOME/bin $PATH 

# android
set -x ANDROID_SDK_ROOT /home/$USER/Android/Sdk
set -x PATH $PATH $ANDROID_SDK_ROOT/platform-tools
