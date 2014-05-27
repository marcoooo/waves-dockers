## Java 7, Maven, Git - Dockerfile

This repository contains a **Dockerfile** to create a docker container with Java 1.7, Maven and Git

This **Dockerfile** has been published as a [trusted build](https://index.docker.io/u/alexeiled/java7-maven-git/) to the public [Docker Registry](https://index.docker.io/).


### Dependencies

* [dockerfile/java](http://dockerfile.github.io/#/java)


### Installation

1. Install [Docker](https://www.docker.io/).

2. Download [trusted build](https://index.docker.io/u/alexeiled/java7-maven-git) from public [Docker Registry](https://index.docker.io/): `docker pull alexeiled/java7-maven-git`


### Usage

#### Run container and clone git repo into container

    docker run -i -t alexeiled/java7-maven-git git clone <your repo url>
    
#### Run container and get terminal prompt

    docker run -i -t alexeiled/java7-maven-git
    
#### Run container and start maven build

    docker run -i -t alexeiled/java7-maven-git mvn <your project folder>
