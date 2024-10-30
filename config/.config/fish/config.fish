
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
