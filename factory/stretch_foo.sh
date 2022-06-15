sudo echo "###########################################"
echo "INSTALLATION OF ROS WORKSPACE"
 # update .bashrc before using catkin tools

if [ ${ROS_DISTRO+x} ]; then
     echo "Updating: Not updating ROS in .bashrc"
     echo ${ROS_DISTRO+x}
else
    echo "UPDATE .bashrc for ROS"

fi
