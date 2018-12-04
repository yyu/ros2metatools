#!/bin/bash

set -e

_______________________________________________________________() {
    for ((i=0;i<80;i++)); do echo -en "\033[32m"$1"\033[0m"; done
    echo
}
_______________________________________________________________ '0'
mkdir -p src
_______________________________________________________________ '1'
wget https://raw.githubusercontent.com/yyu/ros2/yy/ros2.repos
_______________________________________________________________ '2'
vcs import src < ros2.repos
_______________________________________________________________ '3'
(cd src/osrf/osrf_testing_tools_cpp/osrf_testing_tools_cpp/; git checkout master)
(cd src/osrf/osrf_testing_tools_cpp/test_osrf_testing_tools_cpp/; git checkout master)
_______________________________________________________________ '5'
touch src/ros2/rviz/AMENT_IGNORE
touch src/ros2/system_tests/test_communication/AMENT_IGNORE
_______________________________________________________________ '6'
sudo rosdep init
echo -e "\033[1;31mskipping sudo rosdep init\033[0m"
_______________________________________________________________ '7'
rosdep update
_______________________________________________________________ '8'
rosdep install --from-paths src --ignore-src --rosdistro bouncy -y --skip-keys "console_bridge fastcdr fastrtps libopensplice67 rti-connext-dds-5.3.1 urdfdom_headers"
_______________________________________________________________ '9'
colcon build --symlink-install
_______________________________________________________________ '~'
#colcon test
echo -e "\033[1;31mskipping colcon test\033[0m"
_______________________________________________________________ '-'
. install/local_setup.bash

echo -e "
\033[36mdemo:
\033[32m
ros2 run demo_nodes_cpp listener &
ros2 run demo_nodes_cpp talker &
\033[0m"
