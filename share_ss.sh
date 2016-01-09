#!/bin/bash
# Screenshot sharing using your own server.
#
# Flags:
# -k : appends "-keep" to the file. This can be usefull in cases where you
#      clean up old screanshots periodically with crontab.

# Config:
readonly remote_path="myserver:/path/to/screenshot/folder/"
readonly public_base_path="https://domain.com/screenshots"


# Setup flags and parse the arguments.
kflag=""

while getopts "k" flag; do
  case "${flag}" in
    k) kflag="true" ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done

# Form the file name and the paths.
readonly tmpdir="/tmp"
readonly seconds=$(date +%s)

if [[ $kflag ]]; then
  readonly filename="${seconds}-keep.png"
else
  readonly filename="${seconds}.png"
fi

readonly tmpfile="$tmpdir/$filename"
readonly public_path="$public_base_path/$filename"

# Take and share the screenshot.
import $tmpfile
scp $tmpfile $remote_path
rm $tmpfile
echo $public_path | xsel --clipboard --input
echo "URL copied to clipboard: $public_path"
