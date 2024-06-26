#!/bin/bash

cron && tail -f /var/log/cron.log

if [ $# -gt 0 ]; then
  # append relay config if any parameters are given
  streamripper "$@" -r 8000 -R 0
  echo "streamripper started..."
else
  # otherwise, default to no args (=> help output)
  streamripper
fi
