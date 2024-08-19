#!/bin/bash

# دریافت نام کاربری، رمز عبور و ایمیل از کاربر
read -p "نام کاربری سرور خود را وارد کنید: " ssh_user
read -s -p "رمز عبور سرور خود را وارد کنید: " ssh_pass
echo
read -p "آدرس ایمیل خود را برای دریافت گواهی اس اس ال وارد کنید: " email
read -p "لیست دامنه یا دامنه های خود را وارد کنید (بعد از وارد کردن هر دامنه یک فاصله قرار دهید): " servers

# انتخاب عملیات
echo "میخوای واست چیکار کنم؟"
echo "1) تمدید سریع SSL"
echo "2) نصب V2Ray"
read -p "یک عدد را  وارد کنید (1 or 2): " action

# اگر گزینه نصب V2Ray انتخاب شد، انتخاب پنل مورد نظر
if [ "$action" == "2" ]; then
    echo "کدام پنل را میخواهید نصب کنید؟"
    echo "1) پنل علیرضا"
    echo "2) پنل صنایی"
    read -p "یک عدد را  وارد کنید (1 or 2): " panel_choice
fi

# متغیر برای ذخیره خطاها
error_log=""

# اجرای عملیات انتخاب شده برای هر سرور
for server in $servers
do
    if [ "$action" == "1" ]; then
        echo "تمدید SSL برای $server"
        sshpass -p "$ssh_pass" ssh -o StrictHostKeyChecking=no $ssh_user@$server "
            ~/.acme.sh/acme.sh --issue -d $server --standalone --force &&
            ~/.acme.sh/acme.sh --installcert -d $server --key-file /root/private.key --fullchain-file /root/cert.crt
        " || error_log+="Failed to renew SSL for $server\n"
    
    elif [ "$action" == "2" ]; then
        if [ "$panel_choice" == "1" ]; then
            echo "در حال نصب پنل علیرضا در سرور $server"
            sshpass -p "$ssh_pass" ssh -o StrictHostKeyChecking=no $ssh_user@$server "
                curl https://get.acme.sh | sh &&
                ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt &&
                ~/.acme.sh/acme.sh --register-account -m $email &&
                ~/.acme.sh/acme.sh --issue -d $server --standalone &&
                ~/.acme.sh/acme.sh --installcert -d $server --key-file /root/private.key --fullchain-file /root/cert.crt &&
                bash <(curl -Ls https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh)
            " || error_log+="Failed to install Alireza's V2Ray Panel on $server\n"
        
        elif [ "$panel_choice" == "2" ]; then
            echo "در حال نصب پنل صنایی در سرور $server"
            sshpass -p "$ssh_pass" ssh -o StrictHostKeyChecking=no $ssh_user@$server "
                curl https://get.acme.sh | sh &&
                ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt &&
                ~/.acme.sh/acme.sh --register-account -m $email &&
                ~/.acme.sh/acme.sh --issue -d $server --standalone &&
                ~/.acme.sh/acme.sh --installcert -d $server --key-file /root/private.key --fullchain-file /root/cert.crt &&
                bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh) v2.3.13
            " || error_log+="Failed to install Sanaei's V2Ray Panel on $server\n"
        else
            echo "خطا در انتخاب پنل!"
            exit 1
        fi
    else
        echo "در خواست شما معتبر نیست!"
        exit 1
    fi
done

# نمایش خطاها در پایان
if [ -n "$error_log" ]; then
    echo -e "\n خطا های دریافتی هنگام نصب پنل:"
    echo -e "$error_log"
else
    echo "نصب با موفقیت و بدون خطا انجام شد!"
fi
