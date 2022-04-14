#!/bin/bash
cd -- $(dirname "$0")

echo "Change dir: $PWD"

jpg_file_names=$(exa -1 | grep jpg)
jpg_file_count=$(exa -1 | grep jpg | wc -l)

if [[ $jpg_file_names != "" && $jpg_file_count != "0" ]]; then
  echo found: $jpg_file_count images
  echo converting to png...

  for f in $jpg_file_names
  do
    echo "  $f -> ${f%.jpg}.png"
    convert "$f" "${f%.jpg}.png"
  done
  echo done
else
  echo nothing to convert
fi
