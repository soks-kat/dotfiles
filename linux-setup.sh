#!/bin/env bash

cd "$(dirname "$0")"

function create_symlink() {
    if [ -e "$2" ]; then
        echo "Removing $2"
        rm -ri "$2"
    fi
    ln -sf "$1" "$2"
}

create_symlink ./i3 ~/.config/regolith3/i3
create_symlink ./i3 ~/.config/i3

create_symlink ./nvim ~/.config/nvim

create_symlink ./kanata ~/.config/kanata
# if [ -e /lib/systemd/system/kanata.service ]; then
#     sudo rm /lib/systemd/system/kanata.service
# fi
# ln -s ./kanata/kanata.service /lib/systemd/system/
# sudo systemctl enable kanata

create_symlink ./wezterm ~/.config/wezterm
create_symlink ./polybar ~/.config/polybar

