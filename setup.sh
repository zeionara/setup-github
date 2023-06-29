#!/bin/bash

list_path=${1:-'/etc/apt/sources.list.d/github-cli.list'}
key_path=${2:-'/usr/share/keyrings/githubcli-archive-keyring.gpg'}

ubuntu_key=${3:-23F3D4EA75716059}

echop () {
    echo "🚩 $@"
}

install () {
    # https://github.com/cli/cli/blob/trunk/docs/install_linux.md

    echop 'Installing github cli...'

    sudo apt update && sudo apt install gh -y
}

patch () {
    # Fix the key according to https://github.com/cli/cli/discussions/6222#discussioncomment-4123460

    echop 'Failed to install accoding to the official instructions. Trying to patch keys...'

    sudo sed -iE 's/\s\+signed-by=[^]]\+//g' "$list_path"
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys "$ubuntu_key"
}

type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)

# 1. Add key according to https://github.com/cli/cli/blob/trunk/docs/install_linux.md

echo '🏁 Installing github cli. Setting up keys...'

curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of="$key_path" \
    && sudo chmod go+r "$key_path" \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=$key_path] https://cli.github.com/packages stable main" | sudo tee "$list_path" > /dev/null

# 2. Install the client

# install || patch && install
patch && install

echo '🏁 Operation completed successfully'
