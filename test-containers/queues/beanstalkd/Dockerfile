######################################################
#
# Agave DevOps Beanstalkd
# Tag: agaveapi/beanstalkd
#
# This container creates a beanstalkd server exposed on the
# default port. Data is persisted in /data. Mount that as
# a volume if you want persistent queues.
#
# Usage:
# docker run -h docker.example.com -i     \
#            -p 10022:22                  \ # SSHD, SFTP
#            -p 11300:11300               \ # beanstalk
#            -v /var/lib/beanstalkd/binlog:/var/lib/beanstalkd/binlog \ # volume for persistent data
#            agaveapi/beanstalkd
#
# https://bitbucket.org/taccaci/agave-environment
#
######################################################

FROM agaveapi/centos-base

MAINTAINER Rion Dooley <dooley@tacc.utexas.edu>

RUN yum -y install beanstalkd

RUN mkdir -p /var/log/supervisor

ADD supervisord.conf /etc/supervisord.conf

VOLUME ["/var/lib/beanstalkd/binlog"]
EXPOSE 10389 22 11300
CMD ["/usr/bin/supervisord"]
