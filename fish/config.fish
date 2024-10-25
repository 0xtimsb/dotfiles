alias vim "nvim"

if status is-login
    if test -z "$WAYLAND_DISPLAY" -a "$XDG_VTNR" = 1
        exec sway
    end
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# zed
alias zed-debug='~/projects/zed/target/debug/zed'

# walk
function lk
  set loc (walk $argv); and cd $loc;
end
set -Ux EDITOR nvim

# zoxide
zoxide init fish | source
