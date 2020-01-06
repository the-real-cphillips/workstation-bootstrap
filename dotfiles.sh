#!/usr/bin/env bash

alias config='/usr/bin/git --git-dir=${HOME}/.cfg/ --work-tree=${HOME}'

function config {
  /usr/local/bin/git --git-dir=${HOME}/.cfg/ --work-tree=${HOME}
}

mkdir -p ~/.config-backup
config checkout

if [ $? = 0 ]; then
  echo "[√] Config Checked Out!"
else
  echo "[I] Backing up pre-existing dot files."; \
  config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi

config checkout
config config status.showUntrackedFiles no
