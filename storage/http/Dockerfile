######################################################
#
# Agave SSH Login Server
# Tag: agaveapi/apache-dev
#
# This is the base HTTP/S container used for testing
# HTTP movement in the Agave API. It extends from the agaveapi/centos-base
# image adding apache with SSL and htaccess enabled.
# Two directories are created, public and private.
# A sample file test_upload.bin is copied into both
# folders. It is password protected in the private
# directory with the container system usernames and
# passwords: testuser:testuser, testshareuser:testshareuser.
#
# https://bitbucket.org/taccaci/agave-environment
#
######################################################

FROM agaveapi/centos-base

MAINTAINER Rion Dooley <dooley@tacc.utexas.edu>

RUN yum -y install httpd mod_ssl

RUN mkdir /var/www/html/public
RUN for i in {1..20}; do echo $i >> /var/www/html/public/test_upload.bin; done
RUN cp -rf /var/www/html/public /var/www/html/private

ADD apache/htaccess /var/www/html/private/.htaccess
ADD apache/htpasswd /var/www/.htpasswd
ADD apache/ssl.conf /etc/httpd/conf.d/ssl.conf
ADD apache/httpd.conf /etc/httpd/conf/httpd.conf

RUN chown -R apache:apache /var/www

ADD supervisord.conf /etc/supervisord.conf
RUN mkdir /var/log/supervisor
EXPOSE 10389 22 80 443
CMD ["/usr/bin/supervisord"]
