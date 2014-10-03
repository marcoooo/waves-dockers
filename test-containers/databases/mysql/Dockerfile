######################################################
#
# Agave DevOps MySQL
# Tag: agaveapi/mysql
#
# This container creates a mysql server exposed on the
# default port. Data is persisted in /data. Mount that as
# a volume if you want persistent queues.
#
# Usage:
# docker run -h docker.example.com -i     \
#            -p 10022:22                  \ # SSHD, SFTP
#            -p 3306:3306               \ # mysql
#            -v /var/lib/beanstalkd/binlog:/var/lib/beanstalkd/binlog \ # volume for persistent data
#            agaveapi/beanstalkd
#
# https://bitbucket.org/taccaci/agave-environment
#
######################################################

FROM agaveapi/centos-base

MAINTAINER Rion Dooley <dooley@tacc.utexas.edu>

RUN yum -y install mysql-server mysql

ADD my.cnf /etc/mysql/conf.d/my.cnf
RUN chmod 664 /etc/mysql/conf.d/my.cnf
ADD run.sh /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisord.conf

VOLUME ["/var/lib/mysql"]
EXPOSE 10389 22 3306
#CMD ["/usr/local/bin/run"]
CMD ["/usr/bin/supervisord"]
