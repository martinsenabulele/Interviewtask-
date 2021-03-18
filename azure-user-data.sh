#! /bin/bash
sudo apt-get update
sudo apt-get install -y curl
sudo apt-get install -y apache2
sudo /etc/init.d/apache2 start
echo "<h1>Demo Bootstrapping Azure Virtual Machine</h1>"