#!/bin/sh
# Turns the tail of a build log into ::error:: annotations. Job logs need auth
# on this fork; annotations are readable through the public checks API.
log=${1:-build.log}

if [ ! -s "$log" ]; then
  echo "::error::$log is empty"
  exit 0
fi

echo "::error::last lines of $log follow"
# `%` is the escape character inside workflow commands
tail -n 25 "$log" | sed 's/%/%25/g; s/^/::error::/'
