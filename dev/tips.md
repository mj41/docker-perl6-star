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

Inspect container created from mj41/perl6-star:my image:

    cd ~/devel/docker-perl6/perl6-star/
    docker run -i -t --rm --name my-perl6-star mj41/perl6-star:my /bin/bash

Show versions:

    perl6 -e'say "{$*PERL.compiler.gist} on {$*VM.gist} for {$*DISTRO.gist}"'

Test panda
----------

    time docker run -i -t --rm --name my-perl6-star mj41/perl6-star:my /bin/bash -c $' \
		time perl6 -e\'EVAL "print qq/Hello from Perl 5\n/;", :lang<perl5>;\' \
	'

    time docker run -i -t --rm --name my-perl6-star mj41/perl6-star:my /bin/bash -c $' \
      panda install SP6 \
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

Example for 2015.11 release.

Switch to 'develop' branch.

    git checkout develop

See commit related to previous release and take inspiration there.

    git show 2015.06..2015.09
    vim Dockerfile
    vim README.md
    cp tags/2015.09.md tags/2015.11.md
    git add -A ; git status
    git commit -m"Rakudo Star release 2015.11"

Prepare and push 'develop', 'latest' and new tag.

    git push
    git tag -s -m"Rakudo Star release 2015.11 (Fedora 23)" 2015.11
    git push origin 2015.11
    git checkout latest
    git merge develop
    git push
    git checkout develop

Add new tags to https://hub.docker.com/r/mj41/perl6-star/~/settings/automated-builds/ .

Start build on [hub.docker.com](https://registry.hub.docker.com/u/mj41/perl6-star/).
	export DOCKER_HUB_TOKEN='0b7...'
	curl -H "Content-Type: application/json" --data '{"source_type": "Tag", "source_name": "2015.11"}'    -X POST https://registry.hub.docker.com/u/mj41/perl6-star/trigger/$DOCKER_HUB_TOKEN/
	curl -H "Content-Type: application/json" --data '{"source_type": "Branch", "source_name": "latest"}'  -X POST https://registry.hub.docker.com/u/mj41/perl6-star/trigger/$DOCKER_HUB_TOKEN/
	curl -H "Content-Type: application/json" --data '{"source_type": "Branch", "source_name": "develop"}' -X POST https://registry.hub.docker.com/u/mj41/perl6-star/trigger/$DOCKER_HUB_TOKEN/
