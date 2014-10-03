# Agave DevOps Beanstalkd
================================

## Existing user accounts

* root:root
* testuser:testuser
* testshareuser:testshareuser
* testotheruser:testotheruser
* beanstalkd

## Building Containers

Each container directory contains a separate Dockerfile which will build the desired container. The agave-test-base container's Dockerfile is in the root folder and must be build and tagged first prior to building any other containers.

	$ docker build -rm -t agaveapi/beanstalkd .

## Running Containers

	$ docker run -h docker.example.com -i \
    			 -p 10022:22              \ # SSHD, SFTP
				 -p 11300:11300           \ # beanstalkd
				 agaveapi/beanstalkd

## Persistent Tubes

	$ docker run -h docker.example.com -i \
    			 -p 10022:22              \ # SSHD, SFTP
    			 -p 11300:11300           \ # beanstalkd
    			 -v /var/lib/beanstalkd/binlog:/data \ # persistent tubes
    			 agaveapi/beanstalkd

## Orchestrating Infrastructure

Add this to your fig.yml

	beanstalkd:
		image: agaveapi/beanstalkd
		volumes:
			- /var/lib/beanstalkd/binlog:/data
		ports:
			- "11300:11300"
