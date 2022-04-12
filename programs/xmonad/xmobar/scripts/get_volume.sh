#!/bin/bash
echo $(amixer -D pulse sget Master | egrep -o "[0-9]+%" | head -n 1)
exit 0
