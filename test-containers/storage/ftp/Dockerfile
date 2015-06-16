######################################################
#
# Agave FTP storage Server
# Tag: agaveapi/pure-ftpd
#
# This is the base FTP server image used for testing
# FTP in the Agave API. It extends from the agaveapi/centos-base
# image with a pure-ftp server which defaults to the
# system accounts and user home directories.
#
# https://bitbucket.org/taccaci/agave-environment
#
######################################################

FROM agaveapi/centos-base

MAINTAINER Rion Dooley <dooley@tacc.utexas.edu>

RUN yum install -y tar gzip wget gcc pam-devel && \
    cd /tmp && \
    wget http://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.40.tar.gz && \
    tar -xvzf pure-ftpd-1.0.40.tar.gz && \
    cd pure-ftpd-1.0.40 && \
    ./configure --without-capabilities --with-virtualchroot --with-pam --with-altlog --with-wrapper --with-cookie --with-throttling --with-ratios --with-paranoidmsg --with-quotas && \
    make && \
    make install && \
    yum erase -y wget tar pam-devel gcc pam-devel

ADD supervisord.conf /etc/supervisord.conf
EXPOSE 10389 22 21
CMD ["/usr/bin/supervisord"]
