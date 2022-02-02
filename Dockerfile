FROM --platform=linux/arm/v7 rafa606/debian_arm_v7
WORKDIR /catkinws
RUN mkdir /catkin/src
SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends -o \
                        Dpkg::Options::="--force-confnew" \
                        gnupg python3 python3-dev python3-pip build-essential \
                        libyaml-cpp-dev lsb-release isc-dhcp-server

RUN sh -c """ \
    echo deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main \
        > /etc/apt/sources.list.d/ros-latest.list \
    """
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' \
        --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
#
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends -o \
        Dpkg::Options::="--force-confnew" \
        python3-rosdep python3-rosinstall-generator python3-wstool python-wstool \
        python3-rosinstall build-essential \
        python3-catkin-tools git python-pip python3-pip
RUN pip3 install pycryptodome

RUN rosdep init && rosdep update
RUN rosinstall_generator controller_manager_msgs roscpp std_msgs controller_interface hardware_interface joint_trajectory_controller pluginlib realtime_tools actionlib_msgs message_generation actionlib control_msgs controller_manager geometry_msgs industrial_robot_status_interface sensor_msgs std_srvs tf tf2_geometry_msgs tf2_msgs trajectory_msgs robot_state_publisher joint_state_publisher map_msgs position_controllers tf_conversions joint_state_controller velocity_controllers force_torque_sensor_controller --rosdistro noetic --deps --wet-only --tar > ros.rosinstall
RUN wstool init -j8 src ros.rosinstall
RUN rosdep install -r -q  --from-paths src --ignore-src --rosdistro noetic -y
