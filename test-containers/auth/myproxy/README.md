## Agave DevOps MyProxy Server

This is a standard installation of MyProxy configured as an online CA for development use. The container has 4 users, a MyProxy server, and a SSH server running by default. The CA is a generic Globus Simple CA. This container can be safely used in leu of installing another MyProxy server in development environments to test login and data movement in GSI environments. For sample GridFTP and GSI-OpenSSH containers, please see `agaveapi/gridftp` and `agaveapi/gsissh` images respectively.


## What's inside

This development container will create three users for testing.
  root:root
  testuser:testuser
  testshareuser:testshareuser
  testotheruser:testotheruser

## How to use this image

### To run the container

  > docker run -h docker.example.com \
    -p 7512:7512 \ # MyProxy CA + PAM
    -p 7513:7513 \ # MyProxy CA with trust relationship to host keys below
    -p 10022:22     \ # SSHD, SFTP
    -rm -d -name some-myproxy \
    agaveapi/myproxy

### To link the container to another app

  > docker run --name some-app -link some-myproxy:myproxy -d application-that-uses-myporxy

### To disable SSLv3

The recent POODLE security vulnerability should not be an issue in a development environment, however, to configure a MyProxy server to run with SSLv3 disabled, you can add the `` environment variable to the above run commands.

  > docker run -h docker.example.com \
    -p 7512:7512 \ # MyProxy CA + PAM
    -p 7513:7513 \ # MyProxy CA with trust relationship to host keys below
    -p 10022:22     \ # SSHD, SFTP
    **-e GLOBUS_GSSAPI_FORCE_TLS=1** \
    -rm -d -name some-myproxy \
    agaveapi/myproxy

### Generating host keys

The host cert and key of the MPG will be printed to stdout on startup. To just get the keys, you can run the following.

  > docker run -h docker.example.com -i agave-test-mpg cat /myproxy-gateway/hostcerts/mpgcert.pem > ~/.globus/hostcert.pem
  > docker run -h docker.example.com -i agave-test-mpg cat /myproxy-gateway/hostcerts/new-mpgkey.pem > ~/.globus/hostkey.pem
  > chmod 600 ~/.globus/hostkey.pem

To generate a new set of host keys, use the included `create_hostcert` script by running the following command and paste the contents into the appropriate files.

  > docker run -h docker.example.com -i -t \
        agaveapi/myproxy \
        create_hostcert somehost.example.com someservicename

**NOTE** If you rebuild the container, the MyProxy CA cert will change and your keys will be invalidated. You will need to regenerate them afterwards.

## How to build this image

Build from this directory using the enclosed Dockerfile

  > docker build -rm -t agaveapi/myproxy .
