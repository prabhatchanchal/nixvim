#!/bin/sh
# Packs a log into ::error:: annotations. Job logs on this fork need a signed-in
# session to read; annotations are public through the checks API.
[ $# -gt 0 ] || set -- build.log

for log in "$@"; do
  [ -s "$log" ] || continue
  # one annotation per file: %0A is the newline the parser restores, and the
  # line/width caps keep the message inside the annotation size limit
  body=$(tail -n 20 "$log" | tr -d '\r' | cut -c1-160 |
    sed 's/%/%25/g; s/:/%3A/g; s/#/%23/g; s/$/%0A/' | tr -d '\n')
  echo "::error::$(basename "$log") -- $body"
done
