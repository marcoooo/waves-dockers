# Dockerfiles to create containers used in development and testing.
================================

## Container users

  root:root
  testuser:testuser
  testshareuser:testshareuser
  testotheruser:testotheruser

## Building Containers

Each container directory contains a separate Dockerfile which will build the desired container. The agave-test-base container's Dockerfile is in the root folder and must be build and tagged first prior to building any other containers.

  $ docker build -rm -t agave-test-base .

## Running Containers

  $ docker run -h docker.example.com -i \
    -p 10022:22     \ # SSHD, SFTP
    -p 59153:49153  \ # Supervisord
    [-p 12811:2811] \ # GridFTP
    [-p 12222:2222] \ # GSISSH
    [-p 17512:7512] \ # MyProxy
    [-p 12222:2222] \ # GSISSH
    [-p 11247:1247] [-e "PAM=true"] [-e "X509=true"] \ # IRODS
    [-p 10021:21]   \ # FTP
    [-p 10443:443]  \ # HTTPS
    [-p 10080:80]   \ # HTTP
    <container name>

## Orchestrating Infrastructure

If you would prefer to stand everything up at once, you can use the agaveup.sh script to build and connect all the necessary containers for testing. Each container folder also contains a <systemid>.json file to register the systems once the containers have started. You may use the registration.sh file to register your containers as systems in Agave.
