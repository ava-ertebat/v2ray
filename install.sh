#!/bin/bash

# دریافت نام کاربری، رمز عبور و ایمیل از کاربر
read -p "Enter your SSH username: " ssh_user
read -s -p "Enter your SSH password: " ssh_pass
echo
read -p "Enter your email for SSL certificate: " email
read -p "Enter the domain names of servers (space-separated): " servers

# انتخاب عملیات
echo "What do you want to do?"
echo "1) Renew SSL"
echo "2) Install V2Ray"
read -p "Choose an option (1 or 2): " action

# متغیر برای ذخیره خطاها
error_log=""

# اجرای عملیات انتخاب شده برای هر سرور
for server in $servers
do
    if [ "$action" == "1" ]; then
        echo "Renewing SSL for $server"
        sshpass -p "$ssh_pass" ssh -o StrictHostKeyChecking=no $ssh_user@$server "
            ~/.acme.sh/acme.sh --issue -d $server --standalone --force &&
            ~/.acme.sh/acme.sh --installcert -d $server --key-file /root/private.key --fullchain-file /root/cert.crt
        " || error_log+="Failed to renew SSL for $server\n"
    
    elif [ "$action" == "2" ]; then
        echo "Installing V2Ray on $server"
        sshpass -p "$ssh_pass" ssh -o StrictHostKeyChecking=no $ssh_user@$server "
            apt update &&
            apt upgrade -y &&
            apt install curl socat -y &&
            curl https://get.acme.sh | sh &&
            ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt &&
            ~/.acme.sh/acme.sh --register-account -m $email &&
            ~/.acme.sh/acme.sh --issue -d $server --standalone &&
            ~/.acme.sh/acme.sh --installcert -d $server --key-file /root/private.key --fullchain-file /root/cert.crt &&
            bash <(curl -Ls https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh)
        " || error_log+="Failed to install V2Ray on $server\n"
    else
        echo "Invalid option selected!"
        exit 1
    fi
done

# نمایش خطاها در پایان
if [ -n "$error_log" ]; then
    echo -e "\nThe following errors occurred during execution:"
    echo -e "$error_log"
else
    echo "All tasks completed successfully without any errors!"
fi
