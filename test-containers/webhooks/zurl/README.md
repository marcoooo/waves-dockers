# Zurl Webhook Server
====
Created from fork of [http://github.com/fanout/zurl](http://github.com/fanout/zurl)

## Description

Dockerized HTTP and WebSocket client worker with ZeroMQ interface.

## License

Zurl is offered under the GNU GPL. See the COPYING file.

## Features

  * Request HTTP and HTTPS URLs
  * Connect to WS and WSS URLs for WebSockets
  * Completely event-driven, using JDNS and Libcurl
  * Handle thousands of simultaneous outbound connections
  * Two access methods: REQ and PUSH/SUB (think Mongrel2 in reverse!)
  * Streaming requests and responses
  * Packet format can be JSON or TNetStrings
  * Set access policies (e.g. block requests to 10.*)

## Running

Clients interacting with Zurl need to read and write to a handful of  sockets the container is listening on. In order to accomplish this, you will need to either bind-mount the Zurl container to the local file system, or you will need to volume mount the Zurl container to the client's container.

To start the container and access the socket from the local system

	docker run -d -v /private/tmp:/tmp --name zurl-server zurl
	docker run -it -v /private:tmp:/tmp zurl python tools/get.py http://fanout.io/ 


Then to volume mount the container

	docker run -d -v /private/tmp:/tmp --name zurl-server zurl
	docker run -it --volumes-from="zurl-server" zurl python tools/get.py http://fanout.io/ 

## Misc

* Make sure the container has a valid hostname for validating the white list and black list. 
* If running on through boot2docker, the server will not be accessible because of issues access bind-mounted volumes as sockets. 
* The published image is a little inflated due to python being installed to run the test suite included in the github repo. You can comment out these lines in the Dockerfile and rebuild for a smaller image.
