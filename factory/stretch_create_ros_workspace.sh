sudo echo "###########################################"
echo "INSTALLATION OF ROS WORKSPACE"
 # update .bashrc before using catkin tools

if [ "$ROS_DISTRO" ]; then
    echo "###########################################"
    echo "UPDATING EXISTING ROS INSTALLATION"
    UPDATING=true
else
    UPDATING=false
    echo "###########################################"
    echo "INSTALLATION OF NEW ROS WORKSPACE"
fi

if [ "$UPDATING" = true ]; then
     echo "Updating: Not updating ROS in .bashrc"
else
    echo "UPDATE .bashrc for ROS"
    echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
    echo "add catkin development workspace overlay to .bashrc"
    echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
    echo "set log level for realsense camera"
    echo "export LRS_LOG_LEVEL=None #Debug" >> ~/.bashrc
    echo "source .bashrc"
    source ~/.bashrc
    source /opt/ros/noetic/setup.bash
    echo "DONE UPDATING .bashrc"
    echo ""
fi

# create the ROS workspace
# see http://wiki.ros.org/ROS/Tutorials/InstallingandConfiguringROSEnvironment
echo "Creating the ROS workspace..."
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/
catkin_make
echo "Source .bash file"
source ~/catkin_ws/devel/setup.bash
echo "Make sure new ROS package is indexed"
rospack profile
echo "Done."
echo ""

echo "Make ROS package"
cd ~/catkin_ws/
catkin_make
echo "Install ROS package"
catkin_make install
echo "Make sure new ROS package is indexed"
rospack profile
echo "DONE INSTALLING ROS_NUMPY FROM GITHUB"
echo ""

# clone the Hello Robot ROS repository
echo "Install the Hello Robot ROS repository"
cd ~/catkin_ws/src/

echo "Cloning stretch_ros repository"
git clone https://github.com/hello-robot/stretch_ros.git -b dev/noetic
cd stretch_ros
git pull

echo "Updating meshes in stretch_ros to this robot batch"
~/catkin_ws/src/stretch_ros/stretch_description/meshes/update_meshes.py

cd ~/catkin_ws/
echo "Make the ROS repository"
catkin_make
echo "Make sure new ROS package is indexed"
rospack profile
echo "Install ROS packages. This is important for using Python modules."
catkin_make install
echo ""

if [ "$UPDATING" = true ]; then
    echo "Not updating URDF"
else
    echo "Setup calibrated robot URDF"
    rosrun stretch_calibration update_uncalibrated_urdf.sh
    #This will grab the latest URDF and calibration files from ~/stretch_user
    #rosrun stretch_calibration update_with_most_recent_calibration.sh
    #Force to run interactive so $HELLO_FLEET_ID is found
    echo "This may fail if doing initial robot bringup. That is OK."
    bash -i ~/catkin_ws/src/stretch_ros/stretch_calibration/nodes/update_with_most_recent_calibration.sh
    echo "--Done--"
fi

# compile Cython code
echo "Compiling Cython code"
cd ~/catkin_ws/src/stretch_ros/stretch_funmap/src/stretch_funmap
./compile_cython_code.sh
echo "Done"

# install scan_tools for laser range finder odometry
echo "INSTALL SCAN_TOOLS FROM GITHUB"
cd ~/catkin_ws/
dd="$HOME/catkin_ws/csm"
if [ -d "$dd" ]
then
    echo "Directory $dd exists."
    cd $dd
    git pull
    if [ $? -ne 0 ]
    then
      echo "Installation failed. Exiting"
	    exit 1
    fi
else
    echo "Cloning the csm github repository."
    cd $HOME/catkin_ws/
    git clone https://github.com/AndreaCensi/csm
    if [ $? -ne 0 ]
    then
      echo "Installation failed. Exiting"
	    exit 1
    fi
fi

