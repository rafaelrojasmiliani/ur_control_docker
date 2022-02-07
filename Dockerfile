FROM --platform=linux/arm/v7 rafa606/debian_arm_v7_ros
WORKDIR /catkinws2
ENV SSL_CERT_FILE=/usr/lib/ssl/certs/ca-certificates.crt
SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends -o \
        Dpkg::Options::="--force-confnew" \
        build-essential \
        git python-pip python-setuptools gcc libpq-dev \
        python-dev  python-pip python3-dev python3-pip python3-venv \
        python3-wheel python-rosdep python-rosinstall-generator \
        python-wstool python-rosinstall

RUN git clone -b v2.0 https://github.com/UniversalRobots/Universal_Robots_ROS_Driver.git /catkinws2/src/Universal_Robots_ROS_Driver && \
    git clone -b calibration_devel https://github.com/rafaelrojasmiliani/universal_robot.git /catkinws2/src/rrojas_universal_robot && \
    git clone -b 0.3.2 https://github.com/UniversalRobots/Universal_Robots_Client_Library.git /catkinws2/src/Universal_Robots_Client_Library

RUN rosdep update
RUN rosdep install -r -q --from-paths src --ignore-src --rosdistro noetic -y
RUN src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release -DCATKIN_SKIP_TESTING=ON --install-space /opt/ros/noetic -j1 -DPYTHON_EXECUTABLE=/usr/bin/python3
