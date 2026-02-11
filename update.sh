#!/usr/bin/env bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}==> Checking for local modifications...${NC}"
if [[ -n $(git status --porcelain) ]]; then
    echo -e "${RED}Error: Local modifications detected. Commit or stash them first.${NC}"
    git status --short
    exit 1
fi

echo -e "${GREEN}==> Pulling latest changes...${NC}"
git pull --rebase

echo -e "${GREEN}==> Updating flake inputs...${NC}"
nix flake update

echo -e "${GREEN}==> Detecting hostname...${NC}"
HOSTNAME=$(hostname)
echo -e "Building for host: ${YELLOW}${HOSTNAME}${NC}"

echo -e "${GREEN}==> Testing build...${NC}"
sudo nixos-rebuild dry-build --flake ".#${HOSTNAME}"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}==> Build test passed! Committing changes...${NC}"
    git add flake.lock
    git commit -m "update"

    echo -e "${GREEN}==> Pushing to remote...${NC}"
    git push

    echo -e "${GREEN}==> Applying configuration...${NC}"
    sudo nixos-rebuild switch --flake ".#${HOSTNAME}"

    echo -e "${GREEN}==> Update complete!${NC}"
else
    echo -e "${RED}==> Build test failed. Not committing or applying changes.${NC}"
    exit 1
fi
