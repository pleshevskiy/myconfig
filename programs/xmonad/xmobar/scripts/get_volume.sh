#!/bin/bash
res=$(amixer -D pulse sget Master)
enabled=$(echo $res | egrep -o "\[on\]" | wc -l)
if [[ $enabled == "0" ]]; then
  echo "off"
else
  echo $(echo $res | egrep -o "[0-9]+%" | head -n 1)
fi
exit 0
