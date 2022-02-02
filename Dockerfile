FROM --platform=linux/arm/v7 debian:buster
SHELL ["/bin/bash", "-c"]
WORKDIR /

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends -o \
        Dpkg::Options::="--force-confnew" \
                        gnupg python3 python3-dev python3-pip build-essential \
                        libyaml-cpp-dev lsb-release isc-dhcp-server \
                        wget ca-certificates ntpdate curl


RUN cd / && \
        curl -OL https://github.com/Kitware/CMake/releases/download/v3.20.0/cmake-3.20.0.tar.gz && \
        tar -xzf cmake-3.21.0.tar.gz && \
        cd cmake-3.21.0 && \
         ./bootstrap --prefix=/usr -- -D_FILE_OFFSET_BITS=64 && \
         make && \
         ./bin/cpack -G DEB && \
         dpkg -i *.deb


#RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends -o \
#        Dpkg::Options::="--force-confnew" \
#                        wget git python3-catkin-tools ros-noetic-ur-msgs && \
#        mkdir -p /catkinws/src  && \
#         git clone -b v2.0 https://github.com/UniversalRobots/Universal_Robots_ROS_Driver.git /catkinws/src/Universal_Robots_ROS_Driver && \
#         git clone -b calibration_devel https://github.com/rafaelrojasmiliani/universal_robot.git /catkinws/src/rrojas_universal_robot && \
#         git clone -b 0.3.2 https://github.com/UniversalRobots/Universal_Robots_Client_Library.git /catkinws/src/Universal_Robots_Client_Library && \
#         source /opt/ros/noetic/setup.bash && \
#         cd /catkinws && rosdep update &&  rosdep install -r -q --from-paths src --ignore-src -y && \
#         bash -c 'source /opt/ros/noetic/setup.bash && cd /catkinws && catkin config --install --install-space /opt/ros/noetic/ --extend /opt/ros/noetic/ && catkin build'
