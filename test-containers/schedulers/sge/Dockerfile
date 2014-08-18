######################################################
#
# Agave DevOps PBS Server
# Tag: agaveapi/pbs
#
# This container provides a standard pbs controller
# and worker created on top of the agaveapi/centos-base
# image. Nothing special here.
#
# Usage:
# docker run -h docker.example.com -i     \
#            -p 10022:22                  \ # SSHD, SFTP
#            -p 9618:9618                 \ # PBS
#            agaveapi/sge
#
# https://bitbucket.org/taccaci/agave-environment
#
######################################################

FROM agaveapi/centos-base

MAINTAINER Rion Dooley <dooley@tacc.utexas.edu>

# Install slurm
RUN yum -y install gcc gcc-c++ make torque-server torque-scheduler torque-mom torque-client

# Configure munge
RUN mkdir /var/spool/torque
RUN printf "\n$usecp  *:/ /" >> /var/lib/torque/mom_priv/config
RUN printf "\ndocker.example.com" >> /var/spool/torque/server_name
RUN echo "PBS_DAEMON="/usr/local/sbin/pbs_server -h docker.example.com -S docker.example.com -M docker.example.com" > /etc/sysconfig/pbs_server
RUN echo "PBS_DAEMON="/bin/sh -c 'h=`hostname`; hostname <hostname> ; /usr/local/sbin/pbs_sched; hostname \$h'" > /etc/sysconfig/pbs_sched
RUN touch /var/spool/torque/mom_priv/config

RUN pbs_server -t create -h docker.example.com -S docker.example.com -M docker.example.com && \
    qmgr -c 'set server scheduling=true' && \
    qmgr -c 'create queue defaultq' && \
    qmgr -c 'set queue defaultq queue_type = route' && \
    qmgr -c 'create queue batchq' && \
    qmgr -c 'set queue batchq queue_type = execution' && \
    qmgr -c 'set queue defaultq started = true' && \
    qmgr -c 'set queue defaultq route_destinations = batchq' && \
    qmgr -c 'set queue defaultq enabled = true' && \
    qmgr -c 'set server default_queue = defaultq' && \
    qmgr -c 'set queue batchq started = true' && \
    qmgr -c 'set queue batchq enabled = true' && \
    qmgr -c 'set server resources_default.ncpus = 1' && \
    qmgr -c 'set server resources_default.nodes = 1' && \
    qmgr -c 'create node docker.example.com np=1'

# Add in a test submit script
ADD pbs/pbs.submit /home/testuser/pbs.submit
RUN chown testuser:testuser /home/testuser/pbs.submit

ADD supervisord.conf /etc/supervisord.conf
RUN mkdir /var/log/supervisor
RUN chmod -R 777 /var/log/supervisor

EXPOSE 10389 22
CMD /usr/bin/supervisord
