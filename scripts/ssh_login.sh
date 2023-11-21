#!/bin/bash
# Telegram notification
# Send msg when your server load to high
token="6916547330:AAHp7E-WLbevvkQYNyt8Pu_ABmXyfvau-sY" # put your token here
chat_id="1973399220" # your chat_id for sending notification
sendmsg="https://api.telegram.org/bot$token/sendMessage?parse_mode=markdown"
sendfile="https://api.telegram.org/bot$token/sendDocument?parse_mode=markdown"
date="$(date "+%d-%b-%Y-%H:%M")"
caption_file=/tmp/ssh_caption_file.txt
msg=/tmp/ssh_msg_info.txt
curl http://ip-api.com/json/$PAM_RHOST -s -o $caption_file
country=$(cat $caption_file | jq '.country' | sed 's/"//g')
city=$(cat $caption_file | jq '.city' | sed 's/"//g')
org=$(cat $caption_file | jq '.as' | sed 's/"//g')
buttons='{"inline_keyboard": [[{"text": "Kick", "callback_data": "kick_user '$PAM_USER' '$PAM_RHOST'"}], [{"text": "Ban", "callback_data": "ban_user '$PAM_USER' '$PAM_RHOST'"}]]}'
echo -e "📡New SSH login\n*🤖$PAM_USER* logged in on 🖥 *$HOSTNAME* at $date from $PAM_RHOST\n🌎Country:*$country*\n🏙 City=*$city*\n🕋Organisation=*$org*" > $msg
curl $sendmsg -d chat_id=$chat_id -d text="$(<$msg)" --data-urlencode "reply_markup=$buttons"
rm /tmp/ssh_caption_file.txt
rm /tmp/ssh_msg_info.txt