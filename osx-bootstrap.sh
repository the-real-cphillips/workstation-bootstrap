#!/usr/bin/env bash
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Setup and Install Homebrew
if [ -f /usr/local/bin/brew ]; then
  echo -e "${GREEN}[√]${NC} ${YELLOW}Homebrew already installed!${NC}"
else
  echo -e "${YELLOW}[I]${NC} Installing Homebrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" \
  && echo -e "${GREEN}[√] Homebrew install successful!${NC}" \
  || echo -e "${RED}[X] Homebrew install failed...${NC}"
fi

# Setup and install Ansible
if [ -f /usr/local/bin/ansible ]; then
  echo -e "${GREEN}[√]${NC} ${YELLOW}Ansible already installed!${NC}"
else
  echo -e "${YELLOW}[I]${NC} Installing Ansible..."
  brew install ansible \
  && echo -e "${GREEN}[√] Ansible install successful!${NC}" \
  || echo -e "${RED}[X] Ansible install failed...${NC}"
fi 

# Setup and install Oh-My-Zsh
if [ -d ${HOME}/.oh-my-zsh ]; then
  echo -e "${GREEN}[√]${NC} ${YELLOW}Oh-My-Zsh already installed!${NC}"
else
  echo -e "${YELLOW}[I]${NC} Installing Oh-My-Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" \
  && echo -e "${GREEN}[√] Oh-My-Zsh install successful!${NC}" \
  || echo -e "${RED}[X] Oh-My-Zsh install failed...${NC}"
fi

# Configure all the things and install remaining tools.
ansible-playbook --ask-become-pass playbooks/osx.yml
