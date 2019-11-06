#!/usr/bin/env bash

# Setup and Install Homebrew
if [ -f /usr/local/bin/brew ]; then
  echo "[√] Homebrew already installed!"
else
  echo "[I] Installing Homebrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" \
    && echo "[√] Homebrew install successful!" \
    || echo "[X] Homebrew install failed..."
fi

# Setup and install Ansible
if [ -f /usr/local/bin/ansible ]; then
  echo "[√] Ansible already installed!"
else
  echo "[I] Installing Ansible..."
  brew install ansible \
  && echo "[√] Ansible install successful!" \
  || echo "[X] Ansible install failed..."
fi 

# Setup and install Oh-My-Zsh
if [ -d ${HOME}/.oh-my-zsh ]; then
  echo "[√] Oh-My-Zsh already installed!"
else
  echo "Installing Oh-My-Zsh!..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" \
    && echo "[√] Oh-My-ZSH Install Successfully!" \
    || echo "[X] Oh-My-Zsh Install Failed... "
fi

# Configure all the things and install remaining tools.
ansible-playbook --ask-become-pass playbooks/workstation-osx.yaml
