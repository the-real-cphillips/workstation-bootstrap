#!/usr/bin/env bash
# shellcheck disable=SC2230,SC1083

cd "${HOME}" || exit 1

alias config='/usr/bin/git --git-dir="${HOME}"/.cfg/ --work-tree="${HOME}"'

function config {
  $(which git) --git-dir="${HOME}"/.cfg/ --work-tree="${HOME}" "$@"
}

if [[ ! -d ~/.config-backup ]]; then
  mkdir -p ~/.config-backup
fi

if config checkout; then
  echo "[√] Config Checked Out!"
else
  echo "[I] Backing up pre-existing dot files."
  while IFS= read -r conflict; do
    mkdir -p ".config-backup/$(dirname "${conflict}")"
    mv "${conflict}" ".config-backup/${conflict}"
  done < <(config checkout 2>&1 | grep -E "\s+\." | awk '{print $1}')
fi

config checkout

config config status.showUntrackedFiles no
