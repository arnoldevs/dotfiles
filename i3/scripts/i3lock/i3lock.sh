#!/usr/bin/env bash

scrot -o /tmp/locking_screen.png
convert -blur 0x8 /tmp/locking_screen.png /tmp/screen_blur.png
i3lock -i /tmp/screen_blur.png -n
