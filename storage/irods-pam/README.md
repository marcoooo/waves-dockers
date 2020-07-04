# Agave DevOps IRODS + PAM Server

This is a standard installation of an IRODS server configured using PAM authentication. The container has 5 users, an IRODS server, and a SSH server running by default.

## What's IRODS

The Integrated Rule-Oriented Data System (iRODS) is an open-source data management software in use at research organizations and government agencies worldwide.  iRODS is a production-level distribution aimed at deployment in mission critical environments.  It functions independently of storage resources and abstracts data control away from storage devices and device location allowing users to take control of their data.  As data volumes grow and data services become more complex, iRODS is increasingly important in data management. The development infrastructure supports exhaustive testing on supported platforms; plug-in support for microservices, storage resources, drivers, and databases; and extensive documentation, training and support services.

For more information about IRODS, visit the official [website](http://irods.org/).

## What's inside

This development container will create three users for testing.
  root:root
  irods:irods
  testuser:testuser
  testshareuser:testshareuser
  testotheruser:testotheruser

## How to use this image

### To run the container

  > docker run -h docker.example.com  -i --rm \
    -p 1247:1247    \ # IRODS
    -p 10022:22     \ # SSHD, SFTP
    -rm -d -name some-irods \
    agaveapi/irods-pam

### To link the container to another app

  > docker run --name some-app -link some-irods:irods -d application-that-uses-irods

    Note: When communicating with this container, you will need to either add the ssl public key to your local truststore in order for the SSL communication to work, or disable host verification.

### To run iCommands

You can also use a container as a zero-install way of running iCommands. To avoid having to reinitialize authentication every time you run a command, mount a local directory as a volume where your cached credentials will be held.

  > docker run -i --rm -v $HOME/.irods:$HOME/.irods agaveapi/irods-pam iinit
  > docker run -i --rm -v $HOME/.irods:$HOME/.irods agaveapi/irods-pam ils

Alternatively, you can simply start an interactive shell in the container and run all your commands within that session. This has the added benefit of remembering your commands within the session. As long as you mount a local directory for your cached volume, you will not have to reauthenticate again using this approach either.

  > docker run -i --rm -v $HOME/.irods:$HOME/.irods agaveapi/irods-pam bash
  bash-4.1# iinit
  bash-4.1# ils


## Building the image

Build from this directory using the enclosed Dockerfile

  > docker build -rm -t agaveapi/irods .
