######################################################
#
# Agave DevOps Base Image
# Tag: agaveapi/centos-base
#
# This container creates three users (testuser, testotheruser,
# and testshareuser) that have a common ssh key and passwords
# equal to their username. These users are used for all testing
# in the Agave API. A SSH server and supervisord are installed.
# This constitues the base image for all other Agave containers.
#
# Usage:
# docker run -v docker.example.com -i     \
#            -p 10022:22                  \ # SSHD, SFTP
#            agaveapi/centos-base
#
# https://bitbucket.org/taccaci/agave-environment
#
######################################################

FROM centos:centos6

MAINTAINER Rion Dooley <dooley@tacc.utexas.edu>

RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

#RUN yum update -y
RUN yum install -y openssh-server openssh-clients which python-pip
RUN mkdir -p /var/run/sshd && \
    echo "root:root" | chpasswd

RUN adduser "testuser" -m && \
    echo "testuser:testuser" | chpasswd
USER testuser
RUN mkdir /home/testuser/.ssh
ADD id_rsa.pub /home/testuser/.ssh/authorized_keys
USER root

RUN adduser "testshareuser" -m && \
    echo "testshareuser:testshareuser" | chpasswd
USER testshareuser
RUN mkdir /home/testshareuser/.ssh
ADD id_rsa.pub /home/testshareuser/.ssh/authorized_keys
USER root

RUN adduser "testotheruser" -m && \
    echo "testotheruser:testotheruser" | chpasswd
USER testotheruser
RUN mkdir /home/testotheruser/.ssh
ADD id_rsa.pub /home/testotheruser/.ssh/authorized_keys
USER root

RUN service sshd start
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

RUN /bin/date

# install supervisord
RUN pip install "pip>=1.4,<1.5" --upgrade
RUN pip install supervisor

ADD test-containers/supervisord.conf /etc/supervisord.conf
EXPOSE 10389 22
CMD ["/usr/bin/supervisord"]
