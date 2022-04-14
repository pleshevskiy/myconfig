#!/bin/bash
/usr/bin/i3lock -ei $(exa -1 ~/pictures/wallpapers/*.png | awk '{ print $1 }' | sort -R | head -n 1)
