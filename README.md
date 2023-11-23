# Server-security manager
Manage ssh connections to your server through Telegram notifications.
### Setting up the project
1. Clone the GitHub repository:
```Bash
git clone https://github.com/theandrunique/server-security-manager
```
2. Navigate to the project directory:
```Bash
cd server-security-manager
```
3. Add execution rights for the installer:
```Bash
chmod +x install.sh
```
4. Run the installer and install all the required dependencies. Provide your Telegram bot token and your Telegram user ID:
```Bash
sudo sh install.sh <token> <your_id>
```
You're done! Check the daemon status:
```Bash
sudo systemctl status server-security-manager
```
### Usage
To unban the IP, use the following command with your Telegram bot:
```Bash
/unban <ip>
```