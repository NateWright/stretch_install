#!/bin/bash

echo "Run this installation for fresh Ubuntu installs only."
#####################################################
DIR=`pwd`
echo "Robot name is:"
hostname
echo -n "Enter fleet id xxxx for stretch-re1-xxxx >"
read id
pre="stretch-re1-"
HELLO_FLEET_ID="$pre$id"

read -p "HELLO_FLEET_ID of $HELLO_FLEET_ID . Proceed with installation (y/n)?" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

echo "HELLO_FLEET_ID=$HELLO_FLEET_ID">>hello-robot.conf
sudo mkdir /etc/hello-robot
sudo mv hello-robot.conf /etc/hello-robot
sudo cp $DIR/../images/stretch_about.png /etc/hello-robot

cd ~/
echo "Expect stretch-re1-xxxx/ to be in $HOME"
sudo cp -rf ~/$HELLO_FLEET_ID /etc/hello-robot

echo "Setting up UDEV rules..."
sudo cp ~/$HELLO_FLEET_ID/udev/*.rules /etc/udev/rules.d
sudo udevadm control --reload

#Startup scripts
sudo cp $DIR/hello_robot_audio.sh /usr/bin
sudo cp $DIR/hello_robot_lrf_off.py /usr/bin
sudo cp $DIR/hello_robot_xbox_teleop.sh /usr/bin
sudo cp $DIR/hello_sudoers /etc/sudoers.d/
sudo cp $DIR/hello_robot_pimu_ping.py /usr/bin/
sudo cp $DIR/hello_robot_pimu_ping.sh /usr/bin/
echo "Done with new robot setup."
echo ""



