#!/bin/bash

mysql_password=vagrant
first=../first
last=../last

function runDirectory() {
  if [ -z ${1+x} ]; then
     echo "No directory passed";
     return
  else
    if [ ! -d "$1" ]; then
      echo "$1 is not a directory or does not exist; will not run those provisioners";
      return
    fi
  fi

  shopt -s nullglob
  for script in "$1"/*
  do
    if [[ -x "$script" ]]; then
      "$script"
    fi
  done
  shopt -u nullglob
}

runDirectory "$first"


echo  "mysql-server mysql-server/root_password password $mysql_password" | sudo debconf-set-selections #Cahnge the word 'vagrant' here to change the password.
echo  "mysql-server mysql-server/root_password_again password $mysql_password" | sudo debconf-set-selections # Remember to do that here to!

apt-get install python-software-properties

add-apt-repository ppa:ondrej/php5-5.6

apt-get update

apt-get dist-upgrade

apt-get upgrade

apt-get -y install apache2 php5 mysql-server mysql-client php5-mysqlnd php5-xdebug vim git

echo 'zend_extension="/usr/lib/php5/20100525/xdebug.so"' >> /etc/php5/apache2/php.ini
echo 'xdebug.remote_enable=1' >> /etc/php5/apache2/php.ini
echo 'xdebug.remote_handler=dbgp' >> /etc/php5/apache2/php.ini
echo 'xdebug.remote_mode=req' >> /etc/php5/apache2/php.ini
echo 'xdebug.remote_host=10.0.2.2' >> /etc/php5/apache2/php.ini
echo 'xdebug.remote_port=9000' >> /etc/php5/apache2/php.ini
echo 'xdebug.idekey="IntelliJ"' >> /etc/php5/apache2/php.ini
echo 'xdebug.remote_autostart=1' >> /etc/php5/apache2/php.ini

/etc/init.d/apache2 restart

rm /var/www/html/index.html

runDirectory "$last"
