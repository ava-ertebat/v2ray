#!/bin/bash

# کد رنگ سبز و ویژگی‌های متنی
GREEN="\033[0;32m"
RESET="\033[0m" # Reset Color to default


echo -e "${GREEN}سلام من امید آخرتی هستم و در این اسکریپت تلاش کردم فرایند نصب پنل V2ray رو برای شما عزیزان هوشمند و ساده بکنم${RESET}"
echo
echo -e "${GREEN}اگر سوال یا کمکی از من بر میومد خوشحال میشم کمک بکنم${RESET}"
echo -e "${GREEN}شماره تماس : 02191013218${RESET}"
echo
echo -e "${GREEN}شماره همراه : 09163422797${RESET}"
echo
echo -e "${GREEN}توی این اسکریپت میشه سرورهای خودتون رو از راه دور کانفیگ کرده و نیازی نیست که تک تک اونها رو مدیریت بکنید${RESET}"
echo
echo -e "${GREEN}اگر فقط یک سرور دارید صرفا آدرس همون سرور رو وارد بکنید${RESET}"
echo
echo -e "${GREEN}اگر بیش از یک سرور دارید اسامی اونها رو توی یک فایل متنی آماده کنید${RESET}"
echo
echo -e "${GREEN}وقتی سیستم لیست دامنه رو از شما درخواست کرد آدرس همه سرور هاتون رو به صورت یکجا وارد کنید${RESET}"
echo
echo -e "${GREEN}برای مثال: server1.google.com server2.google.com server3.yahoo.com v2ray.alireza.com vpn.omid.ir${RESET}"
echo
echo -e "${GREEN}نکته: بین اسم سرور هاتون حتما یک فاصله قرار بدید${RESET}"
echo
echo -e "${GREEN}نکته دوم: اینکه اسم سرور یا همون دامنه شما چی باشه اصلاً مهم نیست. مهم اینه که وقتی پینگ گرفتید آدرس اصلی سرور رو بهتون نشون بده${RESET}"
echo
echo -e "${GREEN}نکته سوم و مهم ترین بخش: در حالتی که بیش از یک سرور دارید، نام کاربری و رمز عبور تمام سرور هاتون باید یکسان باشه${RESET}"


read -p "نام کاربری سرور خود را به انگلیسی وارد کنید (برای مثال root): " ssh_user

echo
read -s -p "رمز عبور سرور خود را وارد کنید (برای مثال swordfish): " ssh_pass
echo

echo
read -p "آدرس ایمیل خود را برای دریافت گواهی SSL وارد کنید (برای مثال omid@akherati.ir): " email

echo
read -p "لیست دامنه یا دامنه‌های خود را وارد کنید (بعد از وارد کردن هر دامنه یک فاصله یا همان (space) قرار دهید): " servers

echo

echo
echo -e "${GREEN}میخوای واست چیکار کنم؟${RESET}"
echo
echo -e "${GREEN}1) تمدید سریع SSL${RESET}"
echo
echo -e "${GREEN}2) نصب V2Ray${RESET}"
read -p "یک عدد را وارد کنید (1 یا 2): " action

echo

if [ "$action" == "2" ]; then
    echo
    echo -e "${GREEN}کدام پنل را میخواهید نصب کنید؟${RESET}"
    echo
    echo -e "${GREEN}1) پنل علیرضا${RESET}"
    echo
    echo -e "${GREEN}2) پنل صنایی${RESET}"
    read -p "یک عدد را وارد کنید (1 یا 2): " panel_choice
fi


error_log=""


for server in $servers
do
    if [ "$action" == "1" ]; then
        echo
        echo -e "${GREEN}تمدید SSL برای $server${RESET}"
        sshpass -p "$ssh_pass" ssh -o StrictHostKeyChecking=no $ssh_user@$server "
            ~/.acme.sh/acme.sh --issue -d $server --standalone --force &&
            ~/.acme.sh/acme.sh --installcert -d $server --key-file /root/private.key --fullchain-file /root/cert.crt
        " || error_log+="خطا در تمدید SSL برای سرور $server\n"
    
    elif [ "$action" == "2" ]; then
        if [ "$panel_choice" == "1" ]; then
            echo
            echo -e "${GREEN}در حال نصب پنل علیرضا در سرور $server${RESET}"
            sshpass -p "$ssh_pass" ssh -o StrictHostKeyChecking=no $ssh_user@$server "
                curl https://get.acme.sh | sh &&
                ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt &&
                ~/.acme.sh/acme.sh --register-account -m $email &&
                ~/.acme.sh/acme.sh --issue -d $server --standalone &&
                ~/.acme.sh/acme.sh --installcert -d $server --key-file /root/private.key --fullchain-file /root/cert.crt &&
                bash <(curl -Ls https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh)
            " || error_log+="خطا در نصب پنل علیرضا در سرور $server\n"
        
        elif [ "$panel_choice" == "2" ]; then
            echo
            echo -e "${GREEN}در حال نصب پنل صنایی در سرور $server${RESET}"
            sshpass -p "$ssh_pass" ssh -o StrictHostKeyChecking=no $ssh_user@$server "
                curl https://get.acme.sh | sh &&
                ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt &&
                ~/.acme.sh/acme.sh --register-account -m $email &&
                ~/.acme.sh/acme.sh --issue -d $server --standalone &&
                ~/.acme.sh/acme.sh --installcert -d $server --key-file /root/private.key --fullchain-file /root/cert.crt &&
                bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh) v2.3.13
            " || error_log+="خطا در نصب پنل صنایی در سرور $server\n"
        else
            echo
            echo -e "${GREEN}خطا در انتخاب پنل!${RESET}"
            exit 1
        fi
    else
        echo
        echo -e "${GREEN}درخواست شما معتبر نیست!${RESET}"
        exit 1
    fi
done


if [ -n "$error_log" ]; then
    echo -e "\n${GREEN}خطاهای دریافتی هنگام نصب پنل:${RESET}"
    echo -e "$error_log"
else
    echo -e "${GREEN}نصب با موفقیت و بدون خطا انجام شد!${RESET}"
fi
