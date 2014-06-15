## CannyOS Arch Linux Dockerfile


This repository contains the *Dockerfile* and *associated files* for setting up a container with Arch Linux for CannyOS

### Dependencies

* docker


### Installation

1. Install [Docker](https://www.docker.io/).

	For an Ubuntu 14.04 host the following command will get you up and running:

	`sudo apt-get -yqq update && sudo apt-get -yqq install docker.io && sudo ln -sf /usr/bin/docker.io /usr/local/bin/docker && sudo restart docker.io`

2. You can then build the container set from the via entering:

	`bash <(curl -s https://raw.githubusercontent.com/intlabs/cannyos-base-archlinux/master/Build.sh)`

### Usage

* this will run and drop you into a session without Fuse:

`sudo docker run -it --rm intlabs/cannyos-base-archlinux`

* this will run and drop you into a session with privileges to run FUSE:

`sudo docker run -it --rm --privileged=true --lxc-conf="native.cgroup.devices.allow = c 10:229 rwm" intlabs/cannyos-base-archlinux-fuse`


Copyright 2014 Pete Birley

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

