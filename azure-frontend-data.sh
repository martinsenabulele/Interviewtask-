#! /bin/bash
sudo apt-get update
sudo apt-get install -y curl
sudo apt-get install -y apache2
sudo /etc/init.d/apache2 start
sudo sed -i 's/80/443/g' /etc/apache2/ports.conf
sudo sed -i 's/80/443/g' /etc/apache2/sites-enabled/000-default.conf
sudo systemctl restart apache2
echo "<h1>Demo Bootstrapping Azure Virtual Machine</h1>"