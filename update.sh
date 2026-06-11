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

# set -e aborts here if the dry-build fails, so anything past this point is good.
echo -e "${GREEN}==> Testing build...${NC}"
sudo nixos-rebuild dry-build --flake ".#${HOSTNAME}"

# Commit and push BEFORE switching, so the running system always matches a
# state that is committed and pushed to the remote (never divergent/dirty).
# The guard means an unchanged flake.lock no longer aborts the script.
if ! git diff --quiet flake.lock; then
    echo -e "${GREEN}==> Committing flake.lock changes...${NC}"
    git add flake.lock
    git commit -m "update"

    echo -e "${GREEN}==> Pushing to remote...${NC}"
    git push
else
    echo -e "${YELLOW}==> No flake.lock changes to commit.${NC}"
fi

echo -e "${GREEN}==> Applying configuration...${NC}"
sudo nixos-rebuild switch --flake ".#${HOSTNAME}"

echo -e "${GREEN}==> Update complete!${NC}"
