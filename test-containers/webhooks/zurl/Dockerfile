FROM ubuntu:14.04
MAINTAINER dooley@tacc.utexas.edu

RUN apt-get update
RUN apt-get install -y build-essential pkg-config libcurl4-openssl-dev curl python-pip python-dev
RUN apt-get install -y libzmq1 libzmq3-dev
RUN apt-get install -y qt-sdk libqjson-dev

RUN pip install tnetstring pyzmq
RUN git clone https://github.com/deardooley/zurl.git
WORKDIR zurl
RUN git submodule init && \
    git submodule update

RUN ./configure && make
RUN cp zurl.conf.example zurl.conf
RUN (./zurl --verbose --config=zurl.conf &) && \
    python tools/get.py http://fanout.io/

VOLUME ["/tmp"]
CMD [ "/zurl/zurl", "--verbose", "--config=zurl.conf"]
