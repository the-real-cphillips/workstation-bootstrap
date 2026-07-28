#!/usr/bin/env bash
# shellcheck disable=SC2230
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

OS=$(uname)
IS_WSL=false
if [[ "${OS}" == 'Linux' ]] && grep -qi microsoft /proc/version 2>/dev/null; then
  IS_WSL=true
fi

function brew_setup() {
  # Setup and Install Homebrew
  if command -v brew >/dev/null 2>&1; then
    echo -e "${GREEN}[√]${NC} ${YELLOW}Homebrew already installed!${NC}"
  else
    echo -e "${YELLOW}[I]${NC} Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
    echo -e "${GREEN}[√] Homebrew install successful!${NC}" || \
    echo -e "${RED}[X] Homebrew install failed...${NC}"
  fi
}

function ansible_setup() {
  # Setup and install Ansible
  if command -v ansible >/dev/null 2>&1; then
    echo -e "${GREEN}[√]${NC} ${YELLOW}Ansible already installed!${NC}"
  else
    echo -e "${YELLOW}[I]${NC} Installing Ansible..."
    brew install ansible && \
    echo -e "${GREEN}[√] Ansible install successful!${NC}" || \
    echo -e "${RED}[X] Ansible install failed...${NC}"
  fi
}

function zsh_setup() {
  # Oh My Zsh's installer hard-fails if zsh isn't already present, and on
  # Linux nothing installs zsh before that point otherwise.
  if command -v zsh >/dev/null 2>&1; then
    echo -e "${GREEN}[√]${NC} ${YELLOW}zsh already installed!${NC}"
  else
    echo -e "${YELLOW}[I]${NC} Installing zsh..."
    sudo apt -y install zsh && \
    echo -e "${GREEN}[√] zsh install successful!${NC}" || \
    echo -e "${RED}[X] zsh install failed...${NC}"
  fi
}

# Setup and install Oh-My-Zsh
if [[ "${OS}" != 'Darwin' ]]; then
  zsh_setup
fi
if [ -d "${HOME}"/.oh-my-zsh ]; then
  echo -e "${GREEN}[√]${NC} ${YELLOW}Oh-My-Zsh already installed!${NC}"
else
  echo -e "${YELLOW}[I]${NC} Installing Oh-My-Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
  && echo -e "${GREEN}[√] Oh-My-Zsh install successful!${NC}" \
  || echo -e "${RED}[X] Oh-My-Zsh install failed...${NC}"
fi

# Configure all the things and install remaining tools.
# Cache the sudo ticket up front rather than using --ask-become-pass:
# Ansible's become-password-prompt detection doesn't reliably recognize
# its own custom sudo prompt on every system and can time out even though
# a real password prompt is sitting on screen.
sudo -v
if [[ "${OS}" == 'Darwin' ]]; then
  brew_setup
  ansible_setup
  ansible-playbook playbooks/osx.yml
else
  sudo apt -y install ansible
  if [[ "${IS_WSL}" == true ]]; then
    echo -e "${YELLOW}[I]${NC} WSL2 detected."
  fi
  ansible-playbook playbooks/linux.yml -e "is_wsl=${IS_WSL}"
fi
