#! /bin/bash

. /etc/hello-robot/hello-robot.conf
export HELLO_FLEET_ID HELLO_FLEET_ID
export HELLO_FLEET_PATH=$HOME/stretch_user
/usr/bin/python3 $HOME/.local/bin/stretch_xbox_controller_teleop.py

/usr/bin/python $HOME/.local/bin/xbox_dongle_init.py > $HOME/stretch_user/log/xbox_out.log

sleep 1

/usr/bin/python $HOME/.local/bin/stretch_xbox_controller_teleop.py >> $HOME/stretch_user/log/xbox_out.log

