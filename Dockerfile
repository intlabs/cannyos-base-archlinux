#
# CannyOS Ubuntu 14.04 lts base container
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

# Pull base image.
FROM base/archlinux

MAINTAINER "Pete Birley (petebirley@gmail.com)"

# Install base utilities.
RUN sed 's/^CheckSpace/#CheckSpace/g' -i /etc/pacman.conf
RUN pacman -Syyu --noconfirm 


# Add new user
RUN useradd -m -s /bin/bash user
RUN echo 'user:acoman' | chpasswd


#Add startup & post-install script
ADD /CannyOS/startup.sh /CannyOS/startup.sh
RUN chmod +x /CannyOS/startup.sh
#ADD /CannyOS/post-install.sh /CannyOS/post-install.sh
#RUN chmod +x /CannyOS/post-install.sh
ADD /CannyOS/CannyOS.splash /CannyOS/CannyOS.splash

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

# Define default command.
ENTRYPOINT ["/CannyOS/startup.sh"]