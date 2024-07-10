#!/bin/bash

cron && tail -f /var/log/cron.log

if [ $# -gt 0 ]; then
  # append relay config if any parameters are given
  streamripper "$@" -d /home/streamripper/destination -D "%a - %T - %A" --quiet -o larger --xs_silence_length=1000 --xs_search_window=6000:6000 --xs_offset=0 --xs_padding=500:0 --codeset-filesys=UTF-8 --codeset-id3=ISO-8859-1 --codeset-metadata=ISO-8859-1 --codeset-relay=ISO-8859-1 -r 8000 -R 0
  echo "streamripper started..."
else
  # otherwise, default to no args (=> help output)
  streamripper
fi
