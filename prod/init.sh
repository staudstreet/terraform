#!/bin/bash -xe
# updates & installation
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install nginx git -y

# nginx setup
#cd /usr/share/nginx
cd /var/www/
git clone https://github.com/staudstreet/homepage.git
sudo rm -rf html
mv homepage html
sudo systemctl restart nginx
cd

#firewall
sudo iptables -A INPUT -p tcp --dport 80 --jump ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 --jump ACCEPT

exit 0
