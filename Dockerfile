FROM centos
MAINTAINER Rion Dooley <dooley@tacc.utexas.edu

# install http
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

RUN yum -y update

######################################################
#			some basic tool installs
######################################################

RUN yum -y install bind-utils sendmail sendmail-cf


######################################################
#			Java install
######################################################

# install Java7 from http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.rpm
RUN curl -LO 'http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.rpm' -H 'Cookie: oraclelicense=accept-securebackup-cookie'
RUN rpm -i jdk-7u51-linux-x64.rpm 
RUN rm jdk-7u51-linux-x64.rpm
ENV JAVA_HOME /usr/java/default


######################################################
#			httpd install
######################################################

RUN yum -y install httpd vim-enhanced bash-completion unzip 

# Configuring SSL
RUN yum -y install mod_ssl openssl

# Generate private key 
RUN openssl genrsa -out ca.key 2048

# Generate CSR 
RUN openssl req -new -key ca.key -out ca.csr -subj '/C=US/ST=TX/L=Austin/O=University of Texas/OU=TACC/CN=Agave'

# Generate Self Signed Key
RUN openssl x509 -req -days 365 -in ca.csr -signkey ca.key -out ca.crt

# Copy the files to the correct locations
RUN cp ca.crt /etc/pki/tls/certs
RUN cp ca.key /etc/pki/tls/private/ca.key
RUN cp ca.csr /etc/pki/tls/private/ca.csr

# give apache permission to do it's thing
RUN chown -R apache:apache /var/www/html/

# fire up the server
service httpd start

# setup the server to restart when the system boots
RUN /sbin/chkconfig --add httpd
RUN /sbin/chkconfig --level 345 httpd on

######################################################
#			mysql install
######################################################

RUN yum install -y mysql mysql-server
RUN echo "NETWORKING=yes" > /etc/sysconfig/network
# start mysqld to create initial tables
RUN service mysqld start

RUN chkconfig --add mysqld
RUN chkconfig --level 345 mysqld on

ADD mysql/mysql.sh /tmp/mysql.sh
RUN service mysqld start; sleep 5; /tmp/mysql.sh

######################################################
#			PHP install
######################################################

# install php
RUN yum install -y php php-mysql php-gd php-imap php-ldap php-mysql php-odbc php-pear php-xml php-curl php-xmlrpc php-mcrypt


######################################################
#			Git install
######################################################

# install git
RUN yum -y install git


######################################################
#			Beanstalkd install
######################################################

# install git
RUN yum -y install beanstalkd
RUN chkconfig --add beanstalkd
RUN chkconfig --level 345 beanstalkd on


######################################################
#			MongoDB install
######################################################

# install git
#ADD /mongodb/mongodb.repo /etc/yum.repos.d/mongodb.repo
#RUN yum -y install mongodb mongodb-server
RUN echo -e "[mongodb] \n \
name=MongoDB Repository \n \
baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/ \n \
gpgcheck=0 \n \
enabled=1" >> /etc/yum.repos.d/mongo.repo

RUN yum install -y mongo-10gen mongo-10gen-server

RUN mkdir -p /data/db
RUN chkconfig --add mongod
RUN chkconfig --level 345 mongod on
RUN service mongod start
ADD mongodb/init.js /tmp/mongo_init.js
RUN service mongod start; mongo api  /tmp/mongo_init.js

######################################################
#			Maven install
######################################################

# install Maven
RUN cd /usr/share; wget ftp://mirror.reverse.net/pub/apache/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz; unzip apache-maven-3.0.5-bin.tar.gz; ln -s /usr/share/apache-maven-3.0.5/bin/mvn /usr/bin/mvn; rm apache-maven-3.0.5-bin.tar.gz 


######################################################
#			Tomcat install
######################################################

# install Tomcat
RUN yum -y install tomcat6
ADD tomcat/context.xml /usr/local/www/apache-tomcat-6.0.24/conf/
ADD tomcat/tomcat6 /etc/init.d/tomcat6
RUN /sbin/chkconfig --add tomcat6
RUN /sbin/chkconfig --level 345 tomcat6 on

######################################################
#			Users install
######################################################

RUN adduser iplant -g apache
RUN echo "password" | passwd iplant --stdin 
RUN mkdir -p /home/iplant/.globus/certificates; chown -R iplant /home/iplant/.globus


######################################################
#			Supervisor install
######################################################

# install supervisord
RUN yum install -y python-pip && pip install "pip>=1.4,<1.5" --upgrade
RUN pip install supervisor

######################################################
#			SSHD install
######################################################

# install sshd
RUN yum install -y openssh-server openssh-clients passwd
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key 
RUN sed -ri 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config && echo 'root:changeme' | chpasswd


######################################################
#			Agave install
######################################################

# Make sure you bind the Agave source folder on your system to the container at run time

ADD maven/settings.xml /usr/share/apache-maven-3.0.5/settings.xml
ADD php/phpinfo.php /var/www/html/
ADD supervisor/supervisord.conf /etc/
VOLUME [ "/Users/dooley/workspace/agave"
EXPOSE 22 443 80 8443 8080 11300 27017 3306
CMD ["supervisord", "-n"]
