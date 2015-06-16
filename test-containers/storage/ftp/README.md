# Agave Pure-FTPD Image
================================
This is a standard installation of [pure-ftpd](http://www.pureftpd.org/project/pure-ftpd) on centos 6.5. The container has 4 users, a pure-ftpd server, and a SSH server running by default. Each user has 
access to `/` with their standard home folder, `/home/$USERNAME`, set as the
virtual root directory.

> This image should not be used in production

## Container users

This development container will create three users for testing.
  root:root
  testuser:testuser
  testshareuser:testshareuser
  testotheruser:testotheruser

## Configuration

Nothing to see here

## Building Containers

Build from this directory using the enclosed Dockerfile

```
docker build -rm -t agave-test-myproxy .
``` 

## Running Containers

To run the container in daemon mode on port 21,

```
docker run -d --name=ftpd 	-h docker.example.com -p 10021:21 -p 10022:22 agaveapi/pure-ftpd  
```  
  
## Orchestrating Infrastructure

If you would prefer to stand everything up at once, you can use the agaveup.sh script to build and connect all the necessary containers for testing. Each container folder also contains a <systemid>.json file to register the systems once the containers have started. You may use the registration.sh file to register your containers as systems in Agave.