echo "Handle csm dependencies."
cd ~/catkin_ws/
rosdep update
rosdep install --from-paths src --ignore-src -r -y
echo "Make csm."
sudo apt --yes install libgsl0-dev
cd ~/catkin_ws/csm/
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local .
make
echo "Install csm."
sudo make install
echo "Cloning the scan_tools github repository."
cd ~/catkin_ws/src/
git clone https://github.com/ccny-ros-pkg/scan_tools.git
cd scan_tools
git pull

echo "Make scan_tools."
cd ~/catkin_ws/
catkin_make
echo "Make sure new ROS packages are indexed"
rospack profile
echo ""

echo "INSTALL SLAMTEC RPLIDAR ROS PACKAGE FROM GITHUB"
echo "Cloning the Slamtec rplidar github repository."
cd ~/catkin_ws/src
git clone https://github.com/Slamtec/rplidar_ros.git
echo "Make the Slamtec rplidar package."
cd ~/catkin_ws
catkin_make
echo "Make sure new ROS packages are indexed."
rospack profile
echo ""

echo "Cloning the gazebo realsense plugin github repository."
cd ~/catkin_ws/src
git clone https://github.com/pal-robotics/realsense_gazebo_plugin
cd ~/catkin_ws
rosdep install --from-paths src --ignore-src -r -y
catkin_make
echo "Make sure new ROS packages are indexed."
rospack profile
echo ""

echo "Initialize URDF and controller calibration parameters to generic uncalibrated defaults."
echo "Create uncalibrated URDF."
rosrun stretch_calibration update_uncalibrated_urdf.sh
rosrun stretch_description xacro_to_urdf.sh 
echo "Copy factory defaults for controller calibration parameters."
cp  `rospack find stretch_core`/config/controller_calibration_head_factory_default.yaml `rospack find stretch_core`/config/controller_calibration_head.yaml
echo "Make sure new ROS packages are indexed"
rospack profile
echo ""

echo "DONE WITH SETTING UP ROS WORKSPACE"
echo "###########################################"
echo ""




# FOR Reference, copied in from stretch_install_user.sh

