#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

crontab -l | { cat; echo ""; } | crontab -

bundle exec whenever --update-crontab

cron -f