######################################################
#
# Agave Vanilla iRODS Server
# Tag: agaveapi/irods
#
# This is a vanilla iRODS server used for testing iRODS
# support in the Agave API. It extends from the
# agaveapi/centos-base and maps the existing testuser,
# testotheruser, and testshareuser system accounts
# to accounts in irods with the same password.
#
# Usage:
# docker run -h docker.example.com -i     \
#            -p 1247:1247                 \ # Vanilla IRODS
#            -p 10022:22                  \ # SSHD, SFTP
#            agaveapi/irods
#
# https://bitbucket.org/taccaci/agave-environment
#
######################################################

FROM agaveapi/centos-base

MAINTAINER Rion Dooley <dooley@tacc.utexas.edu>

RUN yum -y groupinstall "Development Tools"

# Install iRODS dependencies
RUN yum -y install fuse-libs openssl098e authd bind-utils gcc gcc-cpp gcc-c++ kernel-devel kernel-headers libtool-ltdl qt qt-devel

# Create irods user
RUN adduser "irods" -m && \
    echo "irods:irods" | chpasswd
USER irods
RUN mkdir /home/irods/.ssh
ADD ssh/id_rsa.pub /home/irods/.ssh/authorized_keys
USER root

# add irods data directory
RUN mkdir /data
RUN chown -R irods:irods /data

# install irods in user space
USER irods

# Download and unpack irods
WORKDIR /home/irods
RUN curl -O http://irods.sdsc.edu/cgi-bin/upload18.cgi/irods3.3.1.tgz
RUN tar xzf irods3.3.1.tgz

# Add config files and delegate ownership
USER root
ADD irods/irods.config /home/irods/iRODS/config/irods.config
ADD irods/installPostgres.config /home/irods/iRODS/config/installPostgres.config
ADD irods/irodsHost /home/irods/iRODS/server/config/irodsHost
RUN chown -R irods:irods /home/irods/iRODS/*
RUN chmod 664 /home/irods/iRODS/config/irods.config
RUN chmod 664 /home/irods/iRODS/config/installPostgres.config
RUN chmod 664 /home/irods/iRODS/server/config/irodsHost

# Build whole shebang from scratch using added config files.
WORKDIR /home/irods/iRODS
#RUN su - irods -c "cd /home/irods/iRODS && ./irodssetup --noask"

RUN su - irods -c "cd /home/irods/iRODS && scripts/installPostgres --noask"
RUN su - irods -c "cd /home/irods/iRODS && scripts/configure"
RUN su - irods -c "cd /home/irods/iRODS && make"

RUN su - irods -c "cd /home/irods/iRODS && scripts/finishSetup --noask --verbose"
RUN printf '\n\nexport PATH=/home/irods/iRODS/clients/icommands/bin:$PATH' >> /home/irods/.bashrc

# Set up user environment accounting for docker hostname at build time
ADD irods/irodsEnv /home/irods/.irods/.irodsEnv
RUN chown -R irods:irods /home/irods/.irods/.irodsEnv

# Add users and run jargon specquery commands so permissions work in jargon
ADD irods/jargon_specquery.sh /home/irods/iRODS/scripts/jargon_specquery.sh
ADD irods/user_setup.sh /home/irods/iRODS/scripts/user_setup.sh
RUN chown irods:irods /home/irods/iRODS/scripts/jargon_specquery.sh
RUN chown irods:irods /home/irods/iRODS/scripts/user_setup.sh
RUN chmod 775 /home/irods/iRODS/scripts/jargon_specquery.sh
RUN chmod 755 /home/irods/iRODS/scripts/user_setup.sh

# Add system users to mirror accounts since we're not using a pam config on this one
RUN su - irods -c "/home/irods/iRODS/irodsctl start && \
    . /home/irods/iRODS/scripts/user_setup.sh && \
    . /home/irods/iRODS/scripts/jargon_specquery.sh && \
    /home/irods/iRODS/irodsctl stop"

# Add supervisor to startup sshd, postgres, and irods
ADD supervisord.conf /etc/supervisord.conf
RUN mkdir /var/log/supervisor

#VOLUME ["/data"]

EXPOSE 10389 22 5432 1247
CMD ["/usr/bin/supervisord"]
