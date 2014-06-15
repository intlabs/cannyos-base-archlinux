#!/bin/sh
#
# CannyOS Ubuntu 14.04 lts base containers build script
#
# https://github.com/intlabs/cannyos-base-archlinux
#
# Copyright 2014 Pete Birley
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
clear
curl https://raw.githubusercontent.com/intlabs/cannyos-base-archlinux/master/CannyOS/CannyOS.splash
#     *****************************************************
#     *                                                   *
#     *        _____                    ____  ____        *
#     *       / ___/__ ____  ___  __ __/ __ \/ __/        *
#     *      / /__/ _ `/ _ \/ _ \/ // / /_/ /\ \          *
#     *      \___/\_,_/_//_/_//_/\_, /\____/___/          *
#     *                         /___/                     *
#     *                                                   *
#     *                                                   *
#     *****************************************************
echo "*                                                   *"
echo "*         Ubuntu docker container builder           *"
echo "*                                                   *"
echo "*****************************************************"
echo ""


# Remove old image if it exists
sudo docker rmi intlabs/cannyos-base-archlinux

# Build base container image
sudo docker build -t="intlabs/cannyos-base-archlinux" github.com/intlabs/cannyos-base-archlinux

echo ""
echo "*****************************************************"
echo "*                                                   *"
echo "*         Built base container image                *"
echo "*                                                   *"
echo "*****************************************************"
echo ""

# Make shared directory on host
sudo mkdir -p "/CannyOS/build/cannyos-base-archlinux"
# Ensure that there it is clear
sudo rm -r -f "/CannyOS/build/cannyos-base-archlinux/*"

# Remove any old containers
sudo docker stop cannyos-base-archlinux && \
sudo docker kill cannyos-base-archlinux && \
sudo docker rm cannyos-base-archlinux

# Launch built base container image
sudo docker run -i -t -d \
 --privileged=true --lxc-conf="native.cgroup.devices.allow = c 10:229 rwm" \
 --volume "/CannyOS/build/cannyos-base-archlinux":"/CannyOS/Host" \
 --name "cannyos-base-archlinux" \
 --user "root" \
 intlabs/cannyos-base-archlinux

echo ""
echo "*****************************************************"
echo "*                                                   *"
echo "*         Launched base container image             *"
echo "*                                                   *"
echo "*****************************************************"
echo ""

# Wait for post-install script to finish running (Currently time out at ) 
sleep 10
x=0
while [ "$x" -lt 43200 -a ! -e "/CannyOS/build/cannyos-base-archlinux/done" ]; do
   x=$((x+1))
   sleep 1.0
   echo -n "Post Install script run time: $x seconds"
done
if [ -e "/CannyOS/build/cannyos-base-archlinux/done" ]
then
	echo ""
	echo "*****************************************************"
	echo "*                                                   *"
	echo "*   host detected post install script competion     *"
	echo "*                                                   *"
	echo "*****************************************************"
	echo ""

else
	echo ""
	echo "*****************************************************"
	echo "*                                                   *"
	echo "*         Post install script timeout               *"
	echo "*                                                   *"
	echo "*****************************************************"
	echo ""
fi

#Get the container id
CONTAINERID=$(sudo docker ps | grep "cannyos-base-archlinux" | head -n 1 | awk 'BEGIN { FS = "[ \t]+" } { print $1 }' ) && echo "$CONTAINERID"

# Remove any old containers
sudo docker stop dockerfile-cannyos-ubuntu-14_04-fuse && \
sudo docker kill dockerfile-cannyos-ubuntu-14_04-fuse && \
sudo docker rm dockerfile-cannyos-ubuntu-14_04-fuse && \
sudo docker rmi intlabs/dockerfile-cannyos-ubuntu-14_04-fuse

#Commit the container image
sudo docker commit -m="Installed FUSE" -a="Pete Birley" $CONTAINERID intlabs/dockerfile-cannyos-ubuntu-14_04-fuse

# Shut down the base image
sudo docker stop cannyos-base-archlinux

echo ""
echo "*****************************************************"
echo "*                                                   *"
echo "* CannyOS/dockerfile-cannyos-ubuntu-14_04-fuse  :)  *"
echo "*                                                   *"
echo "*****************************************************"
echo ""


# Make shared directory on host
sudo mkdir -p "/CannyOS/build/dockerfile-cannyos-ubuntu-14_04-fuse"
# Ensure that there it is clear
sudo rm -r -f "/CannyOS/build/dockerfile-cannyos-ubuntu-14_04-fuse/*"



sudo docker run -i -t --rm \
 --privileged=true --lxc-conf="native.cgroup.devices.allow = c 10:229 rwm" \
 --volume "/CannyOS/build/dockerfile-cannyos-ubuntu-14_04-fuse":"/CannyOS/Host" \
 --name "dockerfile-cannyos-ubuntu-14_04-fuse" \
 --hostname "dockerfile-cannyos-ubuntu-14_04-fuse" \
 --user "root" \
 intlabs/dockerfile-cannyos-ubuntu-14_04-fuse