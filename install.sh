#!/bin/bash

# رنگ‌ها و فرمت‌ها
GREEN="\033[0;32m"
YELLOW="\033[1;33m"  
RED="\033[1;31m"    
BOLD="\033[1m"       
RESET="\033[0m"     

# تابع برای وسط‌چین کردن متن
center_text() {
    local text="$1"
    local terminal_width=$(tput cols)
    local text_length=${#text}
    local padding=$(( (terminal_width - text_length) / 2 ))
    printf "%${padding}s%s\n" "" "$text"
}

# تابع برای چاپ شماره با رنگ مشخص
print_number() {
    local number="$1"
    local color="$2"
    echo -e "${color}${number}${RESET}"
}

# تابع نمایش لودینگ
show_loading() {
    local pid=$1
    local delay=0.1
    local spinner=( '|' '/' '-' '\' )

    while [ -d /proc/$pid ]; do
        for i in "${spinner[@]}"; do
            echo -ne "\r$i"
            sleep $delay
        done
    done
    echo -ne "\r"
}

# تابع نصب پنل
install_panel() {
    local server="$1"
    local panel_choice="$2"

    if [ "$panel_choice" == "1" ]; then
        echo
        echo "در حال نصب پنل علیرضا در سرور $server"
        sshpass -p "$ssh_pass" ssh -o StrictHostKeyChecking=no $ssh_user@$server "
            curl -Ls https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh | bash 2>&1
        " & pid=$!
        show_loading $pid || error_log+="خطا در نصب پنل علیرضا در سرور $server\n"
    
    elif [ "$panel_choice" == "2" ]; then
        echo
        echo "در حال نصب پنل صنایی در سرور $server"
        sshpass -p "$ssh_pass" ssh -o StrictHostKeyChecking=no $ssh_user@$server "
            curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh | bash 2>&1
        " & pid=$!
        show_loading $pid || error_log+="خطا در نصب پنل صنایی در سرور $server\n"
    else
        echo
        echo "خطا در انتخاب پنل!"
        exit 1
    fi
}

# تابع دریافت اطلاعات کاربر
get_user_input() {
    read -p "نام کاربری سرور خود را به انگلیسی وارد کنید:(برای مثال root) " ssh_user
    echo
    read -s -p "رمز عبور سرور خود را وارد کنید:(برای مثال swordfish) " ssh_pass
    echo
    read -p "آدرس ایمیل خود را برای دریافت گواهی SSL وارد کنید:(برای مثال omid@akherati.ir) " email
    echo
    read -p "لیست دامنه یا دامنه‌های خود را وارد کنید (بعد از وارد کردن هر دامنه یک فاصله یا همان (space) قرار دهید): " servers
    echo

    echo "می‌خواهید چه کاری انجام دهم؟"
    echo
    echo "1) تمدید سریع SSL"
    echo
    echo "2) نصب V2Ray"
    echo
    read -p "یک عدد را وارد کنید (1 یا 2): " action
    echo

    if [ "$action" == "2" ]; then
        echo
        echo "کدام پنل را می‌خواهید نصب کنید؟"
        echo
        echo "1) پنل علیرضا"
        echo
        echo "2) پنل صنایی"
        read -p "یک عدد را وارد کنید (1 یا 2): " panel_choice
    fi
}

clear

# خوشامدگویی
center_text "${BOLD}${GREEN}سلام من امید آخرتی هستم و در این اسکریپت تلاش کردم فرایند نصب پنل V2ray رو برای شما عزیزان هوشمند و ساده بکنم${RESET}"
echo
center_text "${BOLD}${GREEN}اگر سوال یا کمکی از من بر میومد خوشحال میشم کمک بکنم${RESET}"
echo

# شماره تماس و همراه
center_text "$(print_number "شماره تماس : 02191013218" "$YELLOW")"
echo
center_text "$(print_number "شماره همراه : 09163422797" "$RED")"
echo

# توضیحات
echo -e "${BOLD}${GREEN}توی این اسکریپت میشه سرور های خودتون رو از راه دور کانفیگ کرده و نیازی نیست که تک تک اونها رو مدیریت بکنید${RESET}"
echo
echo -e "${BOLD}${GREEN}اگر فقط یک سرور دارید صرفا آدرس همون سرور رو وارد بکنید${RESET}"
echo
echo -e "${BOLD}${GREEN}اگر بیش از یک سرور دارید اسامی اونها رو توی یک فایل متنی آماده کنید${RESET}"
echo
echo -e "${BOLD}${GREEN}وقتی سیستم لیست دامنه رو از شما درخواست کرد آدرس همه سرور هاتون رو به صورت یکجا وارد کنید${RESET}"
echo
echo -e "${BOLD}${GREEN}برای مثال: server1.google.com server2.google.com server3.yahoo.com v2ray.alireza.com vpn.omid.ir${RESET}"
echo
echo -e "${BOLD}${GREEN}نکته: بین اسم سرور هاتون حتما یک فاصله قرار بدید${RESET}"
echo
echo -e "${BOLD}${GREEN}نکته دوم: اینکه اسم سرور یا همون دامنه شما چی باشه اصلاً مهم نیست، مهم اینه که وقتی پینگ گرفتید آدرس اصلی سرور رو بهتون نشون بده${RESET}"
echo
echo -e "${BOLD}${GREEN}نکته سوم و مهم ترین بخش: در حالتی که بیش از یک سرور دارید، نام کاربری و رمز عبور تمام سرور هاتون باید یکسان باشه${RESET}"
echo
echo
echo
echo
echo
echo
echo

# متغیر برای ذخیره خطاها
error_log=""

# دریافت ورودی‌های کاربر برای بار اول
get_user_input

while true; do
    # اجرای عملیات انتخاب شده برای هر سرور
    for server in $servers; do
        if [ "$action" == "1" ]; then
            echo
            echo "تمدید SSL برای $server"
            sshpass -p "$ssh_pass" ssh -o StrictHostKeyChecking=no $ssh_user@$server "
                ~/.acme.sh/acme.sh --issue -d $server --standalone --force &&
                ~/.acme.sh/acme.sh --installcert -d $server --key-file /root/private.key --fullchain-file /root/cert.crt
            " & pid=$!
            show_loading $pid || error_log+="خطا در تمدید SSL برای سرور $server\n"
        
        elif [ "$action" == "2" ]; then
            install_panel "$server" "$panel_choice"
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

    # سوال برای پیکربندی سرور دیگر
    echo
    read -p "آیا سرور دیگری برای پیکربندی وجود دارد؟ (بله/خیر): " more_servers
    if [ "$more_servers" == "خیر" ]; then
        echo "اسکریپت پایان یافت."
        break
    fi

    # سوال در مورد تغییر نام کاربری و رمز عبور
    echo
    read -p "آیا نام کاربری و رمز عبور جدید دارید؟ (بله/خیر): " new_credentials
    if [ "$new_credentials" == "بله" ]; then
        get_user_input
    else
        read -p "آدرس سرور جدید را وارد کنید: " new_server
        servers="$new_server"
    fi
done
