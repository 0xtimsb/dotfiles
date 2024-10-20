alias vim "nvim"

if status is-login
    if test -z "$WAYLAND_DISPLAY" -a "$XDG_VTNR" = 1
        exec sway
    end
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# cursor
function cursor
    command cursor --ozone-platform=wayland $argv
end

# git

function git-push
  git push
end

function git-pull
  git pull
end

function git-fetchAll
  git fetch --all
end

function git-stashPopLatest
  git stash pop
end

function git-stash
  git stash
end

function git-commit
  git commit
end

function git-undoCommit
  git reset --soft HEAD~1
  echo "undo!"
end

function git-merge
  git merge
end

bind \cgp 'git-push; commandline -f repaint'
bind \cg\ep 'git-pull; commandline -f repaint'
bind \cgf 'git-fetchAll; commandline -f repaint'
bind \cgl 'git-stashPopLatest; commandline -f repaint'
bind \cgs 'git-stash; commandline -f repaint'
bind \cg' ' 'git-commit; commandline -f repaint'
bind \cgu 'git-undoCommit; commandline -f repaint'
bind \cgm 'git-merge; commandline -f repaint'

# walk
function lk
  set loc (walk $argv); and cd $loc;
end
set -Ux EDITOR nvim

# zoxide
zoxide init fish | source
