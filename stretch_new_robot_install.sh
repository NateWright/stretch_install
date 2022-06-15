#!/bin/bash
#This requires the appropriate branch of stretch_install to be cloned to $HOME before running
echo "#############################################"
echo "Starting installation for a new robot."
echo "#############################################"
cd $HOME/stretch_install/factory
./stretch_setup_new_robot.sh
if [ $? -ne 0 ]
then
	exit 1
fi
echo "#############################################"
echo "Done with initial setup. Starting software install."
echo "#############################################"

timestamp=`date '+%Y%m%d%H%M'`;
logdir="$HOME/stretch_user/log/$timestamp"
logfile_system="$logdir/stretch_system_install.txt"
logfile_user="$logdir/stretch_user_install.txt"
logfile_dev_tools="$logdir/stretch_dev_tools_install.txt"
logzip="$logdir/stretch_logs.zip"
echo "#############################################"
echo "Generating log $logfile_system"
echo "Generating log $logfile_user"
echo "Generating log $logfile_dev_tools"
echo "#############################################"
echo ""

mkdir -p $logdir
cd $HOME/stretch_install/factory
./stretch_install_system.sh |& tee $logfile_system
cd $HOME/stretch_install
./stretch_new_user_install.sh |& tee $logfile_user
cd $HOME/stretch_install/factory
./stretch_install_dev_tools.sh |& tee $logfile_dev_tools
echo "Generating $logzip. Include with any support tickets."
zip $logzip $logfile_system $logfile_user $logfile_dev_tools
echo ""

echo "#############################################"
echo "Done. A full reboot is recommended."
echo "#############################################"
echo ""
