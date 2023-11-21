import subprocess
import os

service_content = f"""\
[Unit]
Description=server security manager

[Service]
ExecStart={os.path.abspath("venv/bin/python")} {os.path.abspath("main.py")}
Restart=always
WorkingDirectory={os.path.abspath(".")}

[Install]
WantedBy=multi-user.target
"""

def create_systemd_service():
    with open(
        "/etc/systemd/system/server-security-manager.service", "w"
    ) as service_file:
        service_file.write(service_content)


def install_security_manager():
    subprocess.run(["python", "-m", "venv", "venv"])
    subprocess.run(["./venv/bin/pip", "install", "-r", "requirements.txt"])
    create_systemd_service()
    subprocess.run(["sudo", "systemctl", "enable", "server-security-manager"])
    subprocess.run(["sudo", "systemctl", "start", "server-security-manager"])