#echo "###########################################"
#echo "INSTALLATION OF ROS WORKSAPCE"
# # update .bashrc before using catkin tools
#if [ "$UPDATING" = true ]; then
#     echo "Updating: Not updating ROS in .bashrc"
#else
#    echo "UPDATE .bashrc for ROS"
#    echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
#    echo "source /opt/ros/galactic/setup.bash" >> ~/.bashrc
#    echo "add catkin development workspace overlay to .bashrc"
#    echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
#    echo "source ~/ament_ws/install/setup.bash" >> ~/.bashrc
#    echo "set log level for realsense camera"
#    echo "export LRS_LOG_LEVEL=None #Debug" >> ~/.bashrc
#    echo "source .bashrc"
#    source ~/.bashrc
#    source /opt/ros/noetic/setup.bash
#    source /opt/ros/galactic/setup.bash
#    echo "DONE UPDATING .bashrc"
#    echo ""
#fi
#
## create the ROS workspace
## see http://wiki.ros.org/ROS/Tutorials/InstallingandConfiguringROSEnvironment
#echo "Creating the ROS workspace..."
#mkdir -p ~/catkin_ws/src
#cd ~/catkin_ws/
#catkin_make
#echo "Source .bash file"
#source ~/catkin_ws/devel/setup.bash
#echo "Make sure new ROS package is indexed"
#rospack profile
#echo "Done."
#echo ""
#
## clone the Hello Robot ROS repository
#echo "Install the Hello Robot ROS repository"
#cd ~/catkin_ws/src/
#echo "Cloning stretch_ros repository"
#git clone https://github.com/hello-robot/stretch_ros.git -b dev/noetic
#cd stretch_ros
#git pull
#
#echo "Updating meshes in stretch_ros to this robot batch"
#~/catkin_ws/src/stretch_ros/stretch_description/meshes/update_meshes.py
#
#cd ~/catkin_ws/
#echo "Make the ROS repository"
#catkin_make
#echo "Make sure new ROS package is indexed"
#rospack profile
#echo "Install ROS packages. This is important for using Python modules."
#catkin_make install
#echo ""
#
#if [ "$UPDATING" = true ]; then
#    echo "Not updating URDF"
#else
#    echo "Setup calibrated robot URDF"
#    rosrun stretch_calibration update_uncalibrated_urdf.sh
#    #This will grab the latest URDF and calibration files from ~/stretch_user
#    #rosrun stretch_calibration update_with_most_recent_calibration.sh
#    #Force to run interactive so $HELLO_FLEET_ID is found
#    echo "This may fail if doing initial robot bringup. That is OK."
#    bash -i ~/catkin_ws/src/stretch_ros/stretch_calibration/nodes/update_with_most_recent_calibration.sh
#    echo "--Done--"
#fi
#
## compile Cython code
#echo "Compiling Cython code"
#source ~/.bashrc
#cd ~/catkin_ws/src/stretch_ros/stretch_funmap/src/stretch_funmap
#./compile_cython_code.sh
#echo "Done"
#
## install scan_tools for laser range finder odometry
#echo "INSTALL SCAN_TOOLS FROM GITHUB"
#cd ~/catkin_ws/
#echo "Cloning the csm github repository."
#git clone https://github.com/AndreaCensi/csm
#cd csm
#git pull
#
#echo "Handle csm dependencies."
#cd ~/catkin_ws/
#rosdep update
#rosdep install --from-paths src --ignore-src -r --rosdistro noetic -y
#echo "Make csm."
#sudo apt --yes install libgsl0-dev
#cd ~/catkin_ws/csm/
#cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local .
#make
#echo "Install csm."
#sudo make install
#echo "Remove csm source"
#rm -rf ~/catkin_ws/csm
#echo ""
#
#echo "Cloning the scan_tools github repository."
#cd ~/catkin_ws/src/
#git clone https://github.com/ccny-ros-pkg/scan_tools.git
#cd scan_tools
#git pull
#
#echo "Make scan_tools."
#cd ~/catkin_ws/
#catkin_make
#echo "Make sure new ROS packages are indexed"
#rospack profile
#echo ""
#
#echo "INSTALL SLAMTEC RPLIDAR ROS PACKAGE FROM GITHUB"
#echo "Cloning the Slamtec rplidar github repository."
#cd ~/catkin_ws/src
#git clone https://github.com/Slamtec/rplidar_ros.git
#echo "Make the Slamtec rplidar package."
#cd ~/catkin_ws
#catkin_make
#echo "Make sure new ROS packages are indexed."
#rospack profile
#echo ""
#
#echo "Cloning the gazebo realsense plugin github repository."
#cd ~/catkin_ws/src
#git clone https://github.com/pal-robotics/realsense_gazebo_plugin
#cd ~/catkin_ws
#rosdep install --from-paths src --ignore-src -r --rosdistro noetic -y
#catkin_make
#echo "Make sure new ROS packages are indexed."
#rospack profile
#echo ""
#
#echo "Initialize URDF and controller calibration parameters to generic uncalibrated defaults."
#echo "Create uncalibrated URDF."
#rosrun stretch_calibration update_uncalibrated_urdf.sh
#rosrun stretch_description xacro_to_urdf.sh
#echo "Copy factory defaults for controller calibration parameters."
#cp  `rospack find stretch_core`/config/controller_calibration_head_factory_default.yaml `rospack find stretch_core`/config/controller_calibration_head.yaml
#echo "Make sure new ROS packages are indexed"
#rospack profile
#echo ""
#
## create the ROS 2 workspace
## see https://docs.ros.org/en/galactic/Tutorials/Workspace/Creating-A-Workspace.html
#echo "Creating the ROS 2 workspace..."
#mkdir -p ~/ament_ws/src
#cd ~/ament_ws/
#colcon build
#echo "Source .bash file"
#source ~/ament_ws/install/setup.bash
#echo "Done."
#echo ""
#
#echo "INSTALL SLAMTEC RPLIDAR ROS 2 PACKAGE FROM GITHUB"
#echo "Cloning the Slamtec rplidar github repository."
#cd ~/ament_ws/src
#git clone https://github.com/hello-chintan/sllidar_ros2.git
#echo "Make the Slamtec rplidar package."
#cd ~/ament_ws
#colcon build
#echo ""

