#!/bin/bash
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root. Exiting..."
  exit 1
fi

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <telegram_bot_token> <chat_id>"
    exit 1
fi

token=$1
chat_id=$2

new_lines="token=\"$1\"\nchat_id=\"$2\""

sed -i "4i$new_lines" ./scripts/ssh_login.sh

echo "TELEGRAM_BOT_TOKEN=$token" > .env

sudo apt-get update
sudo apt-get install python3.10
sudo apt-get install jq
sudo apt-get install python3.10-venv

cp ./scripts/ssh_login.sh /usr/local/bin/ssh_login.sh
chmod +x /usr/local/bin/ssh_login.sh ./scripts/ssh_login.sh ./scripts/ban_user.sh ./scripts/kick_user.sh

echo "session optional pam_exec.so type=open_session seteuid /usr/local/bin/ssh_login.sh" >> /etc/pam.d/common-session

python3 -m venv venv
./venv/bin/pip install -r requirements.txt

current_python=$(pwd)/venv/bin/python

SERVICE_CONTENT="[Unit]
Description=server security manager

[Service]
ExecStart=$current_python $(realpath main.py)
Restart=always
WorkingDirectory=$(realpath .)

[Install]
WantedBy=multi-user.target
"


echo "$SERVICE_CONTENT" > /etc/systemd/system/server-security-manager.service

systemctl daemon-reload

systemctl enable server-security-manager
systemctl start server-security-manager

echo "Service created and started."