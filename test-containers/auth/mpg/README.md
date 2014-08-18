# Agave MyProxy Gateway Docker Container
================================
This is a standard installation of a MyProxy Gateway running in standalone mode with an embedde MyProxy server configured as an online CA for development use. The CA is a generic Globus Simple CA. The container has 4 users preinstalled and a SSH server running internally on port 22. The MPG API is proxied through apache and forces SSL on port 443. You can access it directly on port 8080 if you choose.

This container can be safely used in leu of installing MyProxy and MPG in development environments to test login and data movement in GSI environments. For sample GridFTP and GSI-OpenSSH containers, please see the corresponding README.md files in `storage/gridftp` and `logins/gsissh folders` respectively, or in `sso/gsi` for an orchestrated deployment.

## Container users

  root:root
  testuser:testuser
  testshareuser:testshareuser
  testotheruser:testotheruser

## Building Containers

Build from this directory using the enclosed Dockerfile

  $ docker build -rm -t agave-test-myproxy .

**NOTE** You will need to either add the hostname `docker.example.com` to your /etc/hosts file with the ip your docker container is running on (On a mac or windows run `boot2docker ip`). If you don't want to do this, then update the Dockerfile with the hostname of your local system (not localhost) and rebuild the container.

## Running Containers

To run the container interactively

docker run -h docker.example.com -i -p 10022:22 -p 8080:8080 -p 7512:7512 -p 7513:7513 -p 9000:80 -p 9443:443 agave-test-mpg
  $ docker run -h docker.example.com -i \
        -p 10022:22 \
        -p 8080:8080 \
        -p 8090:8090 \
        -p 7512:7512 \
        -p 7513:7513 \
        -p 9000:80 \
        -p 9443:443 \
        agave-test-mpg

If you would like to update any of the settings, either edit the settings.xml file and rebuild the container or pass any of the values in the file in as environmental variables and clean run the server. For example, the following would run MPG as a gateway to the XSEDE myproxy server rather than the embedded MyProxy CA:

  $ docker run -h docker.example.com -i \
        -p 10022:22 \
        -p 8080:8080 \
        -p 8090:8090 \
        -p 7512:7512 \
        -p 7513:7513 \
        -p 9000:80 \
        -p 9443:443 \
        -e "oa4mp.delegated.myproxy.host=myproxy.xsede.org"
        -e "oa4mp.auth.type=none"
        agave-test-mpg

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
