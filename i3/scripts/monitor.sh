#!/usr/bin/env bash
if [[ $(xrandr -q | grep "HDMI-0 connected") ]]; then
  xrandr --output eDP --primary --mode 1366x768 --pos 0x0 --rotate normal --output HDMI-0 --mode 1920x1080 --pos 1366x0 --rotate normal --output VGA-0 --off
else
  xrandr --output eDP --primary --mode 1366x768 --pos 0x0 --rotate normal --output VGA-0 --off
fi
