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
# docker run -h docker -i     \
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
RUN yum -y --enablerepo=centosplus install make perl-CPAN openssl-devel libxml2-devel boost-devel gcc gcc-c++ git tar libtool vim-minimal

# Pull torque
RUN git clone https://github.com/adaptivecomputing/torque.git -b 5.0.0 5.0.0
WORKDIR 5.0.0
RUN ./autogen.sh

# Build Torque
RUN ./configure
RUN make
RUN make install
RUN cp contrib/init.d/trqauthd /etc/init.d/
RUN cp contrib/init.d/pbs_mom /etc/init.d/pbs_mom
RUN cp contrib/init.d/pbs_server /etc/init.d/pbs_server
RUN cp contrib/init.d/pbs_sched /etc/init.d/pbs_sched
#RUN echo /usr/local/lib > /etc/ld.so.conf.d
RUN ldconfig

# Configure Torque
RUN echo "docker" > /var/spool/torque/server_name
RUN echo '/usr/local/lib' > /etc/ld.so.conf.d/torque.conf
RUN ldconfig
hostRUN trqauthd start && \
    ./torque.setup root && \
    qterm -t quick && \
    pbs_server && \
    pbs_mom && pbs_sched && \
    qmgr -c "create queue debug queue_type=execution" && \
    qmgr -c "set queue debug enabled=true" && \
    qmgr -c "set queue debug started=true" && \
    qmgr -c "set server scheduling=True"

RUN echo "docker.example.com np=1" >> /var/spool/torque/server_priv/nodes
RUN printf "\$pbsserver docker" >> /var/spool/torque/mom_priv/config


# Add in a test submit script
ADD pbs/pbs.submit /home/testuser/pbs.submit
RUN chown testuser:testuser /home/testuser/pbs.submit

ADD supervisord.conf /etc/supervisord.conf
RUN mkdir /var/log/supervisor
RUN chmod -R 777 /var/log/supervisor

EXPOSE 10389 22 15003 15001 1024
CMD /usr/bin/supervisord
