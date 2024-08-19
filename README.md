# v2ray
Automated Script for Installing and Configuring V2Ray on Multiple Servers
فارسی:
اسکریپت خودکار برای نصب و پیکربندی V2Ray روی چندین سرور با استفاده از پنل علیرضا
این اسکریپت فرآیند نصب و پیکربندی V2Ray روی چندین سرور را به صورت همزمان خودکار می‌کند. این اسکریپت از پنل محبوب علیرضا برای نصب V2Ray استفاده می‌کند و به شما این امکان را می‌دهد تا به راحتی V2Ray را در مقیاس بزرگ نصب کنید و اطمینان حاصل کنید که هر سرور به درستی با گواهی‌های SSL و وابستگی‌های مورد نیاز پیکربندی شده است.

مراحل نصب به شرح زیر است:

به‌روزرسانی و ارتقاء بسته‌های سیستم با استفاده از دستور apt update && apt upgrade -y.
نصب ابزارهای مورد نیاز مانند curl و socat.
نصب اسکریپت Acme.sh برای مدیریت گواهی‌های SSL.
ثبت حساب کاربری در Acme.sh با استفاده از ایمیل کاربر.
صدور و نصب گواهی SSL برای دامنه سرور.
نصب V2Ray با استفاده از پنل علیرضا.
این اسکریپت خطاهای احتمالی را به خوبی مدیریت می‌کند، آن‌ها را برای بررسی ثبت می‌کند و راهی ساده برای مدیریت استقرارهای گسترده V2Ray فراهم می‌آورد.

English:
Automated Script for Installing and Configuring V2Ray on Multiple Servers Using Alireza's Panel
This script automates the process of installing and configuring V2Ray across multiple servers simultaneously. It uses the popular Alireza panel for installing V2Ray, allowing you to easily deploy V2Ray on a large scale, ensuring that each server is correctly set up with SSL certificates and the necessary dependencies.

The installation steps are as follows:

Update and upgrade the system packages using the apt update && apt upgrade -y command.
Install required tools like curl and socat.
Install the Acme.sh script for managing SSL certificates.
Register an account with Acme.sh using the user’s email.
Issue and install the SSL certificate for the server's domain.
Install V2Ray using Alireza's panel.
The script handles potential errors gracefully, logs them for review, and provides a streamlined way to manage large-scale V2Ray deployments.

French:
Script automatisé pour l'installation et la configuration de V2Ray sur plusieurs serveurs en utilisant le panel d'Alireza
Ce script automatise le processus d'installation et de configuration de V2Ray sur plusieurs serveurs simultanément. Il utilise le panel populaire d'Alireza pour installer V2Ray, vous permettant de déployer facilement V2Ray à grande échelle, en vous assurant que chaque serveur est correctement configuré avec des certificats SSL et les dépendances nécessaires.

Les étapes d'installation sont les suivantes :

Mettre à jour et mettre à niveau les paquets système avec la commande apt update && apt upgrade -y.
Installer les outils requis tels que curl et socat.
Installer le script Acme.sh pour gérer les certificats SSL.
Enregistrer un compte avec Acme.sh en utilisant l'adresse email de l'utilisateur.
Émettre et installer le certificat SSL pour le domaine du serveur.
Installer V2Ray en utilisant le panel d'Alireza.
Le script gère les erreurs potentielles avec élégance, les consigne pour révision, et fournit une méthode simplifiée pour gérer les déploiements à grande échelle de V2Ray.
