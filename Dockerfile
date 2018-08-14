FROM ubuntu
MAINTAINER Eystein Måløy Stenberg <eytein.stenberg@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update && apt dist-upgrade -y
RUN apt-get -y install wget lsb-release unzip vim apt-transport-https xz-utils net-tools apt-utils sudo gnupg2

# install latest CFEngine
RUN wget -O- https://s3.amazonaws.com/cfengine.packages/quick-install-cfengine-community.sh | sudo bash

# install cfe-docker process management policy
RUN wget --no-check-certificate https://github.com/estenberg/cfe-docker/archive/master.zip -P /tmp/ && unzip /tmp/master.zip -d /tmp/
RUN cp /tmp/cfe-docker-master/cfengine/bin/* /var/cfengine/bin/
RUN cp /tmp/cfe-docker-master/cfengine/inputs/* /var/cfengine/inputs/
RUN rm -rf /tmp/cfe-docker-master /tmp/master.zip

# apache2 and openssh are just for testing purposes, install your own apps here
RUN apt-get -y install openssh-server apache2
RUN mkdir -p /var/run/sshd
RUN echo "root:password" | chpasswd  # need a password for ssh

ENTRYPOINT ["/var/cfengine/bin/docker_processes_run.sh"]
