######################################################
#
# Agave MyProxy Server
# Tag: agave-test-myproxy
#
# https://bitbucket.org/taccaci/agave-environment
#
# This container provides a standard myproxy server running
# on ports 7512 configured to issue certs via pam-based
# usernames and passwords
######################################################

FROM agaveapi/myproxy

MAINTAINER Rion Dooley <dooley@tacc.utexas.edu>

#mpg dependencies
RUN yum -y install java-1.6.0-sun-compat git httpd mod_ssl

# install Maven
WORKDIR /usr/share
RUN curl -O ftp://mirror.reverse.net/pub/apache/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz
RUN tar xzf apache-maven-3.0.5-bin.tar.gz
RUN ln -s /usr/share/apache-maven-3.0.5/bin/mvn /usr/bin/mvn
RUN rm apache-maven-3.0.5-bin.tar.gz

# install MPG
WORKDIR /
RUN mv /myproxy-gateway/hostcerts /hostcerts
RUN git clone https://bitbucket.org/taccaci/myproxy-gateway.git
RUN mv /hostcerts /myproxy-gateway/hostcerts
WORKDIR /myproxy-gateway
RUN git pull; git remote
ADD maven/settings.xml /root/.m2/settings.xml

# generate and sign a service cert
#RUN mkdir hostcerts
#WORKDIR /myproxy-gateway/hostcerts
#RUN if [ ! -e mpgcert.pem ]; then grid-cert-request -host docker.example.com -dir . -service mpg -prefix mpg -nopw; fi
#RUN if [ ! -e mpgcert.pem ]; then echo "globus" | grid-ca-sign -days 3650 -in mpgcert_request.pem -out mpgcert.pem; fi
#RUN if [ ! -e new-mpgkey.pem ]; then openssl rsa -in mpgkey.pem -outform PEM -out new-mpgkey.pem; fi
ENV export MPG_SUBJECT=$(grid-cert-info -file myproxy-gateway/hostcerts/mpgcert.pem -subject) && \
    sed -ri 's/MPG_SUBJECT/$MPG_SUBJECT</g' /root/.m2/settings.xml && \
    cat /root/.m2/settings.xml

# build server
WORKDIR /myproxy-gateway
RUN mvn -Dmaven.test.skip=true clean install -P mpg
RUN mkdir mpg-api/target/logs

# Configure apache as a proxy with forced ssl
RUN mkdir -p /var/www/html/myproxy/v1
RUN ln -s /myproxy-gateway/mpg-docs/target/classes /var/www/html/myproxy/v1/docs
RUN chmod -R +rx /var/www/html/myproxy
ADD apache/ssl.conf /etc/httpd/conf.d/ssl.conf
ADD apache/htaccess /var/www/html/.htaccess

ADD supervisord.conf /etc/supervisord.conf
RUN chmod -R 777 /var/log/supervisor

EXPOSE 10389 22 7512 7513 8080 8090 443 80
CMD echo "MyProxy Gateway host cert: mpgcert.pem" && cat /myproxy-gateway/hostcerts/mpgcert.pem && echo "MyProxy Gateway host key: new-mpgkey.pem" && cat /myproxy-gateway/hostcerts/new-mpgkey.pem && /usr/bin/supervisord
