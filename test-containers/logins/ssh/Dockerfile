######################################################
#
# Agave SSH Login Server
# Tag: agave-test-ssh
#
# https://bitbucket.org/taccaci/agave-environment
#
######################################################

FROM agave-test-base

MAINTAINER Rion Dooley <dooley@tacc.utexas.edu>

ADD supervisord.conf /etc/supervisord.conf
EXPOSE 10389 22
CMD ["/usr/bin/supervisord"]