# TODO:
# # clone the Hello Robot ROS repository
# echo "Install the Hello Robot ROS repository"
# cd ~/ament_ws/src/
# echo "Cloning stretch_ros repository"
# git clone https://github.com/hello-robot/stretch_ros2.git
# cd stretch_ros2
# git pull

# TODO:
# echo "Updating meshes in stretch_ros to this robot batch"
# ~/catkin_ws/src/stretch_ros/stretch_description/meshes/update_meshes.py

# TODO:
# cd ~/ament_ws/
# echo "Make the ROS repository"
# colcon build
# echo "Source .bash file"
# source ~/ament_ws/install/setup.bash
# echo ""

# TODO:
# if [ "$UPDATING" = true ]; then
#     echo "Not updating URDF"
# else
#     echo "Setup calibrated robot URDF"
#     rosrun stretch_calibration update_uncalibrated_urdf.sh
#     #This will grab the latest URDF and calibration files from ~/stretch_user
#     #rosrun stretch_calibration update_with_most_recent_calibration.sh
#     #Force to run interactive so $HELLO_FLEET_ID is found
#     echo "This may fail if doing initial robot bringup. That is OK."
#     bash -i ~/catkin_ws/src/stretch_ros/stretch_calibration/nodes/update_with_most_recent_calibration.sh
#     echo "--Done--"
# fi

# TODO:
# # compile Cython code
# echo "Compiling Cython code"
# source ~/.bashrc
# cd ~/catkin_ws/src/stretch_ros/stretch_funmap/src/stretch_funmap
# ./compile_cython_code.sh
# echo "Done"

# TODO:
# echo "Cloning the scan_tools github repository."
# cd ~/catkin_ws/src/
# git clone https://github.com/ccny-ros-pkg/scan_tools.git
# cd scan_tools
# git pull

# TODO:
# echo "Make scan_tools."
# cd ~/catkin_ws/
# catkin_make
# echo "Make sure new ROS packages are indexed"
# rospack profile
# echo ""

# TODO:
# echo "Cloning the gazebo realsense plugin github repository."
# cd ~/catkin_ws/src
# git clone https://github.com/pal-robotics/realsense_gazebo_plugin
# cd ~/catkin_ws
# rosdep install --from-paths src --ignore-src -r -y
# catkin_make
# echo "Make sure new ROS packages are indexed."
# rospack profile
# echo ""

# TODO:
# echo "Initialize URDF and controller calibration parameters to generic uncalibrated defaults."
# echo "Create uncalibrated URDF."
# rosrun stretch_calibration update_uncalibrated_urdf.sh
# rosrun stretch_description xacro_to_urdf.sh
# echo "Copy factory defaults for controller calibration parameters."
# cp  `rospack find stretch_core`/config/controller_calibration_head_factory_default.yaml `rospack find stretch_core`/config/controller_calibration_head.yaml
# echo "Make sure new ROS packages are indexed"
# rospack profile
# echo ""

#echo "Get all rosdep dependencies"
#rosdep install --from-paths src --ignore-src -r --rosdistro galactic -y
#echo ""
#
#echo "DONE WITH ROS WORKSPACE"
#echo "###########################################"
#echo ""
#
#echo "DONE WITH STRETCH_USER_INSTALL"
#echo "###########################################"
#echo ""
