######################################################
#
# Agave DevOps GridFTP Server
# Tag: agaveapi/gridftp
#
# This container provides a standard myproxy server running
# on port 7512 for the test users created in the agaveapi/centos-base
# image. It also provides a myproxy server configured with a
# trust relationship runing on port 7513. The trusted grid
# cert and key will be printed when the container starts.
#
# Usage:
# docker run -h docker.example.com -i     \
#            -p 7512:7512                 \ # MyProxy CA + PAM
#            -p 2811:2811                 \ # GridFTP server
#            -p 10022:22                  \ # SSHD, SFTP
#            -p 50000:50000 \
#            -p 50001:50001 \
#            -p 50002:50002 \
#            -p 50003:50003 \
#            -p 50004:50004 \
#            -p 50005:50005 \
#            -p 50006:50006 \
#            -p 50007:50007 \
#            -p 50008:50008 \
#            -p 50009:50009 \
#            -p 50010:50010 \
#            agaveapi/gridftp
#
# https://bitbucket.org/taccaci/agave-environment
#
######################################################

FROM agaveapi/myproxy

MAINTAINER Rion Dooley <dooley@tacc.utexas.edu>

RUN yum -y localinstall http://www.globus.org/ftppub/gt5/5.2/5.2.0/installers/repo/Globus-repo-config.centos-6-1.noarch.rpm

# Install Globus binaries
RUN yum -y groupinstall globus-gridftp vim-minimal
RUN yum -y install xinetd rsyslog

# generate and sign a service cert
WORKDIR /etc/grid-security
RUN grid-cert-request -host docker.example.com -dir . -service gridftp -prefix gridftp -nopw
RUN echo "globus" | grid-ca-sign -days 3650 -in gridftpcert_request.pem -out gridftpcert.pem
RUN openssl rsa -in gridftpkey.pem -outform PEM -out new-gridftpkey.pem

# Add custom gridftp config
ADD gridftp/gridftp.conf /etc/gridftp.conf
ADD gridftp/gridftp.conf /etc/xinetd.d/gridftp

ADD supervisord.conf /etc/supervisord.conf
RUN chmod -R 777 /var/log/supervisor

EXPOSE 10389 22 7512 7513 2811 50000 50001 50002 50003 50004 50005 50006 50007 50008 50009 50010
CMD /usr/bin/supervisord
