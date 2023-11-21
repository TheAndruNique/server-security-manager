#!/bin/bash
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root. Exiting..."
  exit 1
fi

sudo apt install jq

cp ./scripts/ssh_login.sh /usr/local/bin/ssh_login.sh
chmod +x /usr/local/bin/ssh_login.sh ./scripts/ssh_login.sh ./scripts/ban_user.sh ./scripts/kick_user.sh

echo "session optional pam_exec.so type=open_session seteuid /usr/local/bin/ssh_login.sh" >> /etc/pam.d/common-session

python -m venv venv
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