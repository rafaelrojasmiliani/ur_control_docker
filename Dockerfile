FROM --platform=linux/arm/v7 ros:noetic-ros-base
SHELL ["/bin/bash", "-c"]
WORKDIR /
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends -o \
        Dpkg::Options::="--force-confnew" \
                        wget git python3-catkin-tools ros-noetic-ur-msgs && \
        mkdir -p /catkinws/src  && \
         git clone -b v2.0 https://github.com/UniversalRobots/Universal_Robots_ROS_Driver.git /catkinws/src/Universal_Robots_ROS_Driver && \
         git clone -b calibration_devel https://github.com/rafaelrojasmiliani/universal_robot.git /catkinws/src/rrojas_universal_robot && \
         git clone -b 0.3.2 https://github.com/UniversalRobots/Universal_Robots_Client_Library.git /catkinws/src/Universal_Robots_Client_Library && \
         source /opt/ros/noetic/setup.bash && \
         cd /catkinws && rosdep update &&  rosdep install -r -q --from-paths src --ignore-src -y && \
         bash -c 'source /opt/ros/noetic/setup.bash && cd /catkinws && catkin config --install --install-space /opt/ros/noetic/ --extend /opt/ros/noetic/ && catkin build'
