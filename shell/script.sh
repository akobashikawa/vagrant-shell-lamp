#!/bin/sh
#
# Unattended install of LAMP
# L: ubuntu (precise32 or similar)
# A: apache2
# M: mysql, phpmyadmin
# P: php5
# Extras: curl (for http test), debconf-utils (for unattended install), git, vim
# 
# Used with vagrant shell provision
# data files in /vagrant/shell/ are required
# /vagrant/shell/log.txt will be writed
# 
# Rulo Kobashikawa <akobashikawa@gmail.com>
# 20140219 - 20140221
# 
export DEBIAN_FRONTEND=noninteractive
PRIVATE_NETWORK_IP=$1
VIRTUALHOST_DOMAIN=$2
MYSQL_ROOT_PASSWORD=$3

echo "# apt-get update" | tee /vagrant/shell/log.txt
apt-get update | tee -a /vagrant/shell/log.txt

echo "================================================================================" | tee -a /vagrant/shell/log.txt
echo "[APACHE, CURL]" | tee -a /vagrant/shell/log.txt
echo "# apt-get -q -y install apache2 curl" | tee -a /vagrant/shell/log.txt
apt-get -q -y install apache2 curl | tee -a /vagrant/shell/log.txt

echo "--------------------------------------------------------------------------------" | tee -a /vagrant/shell/log.txt
echo "[testing apache]" | tee -a /vagrant/shell/log.txt
curl http://localhost | tee -a /vagrant/shell/log.txt

echo "--------------------------------------------------------------------------------" | tee -a /vagrant/shell/log.txt
echo "[customizing apache2]" | tee -a /vagrant/shell/log.txt
cp /vagrant/shell/apache2-conf-fqdn /etc/apache2/conf.d/fqdn
mkdir -p /vagrant/www
ls -ld /vagrant/www
sed "/ServerName/c ServerName ${VIRTUALHOST_DOMAIN}" /vagrant/shell/apache2-virtualhost-development > /etc/apache2/sites-available/development
a2ensite development | tee -a /vagrant/shell/log.txt
a2enmod rewrite | tee -a /vagrant/shell/log.txt
service apache2 reload
echo "127.0.0.1 ${VIRTUALHOST_DOMAIN}" >> /etc/hosts
cp /vagrant/shell/apache2-www-index.html /vagrant/www/index.html

echo "================================================================================" | tee -a /vagrant/shell/log.txt
echo "[PHP]" | tee -a /vagrant/shell/log.txt
echo "# apt-get -q -y install libapache2-mod-php5" | tee -a /vagrant/shell/log.txt
apt-get -q -y install libapache2-mod-php5 | tee -a /vagrant/shell/log.txt
cp /vagrant/shell/phpinfo.php /vagrant/www/

echo "================================================================================" | tee -a /vagrant/shell/log.txt
echo "[MYSQL]" | tee -a /vagrant/shell/log.txt

echo "# apt-get -q -y install debconf-utils" | tee -a /vagrant/shell/log.txt
apt-get -q -y install debconf-utils | tee -a /vagrant/shell/log.txt

#debconf-set-selections <<< 'mysql-server mysql-server/root_password password mysql'
#debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password mysql'
echo "mysql-server mysql-server/root_password password ${MYSQL_ROOT_PASSWORD}" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password ${MYSQL_ROOT_PASSWORD}" | debconf-set-selections

echo "# apt-get -q -y install mysql-server libapache2-mod-auth-mysql php5-mysql" | tee -a /vagrant/shell/log.txt
apt-get -q -y install mysql-server libapache2-mod-auth-mysql php5-mysql | tee -a /vagrant/shell/log.txt
#mysqladmin -u root password mysql

service apache2 restart

echo "--------------------------------------------------------------------------------" | tee -a /vagrant/shell/log.txt
echo "[PHPMYADMIN]" | tee -a /vagrant/shell/log.txt

echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password ${MYSQL_ROOT_PASSWORD}" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password ${MYSQL_ROOT_PASSWORD}" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password ${MYSQL_ROOT_PASSWORD}" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections

echo "# apt-get -q -y install phpmyadmin" | tee -a /vagrant/shell/log.txt
apt-get -q -y install phpmyadmin | tee -a /vagrant/shell/log.txt

echo "================================================================================" | tee -a /vagrant/shell/log.txt
echo "[GIT, VIM]" | tee -a /vagrant/shell/log.txt
echo "# apt-get -q -y install git vim" | tee -a /vagrant/shell/log.txt
apt-get -q -y install git vim | tee -a /vagrant/shell/log.txt

echo "================================================================================"
echo "[READY]"
echo "log saved in shell/log.txt"
echo "Please remember add this to your hosts file: ${PRIVATE_NETWORK_IP} ${VIRTUALHOST_DOMAIN}"

# REFERENCES
# http://akcaprendiendo.blogspot.com/2014/02/vagrant-para-desarrollo-web.html
# http://askubuntu.com/questions/79257/how-do-i-install-mysql-without-a-password-prompt
# http://snowulf.com/2008/12/04/truly-non-interactive-unattended-apt-get-install/
# http://gercogandia.blogspot.com/2012/11/automatic-unattended-install-of.html