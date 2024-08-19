#!/bin/bash

# دریافت نام کاربری، رمز عبور و ایمیل از کاربر
echo سلام من امید آخرتی هستم و در این اسکریپت تلاش کردم فرایند نصب پنل V2ray رو برای شما عزیزان هوشمند و ساده بکنم
echo
echo اگر سوال یا کمکی از من بر میومد خوشحال میشم کمک بکنم
echo  شماره تماس : 02191013218
echo
echo
echo  شماره همراه : 09163422797
echo
echo
echo توی این اسکریپت میشه سرور های خودتون رو از راه دور کانفیگ کرده و نیازی نیست که تک تک اونها رو مدیریت بکنید
echo
echo
echo اگر فقط یک سرور دارید صرفا آدرس همون سرور رو وارد بکنید
echo
echo
echo  اگر بیش از یک سرور دارید اسامی اونها رو توی یک فایل متنی آماده کنید
echo
echo
echo
echo وقتی سیستم لیست دامنه رو از شما درخواست کرد آدرس همه سرور هاتون رو به صورت یکجا وارد کنید
echo
echo
echo
echo برای مثال server1.google.com server2.google.com server3.yahoo.com v2ray.alireza.com vpn.omid.ir
echo
echo
echo
echo نکته: بین اسم سرور هاتون حتما یک فاصله قرار بدید
echo
echo نکته دوم : اینکه اسم سرور  یا همون دامنه شما چی باشه اصلا مهم نیست  مهم اینه که وقتی پینگ گرفتید آدرس اصلی سرور رو بهتون نشون بده
echo
echo
echo نکته سوم و مهم ترین بخش در حالتی که بیش از یک سرور دارید  نام کاربری و رمز عبور تمام سرور هاتون باید یکسان باشه
read -p " نام کاربری سرور خود را به انگلیسی وارد کنید:(برای مثال root) " ssh_user

echo
read -s -p " رمز عبور سرور خود را وارد کنید:(برای مثال swordfish) " ssh_pass
echo

echo
read -p " آدرس ایمیل خود را برای دریافت گواهی SSL وارد کنید:(برای مثال omid@akherati.ir) " email

echo
read -p "لیست دامنه یا دامنه های خود را وارد کنید (بعد از وارد کردن هر دامنه یک فاصله یا همان (space) قرار دهید): " servers
echo
# انتخاب عملیات
echo
echo "میخوای واست چیکار کنم؟"
echo
echo
echo "1) تمدید سریع SSL"
echo
echo
echo "2) نصب V2Ray"
echo
echo
read -p "یک عدد را وارد کنید (1 یا 2): " action
echo
# اگر گزینه نصب V2Ray انتخاب شد، انتخاب پنل مورد نظر
if [ "$action" == "2" ]; then
    echo
    echo "کدام پنل را میخواهید نصب کنید؟"
    echo
    echo
    echo "1) پنل علیرضا"
    echo
    echo
    echo "2) پنل صنایی"
    read -p "یک عدد را وارد کنید (1 یا 2): " panel_choice
fi

# متغیر برای ذخیره خطاها
error_log=""

# اجرای عملیات انتخاب شده برای هر سرور
for server in $servers
do
    if [ "$action" == "1" ]; then
        echo
        echo "تمدید SSL برای $server"
        sshpass -p "$ssh_pass" ssh -o StrictHostKeyChecking=no $ssh_user@$server "
            ~/.acme.sh/acme.sh --issue -d $server --standalone --force &&
            ~/.acme.sh/acme.sh --installcert -d $server --key-file /root/private.key --fullchain-file /root/cert.crt
        " || error_log+="خطا در تمدید SSL برای سرور $server\n"
    
    elif [ "$action" == "2" ]; then
        if [ "$panel_choice" == "1" ]; then
            echo
            echo "در حال نصب پنل علیرضا در سرور $server"
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
            echo "در حال نصب پنل صنایی در سرور $server"
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
            echo "خطا در انتخاب پنل!"
            exit 1
        fi
    else
        echo
        echo "درخواست شما معتبر نیست!"
        exit 1
    fi
done

# نمایش خطاها در پایان
if [ -n "$error_log" ]; then
    echo -e "\nخطاهای دریافتی هنگام نصب پنل:"
    echo -e "$error_log"
else
    echo "نصب با موفقیت و بدون خطا انجام شد!"
fi
