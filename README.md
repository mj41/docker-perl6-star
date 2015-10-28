mj41/perl6-star
===============

[mj41/perl6-star](https://registry.hub.docker.com/u/mj41/perl6-star/) is unofficial [Docker](https://www.docker.com/whatisdocker/) image
of [Rakudo Star](http://rakudo.org/about/) [Perl 6](http://perl6.org/) with [MoarVM backend](http://moarvm.com/)
based on [Fedora 22](https://registry.hub.docker.com/_/fedora/) Docker image and maintained by [mj41](https://github.com/mj41).

Source code of Dockerfile and utilities live on [github.com/mj41/docker-perl6-star](https://github.com/mj41/docker-perl6-star).

The official Docker image
-------------------------

[The official Docker image of Perl 6 Rakudo Star](https://registry.hub.docker.com/_/rakudo-star/) has name '[rakudo-star](https://registry.hub.docker.com/_/rakudo-star/)' and is based on [buildpack-deps](https://registry.hub.docker.com/_/buildpack-deps/). Source repository of 'rakudo-star' is available on [github.com/perl6/docker](https://github.com/perl6/docker).

HowTo intro
-----------

You should know what Docker, Docker image and Docker containers are about. Please read:

* [Docker About](https://docs.docker.com/)
* [Working with Docker Images](https://docs.docker.com/userguide/dockerimages/)
* [Working with Containers](https://docs.docker.com/userguide/usingdocker/)
* [Understanding Docker](https://docs.docker.com/introduction/understanding-docker/)

HowTo prepare
-------------

Install and start Docker service. Example for Fedora 22:

    sudo dnf -y install docker
    sudo systemctl start docker
    sudo systemctl status docker
    docker info

For other distributions or Mac OS see [installation guide](https://docs.docker.com/installation/#installation).

Pull mj41/perl6-star image. Command below is going to download nearly 1GB of data from Internet.
It contains base fedora:22 image and many other layers of mj41/perl6-star Docker image.

    docker pull mj41/perl6-star:latest

HowTo Hello word
----------------

Try "Hello world from Docker container".

    docker run -i -t --rm --name my-first-p6-temp mj41/perl6-star:latest /bin/bash -c $'perl6 -e\'say "Hello world from Docker container!"\''

HowTo play with Rakudo Perl 6
-----------------------------

Create interactive container and run Bash shell inside:

    docker run -i -t --name p6-test-container mj41/perl6-star:latest /bin/bash

Now you can run e.g.

    perl6 -e'say "hello"'

Command 'exit' is going to exit shell and container is stopped

    exit

See all (including stopped) containers

    docker ps -a

Start 'p6-test-container' container (Bash) again

    docker start -i p6-test-container
    exit

You can delete container and all data/files you made inside:

    docker rm p6-test-container

HowTo mount your host directory
-------------------------------

You can mount your host directory to Docker container (read-write):

    export P6_DEV_DIR="$HOME/perl6-my-dev/"
    echo $P6_DEV_DIR
    mkdir -p $P6_DEV_DIR
    chmod a+rwx $P6_DEV_DIR
    chcon -Rt svirt_sandbox_file_t $P6_DEV_DIR
    echo 'say "Hello from host file running inside Docker container."' > $P6_DEV_DIR/base-test.p6
    docker run -i -t --rm -v $P6_DEV_DIR:/mnt/host-p6-dir:ro --name p6-dev-container mj41/perl6-star:latest /bin/bash

and inside container bash:

    perl6 /mnt/host-p6-dir/base-test.p6

Image Tags
----------
* [2015.09](https://github.com/mj41/docker-perl6-star/blob/develop/tags/2015.09.md)
* latest (point to newest tag of Rakudo Star release)

Outdated image tags
-------------------
* [2015.07](https://github.com/mj41/docker-perl6-star/blob/develop/tags/2015.07.md) (Fedora 22)
* [2015.06](https://github.com/mj41/docker-perl6-star/blob/develop/tags/2015.06.md) (Fedora 22)
* [2015.03](https://github.com/mj41/docker-perl6-star/blob/develop/tags/2015.03.md) (Fedora 21)
* [2015.02](https://github.com/mj41/docker-perl6-star/blob/develop/tags/2015.02.md) (Fedora 21)
* [2015.01](https://github.com/mj41/docker-perl6-star/blob/develop/tags/2015.01.md) (Fedora 21)
