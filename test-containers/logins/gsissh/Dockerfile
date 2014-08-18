######################################################
#
# Agave DevOps GSI OpenSSH Server
# Tag: agave-test-gsiopenssh
#
# https://bitbucket.org/taccaci/agave-environment
#
######################################################

FROM centos:latest

MAINTAINER Rion Dooley <dooley@tacc.utexas.edu>

RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

RUN yum update -y
RUN yum install -y openssh-server yum install openssh-clients which
RUN mkdir -p /var/run/sshd && \
    echo "root:root" | chpasswd
RUN adduser "testuser" && \
    echo "testuser:testuser" | chpasswd
ADD id_rsa.pub /home/testuser/.ssh/authorized_keys
RUN adduser "testshareuser" && \
    echo "testshareuser:testshareuser" | chpasswd
ADD id_rsa.pub /home/testshareuser/.ssh/authorized_keys
RUN adduser "testotheruser" && \
    echo "testotheruser:testotheruser" | chpasswd
ADD id_rsa.pub /home/testotheruser/.ssh/authorized_keys
RUN service sshd start
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

# install supervisord
RUN yum install -y python-pip && pip install "pip>=1.4,<1.5" --upgrade
RUN pip install supervisor

# install globus
RUN rpm -Uvh http://www.globus.org/ftppub/gt5/5.2/5.2.4/installers/repo/Globus-5.2.stable-config.centos-6-1.noarch.rpm
RUN yum -y install globus-gsi.x86_64 globus-gridftp.x86_64

# Install trustcerts
RUN yum -y localinstall http://repo.grid.iu.edu/osg-el6-release-latest.rpm
RUN yum -y install igtf-ca-certs

# Setup simple ca
RUN grid-ca-create -subject "CN=Docker MyProxy, OU=dockerCA-b2d0f1281acd, OU=Dev Certificate Authorities, O=Texas Advanced Computing Center, C=US" \
    -email root@b2d0f1281acd \
    -pass globus \
    -days 3650 \
    -force

# Create symlinks for grid ca tools to work
RUN ln -s /var/lib/globus/simple_ca/globus-host-ssl.conf /etc/grid-security/ && \
    ln -s /var/lib/globus/simple_ca/globus-user-ssl.conf /etc/grid-security/ && \
    ln -s /var/lib/globus/simple_ca/grid-security.conf /etc/grid-security/

# double default cert length
RUN sed -ri 's/default_bits		= 1024/default_bits		= 2048/g' /var/lib/globus/simple_ca/globus-host-ssl.conf

# generate and sign a hostcert
RUN cd /etc/grid-security ; grid-cert-request -host docker.example.com
RUN cd /etc/grid-security; echo "globus" | grid-ca-sign -days 3650 -in hostcert_request.pem -out hostcert.pem

# copy cert and key to proper locations
RUN cp /var/lib/globus/simple_ca/newcerts/01.pem /etc/grid-security/myproxy/hostcert.pem
RUN cp /etc/grid-security/hostkey.pem /etc/grid-security/myproxy/hostkey.pem

RUN chown -R root:root /var/lib/myproxy
RUN chown -R myproxy:myproxy /var/lib/globus/simple_ca
RUN CERT_HASH=$(openssl x509 -in /var/lib/globus/simple_ca/cacert.pem -noout -hash) && \
  ln -s /var/lib/globus/simple_ca/cacert.pem $CERT_HASH.0

# install supervisord
RUN yum install -y python-pip && pip install "pip>=1.4,<1.5" --upgrade
RUN pip install supervisor

# Add myproxy config files
ADD myproxy-server.config /etc/myproxy-server.config
ADD myproxy-server-trusted.config /etc/myproxy-server-trusted.config
ADD myproxy.pam /etc/pam.d/myproxy

# Env variables needed by myproxy-server
ENV X509_USER_CERT /etc/grid-security/myproxy/hostcert.pem
ENV X509_USER_KEY /etc/grid-security/myproxy/hostkey.pem

RUN echo '"/O=University of Texas/O=TACC/OU=Agave/OU=dockerCA-b2d0f1281acd/CN=testuser" testuser' >> /etc/grid-security/grid-mapfile
RUN echo '"/O=University of Texas/O=TACC/OU=Agave/OU=dockerCA-b2d0f1281acd/CN=testshareuser" testshareuser' >> /etc/grid-security/grid-mapfile
RUN echo '"/O=University of Texas/O=TACC/OU=Agave/OU=dockerCA-b2d0f1281acd/CN=testother" testother' >> /etc/grid-security/grid-mapfile
RUN chmod +r /etc/grid-security/grid-mapfile

ADD supervisord.conf /etc/supervisord.conf
RUN mkdir /var/log/supervisor
RUN chmod -R 777 /var/log/supervisor

EXPOSE 10389 22 2222
CMD ["/usr/bin/supervisord"]
