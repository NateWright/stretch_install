#!/usr/bin/env python

from __future__ import print_function
import stretch_body.hello_utils
import argparse
from os.path import exists
import sys

parser=argparse.ArgumentParser(description='Update YAML for a Dex Wrist install')
parser.add_argument("--factory", help="Is a factory install",action="store_true")
args = parser.parse_args()

if not args.factory:
    dex_wrist_yaml={
        #These user YAML settings include baud settings as older Stretch may use 57600
        #They also include stretch_gripper calibration as it wasn't run at the factory
        'robot':{'use_collision_manager':1, 'tool':'tool_stretch_dex_wrist'},
        'params':['stretch_tool_share.stretch_dex_wrist.params'],
        'tool_stretch_gripper':{'baud':115200},
        'tool_none':{'baud':115200},
        'wrist_yaw':{'baud':115200},
        'stretch_gripper':{'range_t':[0,6415],'zero_t':4017,'baud':115200},
        'lift':{'i_feedforward':0.75},
        'hello-motor-lift':{'gains':{'i_safety_feedforward':0.75}}
    }
else:
    dex_wrist_yaml={
        'robot':{'use_collision_manager':1, 'tool':'tool_stretch_dex_wrist'},
        'params':['stretch_tool_share.stretch_dex_wrist.params'],
        'lift':{'i_feedforward':0.75},
        'hello-motor-lift':{'gains':{'i_safety_feedforward':0.75}}
    }

if not exists(hello_utils.get_fleet_directory()+'stretch_user_params.yaml'):
    print('Please run tool RE1_migrate_params.py before continuing. For more details, see https://forum.hello-robot.com/t/425')
    sys.exit(1)
user_yaml=stretch_body.hello_utils.read_fleet_yaml('stretch_user_params.yaml')
stretch_body.hello_utils.overwrite_dict(overwritee_dict=user_yaml, overwriter_dict=dex_wrist_yaml)
stretch_body.hello_utils.write_fleet_yaml('stretch_user_params.yaml', user_yaml,
                                          header=stretch_body.robot_params.RobotParams().get_user_params_header())
