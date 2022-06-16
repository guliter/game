#!/bin/bash
echo root:1314521. |sudo chpasswd root
sudo sed -i ‘s/^.*PermitRootLogin.*/PermitRootLogin yes/g’ /etc/ssh/sshd_config;
sudo sed -i ‘s/^.*PasswordAuthentication.*/PasswordAuthentication yes/g’ /etc/ssh/sshd_config;
clear
tput setaf 1; echo "密码：1314521."
sudo reboot
