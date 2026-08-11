#!/usr/bin/env bash

UPDATES=''
QUANTITY=$(dnf list -q --upgrades | tail -n +2 | wc -l)

[[ $QUANTITY -eq 0 ]] && echo "" || echo "$QUANTITY $UPDATES"
