#!/bin/bash
# Save encrypted backup to a Hard Drive and to a server.
# Decrypt: mkdir backup && gpg -d 123456-backup.tar.gpg | tar -C backup -xvf -

folders_and_files="\
  foo_folder \
  .vimrc \
  .bashrc\
  "

hard_drive_path="/path/to/backup/location"

backup_server="user@server"
server_path="backups/laptop"

valid_networks="OfficeWifi HomeWifi"
gpg_key="ABCD1234"

filename="$(date -d "today" +"%Y%m%d%H%M")-backup.tar.gpg"
temp_file="/tmp/${filename}"

echo "[*] Checking available storage locations..."

if [ -d "$hard_drive_path" ]; then
    storage_hard_drive=1
else
    echo "[*] Hard Drive storage location '${hard_drive_path}' not found."
fi

ssh -q -o BatchMode=yes -o ConnectTimeout=10 $backup_server exit
if [[ $? -eq 0 ]]; then
    if [[ $valid_networks =~ $(iwgetid -r) ]]; then
        storage_server=1
    else
        echo "[*] Not in a valid network."
    fi
else
    echo "[*] Couldn't connect to server '${backup_server}."
fi

if [[ ! $storage_hard_drive ]] && [[ ! $storage_server ]]; then
    echo "[*] No storage locations available, exiting!"
    exit 1
fi

echo "[*] Collecting and encrypting files..."
tar -C "$HOME" -c $folders_and_files | gpg -r "$gpg_key" -e -o "$temp_file"

if [[ $storage_hard_drive ]]; then
    echo "[*] Saving to Hard Drive..."
    cp "$temp_file" "$hard_drive_path"
fi

if [[ $storage_server ]]; then
    echo "[*] Saving to server..."
    scp "$temp_file" "${backup_server}:${server_path}"
fi

echo "[*] Cleaning up..."
rm "$temp_file"

echo "[*] Backup done!"
