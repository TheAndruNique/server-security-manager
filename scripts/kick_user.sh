#!/bin/sh

username="$1"

if [ -z "$username" ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

pkill -u "$username"