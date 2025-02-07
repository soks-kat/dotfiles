#!/bin/env bash

cd "$(dirname $0)"
dir=`pwd`

function create_symlink() {
    if [ -e "$2" ]; then
        echo "Removing $2"
        rm -ri "$2"
    fi
    ln -s "$dir/$1" "$2"
}

create_symlink i3 ~/.config/regolith3/i3
create_symlink i3 ~/.config/i3

create_symlink nvim ~/.config/nvim

create_symlink kanata ~/.config/kanata
create_symlink kanata/kanata.service ~/.config/systemd/user/kanata.service
systemctl --user enable kanata

create_symlink wezterm ~/.config/wezterm
create_symlink polybar ~/.config/polybar
create_symlink picom ~/.config/picom

