######################################################
#
# Agave SSH Login Server
# Tag: agaveapi/sftp
#
# This is the base SFTP server container used for testing
# SFTP in the Agave API. It extends from the agaveapi/centos-base
# image with no modifications.
#
# https://bitbucket.org/taccaci/agave-environment
#
######################################################

FROM agave-test-base

MAINTAINER Rion Dooley <dooley@tacc.utexas.edu>

ADD supervisord.conf /etc/supervisord.conf
EXPOSE 10389 22
CMD ["/usr/bin/supervisord"]
