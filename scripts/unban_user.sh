#!/bin/sh

user_host="$1"

if [ -z "$user_host" ]; then
    echo "Usage: $0 <user_host>"
    exit 1
fi

if ! sudo ufw status | grep -q "Status: active"; then
    echo "ufw is not active. Exiting..."
    exit 1
fi

if sudo ufw status | grep -q "$user_host"; then
    sudo ufw delete deny from $user_host
    echo "Rule for $user_host deleted."
else
    echo "Rule for $user_host does not exist."
fi

sudo ufw reload