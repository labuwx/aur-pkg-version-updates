#!/bin/bash -eux
set -o pipefail

COMMIT_USERNAME="Szabolcs Sipos"
COMMIT_EMAIL="aur@balfug.com"

# set up AUR SSH access
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cat common/aur_ssh_config >> ~/.ssh/config
set +x ; echo "${AUR_GITHUB_KEY}" > ~/.ssh/AUR_GITHUB_KEY ; set -x
chmod 600 ~/.ssh/config ~/.ssh/AUR_GITHUB_KEY

# set up git commiter identity
git config --global user.name "$COMMIT_USERNAME"
git config --global user.email "$COMMIT_EMAIL"
