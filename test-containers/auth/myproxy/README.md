# Agave MyProxy Container
================================
This is a standard installation of MyProxy configured as an online CA for development use. The container has 4 users, a MyProxy server, and a SSH server running by default. The CA is a generic Globus Simple CA. This container can be safely used in leu of installing another MyProxy server in development environments to test login and data movement in GSI environments. For sample GridFTP and GSI-OpenSSH containers, please see the corresponding README.md files in `storage/gridftp` and `logins/gsissh folders` respectively, or in `sso/gsi` for an orchestrated deployment.

## Container users

This development container will create three users for testing.
  root:root
  testuser:testuser
  testshareuser:testshareuser
  testotheruser:testotheruser

## Configuration

## Building Containers

Build from this directory using the enclosed Dockerfile

  $ docker build -rm -t agave-test-myproxy .

## Running Containers

To run the container interactively on port 7512,

  $ docker run -h docker.example.com -i \
    -p 7512:7512 \ # MyProxy CA + PAM
    -p 7513:7513 \ # MyProxy CA with trust relationship to host keys below
    -p 10022:22     \ # SSHD, SFTP
    agaveapi/myproxy

# Generating host keys

The host cert and key of the MPG will be printed to stdout on startup. To just get the keys, you can run the following.

  $ docker run -h docker.example.com -i agave-test-mpg cat /myproxy-gateway/hostcerts/mpgcert.pem > ~/.globus/hostcert.pem
  $ docker run -h docker.example.com -i agave-test-mpg cat /myproxy-gateway/hostcerts/new-mpgkey.pem > ~/.globus/hostkey.pem
  $ chmod 600 ~/.globus/hostkey.pem

To generate a new set of keys, run the following and paste the contents into the appropriate files.

  $ docker run -h docker.example.com -i \
        agave-test-mpg \
        grid-cert-request -host somehost.example.com -dir . -service somehost -prefix somehost -nopw && \
        echo "globus" | grid-ca-sign -days 3650 -in somehostcert_request.pem -out somehostcert.pem && \
        openssl rsa -in somehostkey.pem -outform PEM -out new-somehostkey.pem && \
        echo "New host cert is" && cat somehostcert.pem && echo "New host key is: " && cat new-somehostkey.pem

**NOTE** If you rebuild the container, the MyProxy CA cert will change and your keys will be invalidated. You will need to regenerate them afterwards.

## Orchestrating Infrastructure

If you would prefer to stand everything up at once, you can use the agaveup.sh script to build and connect all the necessary containers for testing. Each container folder also contains a <systemid>.json file to register the systems once the containers have started. You may use the registration.sh file to register your containers as systems in Agave.
