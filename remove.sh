#!/bin/bash

list_path=${1:-'/etc/apt/sources.list.d/github-cli.list'}
key_path=${2:-'/usr/share/keyrings/githubcli-archive-keyring.gpg'}

if test -f "$list_path"; then
    sudo rm "$list_path"
else
    echo "No file $list_path, can't remove"
fi

if test -f "$key_path"; then
    sudo rm "$key_path"
else
    echo "No file $key_path, can't remove"
fi

if test -z $(which gh); then
    echo "No gh installation available"
else
    sudo apt remove gh -y
fi
