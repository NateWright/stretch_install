#!/bin/bash

#####################################################
echo "Installs common tools used for internal Hello Robot development"
read -p "Proceed with installation (y/n)?" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

# install  typora
wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
sudo add-apt-repository 'deb https://typora.io/linux ./'
sudo apt-get update
sudo apt install --yes typora

sudo apt install --yes mkdocs
sudo apt install --yes chromium-browser

#Install arduino
./stretch_install_arduino.sh

#Install PyCharm
sudo snap install pycharm-community --classic

echo "Install tools for system QC and bringup "
pip3 install twine --user --upgrade twine
pip3 install gspread
pip3 install gspread-formatting
pip3 install oauth2client rsa==3.4

echo ""


