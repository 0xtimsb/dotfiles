
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
alias zed-debug='~/projects/zed/target/debug/zed'

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