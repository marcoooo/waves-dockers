# Agave DevOps GridEngine Container

This is a development install of the GridEngine scheduler running as a scheduler and worker. This image can be treated like a single node cluster for testing purposes.

## What is GridEngine

Open Grid Scheduler/Grid Engine is a commercially supported open-source batch-queuing system for distributed resource management. OGS/GE is based on Sun Grid Engine, and maintained by the same group of external (i.e. non-Sun) developers who started contributing code since 2001.
For more information on GridEngine, consult the official [website](http://gridscheduler.sourceforge.net/).

## What's inside

This development container will create an admin user and three users for testing.

  root:root
  testuser:testuser
  testshareuser:testshareuser
  testotheruser:testotheruser

## How to use this image

### To run the container

  > docker run -d -h docker.example.com \
    -p 10022:22     \ # SSHD, SFTP
    --name gridengine \ 
    agaveapi/gridengine

This will start the container with a supervisor process which will run a sshd server on exposed port 22 and the GridEngine scheduler running as both a controller and worker node.

### To submit jobs

You will need to create an interactive session in order to run jobs in this container. There are two ways to do this.

* First, you can start a container with the default command and ssh in.

  > docker run -h docker.example.com -p 10022:22 --rm -d --name gridengine agaveapi/gridengine
  > ssh -p 10022 testuser@docker.example.com

* Second, you can run an interactive container and start the services yourself.

  > docker run -h docker.example.com -p 10022:22 --rm -d --name gridengine --privileged agaveapi/gridengine bash
  bash-4.1# /usr/bin/supervisord &

In either situation, once you have a session in the container, you can submit jobs using the `qsub` command. A test script is included in the image at `/home/testuser/gridengine.submit`. You can submit this script to verify the
scheduler is working properly.

  > qsub /home/testuser/gridengine.submit


## How to build the image

Build from this directory using the enclosed Dockerfile

  > docker build -rm -t agaveapi/gridengine .
