#!/bin/bash
# Set random hostname from predefined list of common hostnames.

readonly old_hostname="$(hostname)"
readonly names=("PC" "pc"\
                "Laptop" "laptop"\
                "Notebook" "notebook"\
                "Computer" "computer")
readonly new_hostname=${names[$RANDOM % ${#names[@]} ]}

hostname "$new_hostname"

sed -i "s/HOSTNAME=.*/HOSTNAME=$new_hostname/g" /etc/sysconfig/network

if grep -q "$old_hostname" /etc/hosts; then
 sed -i "s/$old_hostname/$new_hostname/g" /etc/hosts
else
 echo -e "$(hostname -I | awk '{ print $1 }')\t$new_hostname" >> /etc/hosts
fi
