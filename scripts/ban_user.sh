#!/bin/sh

username="$1"
user_host="$2"

if [ -z "$username" ] || [ -z "$user_host"]; then
    echo "Usage: $0 <username> <user_host>"
    exit 1
fi

if ! sudo ufw status | grep -q "Status: active"; then
    sudo ufw enable
fi

if sudo ufw status | grep -q "$user_host"; then
    echo "Rule for $user_host already exists."
else
    sudo ufw insert 1 deny from $user_host || sudo ufw deny from $user_host
fi

sudo ufw reload

pkill -u "$username"