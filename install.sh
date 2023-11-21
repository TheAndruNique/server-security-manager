#!/bin/bash

python -m venv venv
./venv/bin/pip install -r requirements.txt

SERVICE_CONTENT="[Unit]
Description=server security manager

[Service]
ExecStart=$(realpath venv/bin/python) $(realpath main.py)
Restart=always
WorkingDirectory=$(realpath .)

[Install]
WantedBy=multi-user.target
"

if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root. Exiting..."
  exit 1
fi

echo "$SERVICE_CONTENT" > /etc/systemd/system/server-security-manager.service

systemctl daemon-reload

systemctl enable server-security-manager
systemctl start server-security-manager

echo "Service created and started."