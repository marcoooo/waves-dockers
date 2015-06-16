######################################################
#
# Agave Amazon S3 Fake Server
# Tag: agaveapi/fake-s3
#
# This is an instance of the Ruby "fakes3" gem which
# emulates most of the functionality of Amazon S3
# for testing.
#
# https://bitbucket.org/taccaci/agave-environment
#
######################################################

FROM ruby:2.1.4
MAINTAINER Steven Jack <stevenmajack@gmail.com>

RUN mkdir -p /var/data/fake-s3 /usr/src/app
WORKDIR /usr/src/app

RUN gem install fakes3

EXPOSE 4569

ENTRYPOINT ["fakes3", "-r" ,"/var/data/fake-s3", "-p", "4569"]
