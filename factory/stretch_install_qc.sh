#!/bin/bash

#pip uninstall stretch-body
echo "Cloning repos."
cd ~/repos/
git clone https://github.com/hello-robot/stretch_install.git
git clone https://github.com/hello-robot/stretch_factory.git
git clone https://github.com/hello-robot/stretch_body.git
git clone https://github.com/hello-robot/stretch_firmware.git
git clone https://github.com/hello-robot/stretch_fleet.git
git clone https://github.com/hello-robot/stretch_production_tools.git
git clone https://github.com/hello-robot/hello-robot.github.io
git clone https://github.com/hello-robot/stretch_docs
echo "Done."
echo ""


