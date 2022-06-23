![](./images/banner.png)

## Overview

The stretch_install repository provides scripts required to install the Stretch software. There primary install scripts are:

| Script                           | Use                                                          |
| -------------------------------- | ------------------------------------------------------------ |
| stretch_new_user_install.sh      | Installs the Stretch packages and robot configuration required for a new user account. |
| stretch_update.sh                | Updates system packages (apt-get) and user packages (Pip). Updates ROS and related packages.  Run periodically when Stretch package updates are available. |
| stretch_new_robot_install.sh     | Installs the entire Stretch software stack on a fresh OS install of Ubuntu 18.04LTS. |
| stretch_new_dex_wrist_install.sh | Configures the robot to work with a new DexWrist ([see User Guide here first](https://docs.hello-robot.com/dex_wrist_user_guide/)) |

It is expected that `stretch_new_robot_install.sh` and `stretch_update.sh` may be run periodically. In contrast, running`stretch_new_robot_install.sh` should be a rare event and should only by done under the guidance of Hello Robot support.

**Note**: The repo `stretch_install` supports both Ubuntu 18.04LTS and Ubuntu 20.04LTS. The instructions here are for 18.04. For Ubuntu 20.04 see the [20.04 branch of Stretch Install](https://github.com/hello-robot/stretch_install/tree/install_20.04)

## New User Install

While logged in as an administrator, make a new user account:
```bash
sudo adduser <new_user>
```

Ensure the user has sudo privileges:

```bash
sudo usermod -aG sudo <new_user>
```

Logout and the log back in as the new user. Then pull down the Stretch_Install repository and run the install script

```bash
cd ~/
git clone https://github.com/hello-robot/stretch_install -b dev/install_18.04_RE1.5
cd stretch_install
./stretch_new_user_install.sh
```

This will install the packages and setup the robot configuration correctly for a new user on a Stretch RE1 computer.

Reboot your computer. After power up, check that the new install worked. For example:
```bash
>> stretch_robot_system_check.py
```

## Stretch Software Update

Hello Robot will periodically release updates of the Stretch packages. In order to update to the latest version, first pull down the latest installation scripts (clone the repo first if it isn't present)

```bash
cd ~/repos
git clone https://github.com/hello-robot/stretch_install -b dev/install_18.04_RE1.5
git pull
```

Next, run the update:

```bash
cd stretch_install
./stretch_update.sh
```

Reboot your computer. After power up, check that the new install worked. For example:

```bash
>> stretch_robot_system_check.py
```

**WARNING**: Running Stretch Update will also update system wide packages via apt-get. This may impact other user accounts on the robot. In addition, it may require separate [updating of the Stretch Firmware](https://github.com/hello-robot/stretch_firmware/blob/master/tutorials/docs/updating_firmware.md).

## New Robot Install 

A fresh OS install should only be done under the guidance of Hello Robot Support. The steps are:

* [Setup the BIOS](./docs/configure_BIOS.md)  (only necessary for NUCs not previously configured by Hello Robot)
* [Install  Ubuntu 18.04LTS](./docs/install_ubuntu_18.04.md)
* Run the `stretch_new_robot_install.sh` script (below)

First you will need to know the serial number of your robot (eg, stretch-re1-1001). 

Login to the `hello-robot` user account and install git

```bash
sudo apt install git
```

**Note**: The system may not be able to run 'apt-get' immediately after a reboot as the OS may be running automatic updates in the background.

Next, pull down the `stretch_install` repository and being the installation process:

```bash
cd ~/
git clone https://github.com/hello-robot/stretch_install -b dev/install_18.04_RE1.5
cd stretch_install
./stretch_new_robot_install.sh
```


## License

All Hello Robot installation materials are released under the GNU General Public License v3.0 (GNU GPLv3). Details can be found in the LICENSE file.

