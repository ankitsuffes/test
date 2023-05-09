#!/bin/bash  
   
 #######################################  
 # Bash script to install an LAMP stack in ubuntu  
 # Author: Subhash (serverkaka.com)  
   
 # Check if running as root  
 if [ "$(id -u)" != "0" ]; then  
   echo "This script must be run as root" 1>&2  
   exit 1  
 fi  
   
 # Ask value for mysql root password   
 read -p 'db_root_password [secretpasswd]: ' db_root_password  
 echo  
   
 # Update system  
 sudo apt update -y  
   
 ## Install APache  
 sudo apt install apache2 ssl-cert -y  
   
 ## Install PHP  
 apt install php8.2-cli php8.2-common libapache2-mod-php php8.2-mysql -y  
   
 # Install MySQL database server  
 export DEBIAN_FRONTEND="noninteractive"  
 debconf-set-selections <<< "mysql-server mysql-server/root_password password $db_root_password"  
 debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $db_root_password"  
 apt-get install mysql-server -y  
   
 # Enabling Mod Rewrite  
 sudo a2enmod rewrite    
   
 ## Install PhpMyAdmin  
 sudo apt install phpmyadmin -y  
   
 ## Configure PhpMyAdmin  
 echo 'Include /etc/phpmyadmin/apache.conf' >> /etc/apache2/apache2.conf  
   
 # Set Permissions  
 sudo chown -R www-data:www-data /var/www  
   
 # Restart Apache  
 sudo service apache2 restart  
