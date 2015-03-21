Development tips
================

Some tips usefull during development.

Clone and prepare dev environment
---------------------------------

    mkdir -p ~/devel/docker-perl6/perl6-star
    cd ~/devel/docker-perl6/perl6-star/
    git clone git@github.com:mj41/docker-perl6-star.git .


Build and test locally
----------------------

Build mj41/perl6-star:my (note tag is 'my'):

    cd ~/devel/docker-perl6/perl6-star/
    docker build --force-rm --rm -t="mj41/perl6-star:my" .

Inspect containter created from mj41/perl6-star:my image:

    cd ~/devel/docker-perl6/perl6-star/
    docker run -i -t --rm --name my-perl6-star mj41/perl6-star:my /bin/bash

Show versions:

    perl6 -e'say "{$*PERL.compiler.gist} on {$*VM.gist} for {$*DISTRO.gist}"'

Test panda
----------

    time docker run -i -t --rm --name my-perl6-star mj41/perl6-star:my /bin/bash -c $' \
      whoami ; pwd ; which panda \
      ; panda install SP6 \
      ; time perl6 -e\' \
        use SP6; \
        my $sp = SP6.new(); \
        say "SP6 ok" \
      \' \
    '

Gen speed data
--------------

    ./dev/speed-test.sh 2>&1 | tee dev/speed-data.txt

Prepare release
---------------

Example for 2015.03 release.

Switch to 'develop' branch.

    git checkout develop

See commit related to previous release and take inspiration there.

    git show 2015.03
    vim Dockerfile
    cp tags/2015.02.md tags/2015.03.md
    git commit -m"Rakudo Star release 2015.03"

Prepare and push 'develop', 'latest' and new tag.

    git push
    git tag -s -m"Rakudo Star release 2015.03" 2015.03
    git push 2015.03
    git checkout latest
    git merge develop
    git push

Start build on [hub.docker.com](https://registry.hub.docker.com/u/mj41/perl6-star/).
