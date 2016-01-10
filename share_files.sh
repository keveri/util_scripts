#!/bin/bash
# Share files using your own server.
#
# Flags:
# -f : a file or list of files in a string.
# -s : use the secret location for files.
#
# Examples:
# ./share_files -f file
# ./share_files -f "file1 file2"
# ./share_files -s -f secret_file

# Config:
readonly server_name="myserver"
readonly share_path="/path/to/shared/location/"
readonly public_folder="public/"
readonly secret_folder="secret/"


# Setup flags and parse the arguments.
sflag=""
files=""

while getopts "sf:" flag; do
  case "${flag}" in
    s) sflag="true" ;;
    f) files="${OPTARG}" ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done

# Form a destination for the files.
dest=$share_path

if [[ $sflag ]]
then
  dest="$dest$secret_folder"
else
  dest="$dest$public_folder"
fi

# Copy the files to the server.
scp "$files" "$server_name:$dest"
