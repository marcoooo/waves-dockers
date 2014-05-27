#################################################################
# Creates a base Ubuntu 12.04 image with PHP 5.3
#
#                    ##        .
#              ## ## ##       ==
#           ## ## ## ##      ===
#       /""""""""""""""""\___/ ===
#  ~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~
#       \______ o          __/
#         \    \        __/
#          \____\______/
#
# Author:    Rion Dooley <dooley@tacc.utexas.edu
# License:   BSD 2-Clause
#################################################################

FROM ubuntu:12.04
MAINTAINER Rion Dooley <dooley@tacc.utexas.edu

#Install dependencies
RUN apt-get -q -y update
RUN apt-get install -q -y wget curl build-essential git apache2 php5 libapache2-mod-php5 git php5-dev python-software-properties openssl php-gd php-ldap php-pear php-xml php-curl php-xmlrpc php-mcrypt


RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ precise universe" >> /etc/apt/sources.list
RUN apt-get -q -y update
RUN apt-get install -q -y ca-certificates

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
