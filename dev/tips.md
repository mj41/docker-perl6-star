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

Test image
----------

    time docker run -i -t --rm --name my-perl6-star mj41/perl6-star:my /bin/bash -c $' \
		time perl6 -e\'EVAL "print qq/Hello from Perl 5\n/;", :lang<Perl5>;\' \
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

Example for 2016.07 ($STAR_REL) release.
Based on 2016.04 ($PREV1_STAR_REL) and 2016.01 ($PREV2_STAR_REL).

Switch to 'develop' branch.

    git checkout develop

See commit related to previous release and take inspiration there.

    export PREV2_STAR_REL='2016.07'
    export PREV1_STAR_REL='2016.10'
    export STAR_REL='2016.11'
    export BASED_ON='Fedora 25'
    echo "Preparing release of '$STAR_REL' (based on '$BASED_ON') based on '$PREV1_STAR_REL' and '$PREV2_STAR_REL'."

    cd ~/devel/docker-perl6/perl6-star/
    git show $PREV2_STAR_REL..$PREV1_STAR_REL
    cp tags/$PREV1_STAR_REL.md tags/$STAR_REL.md
    vim Dockerfile
    vim README.md
    vim tags/$STAR_REL.md
    git add -A ; git status
    git commit -m"Rakudo Star release $STAR_REL"

Try to build image. See 'Build and test locally' above.

Prepare and push 'develop', 'latest' and new tag.

    git push
    git tag -s -m"Rakudo Star release $STAR_REL ($BASED_ON)" $STAR_REL

    git push origin $STAR_REL
    git tag -d latest
    git tag -s -m"latest Rakudo Star release" latest

    git push origin latest --force
    git checkout develop

Login and add new tags to https://hub.docker.com/r/mj41/perl6-star/~/settings/automated-builds/
save and trigger new builds.

Start build on [hub.docker.com](https://registry.hub.docker.com/u/mj41/perl6-star/).

    export DOCKER_HUB_TOKEN='0b7...'
    while [ `curl -s https://hub.docker.com/r/mj41/perl6-star/builds/ | grep Building | wc -l` != "0" ]; do echo sleep && sleep 60; done
    curl -H "Content-Type: application/json" --data '{"source_type": "Tag", "source_name": "$STAR_REL"}'    -X POST https://registry.hub.docker.com/u/mj41/perl6-star/trigger/$DOCKER_HUB_TOKEN/
    sleep 60 ; while [ `curl -s https://hub.docker.com/r/mj41/perl6-star/builds/ | grep Building | wc -l` != "0" ]; do echo sleep && sleep 60; done
    curl -H "Content-Type: application/json" --data '{"source_type": "Tag", "source_name": "latest"}'  -X POST https://registry.hub.docker.com/u/mj41/perl6-star/trigger/$DOCKER_HUB_TOKEN/
    sleep 60 ; while [ `curl -s https://hub.docker.com/r/mj41/perl6-star/builds/ | grep Building | wc -l` != "0" ]; do echo sleep && sleep 60; done
    curl -H "Content-Type: application/json" --data '{"source_type": "Branch", "source_name": "develop"}' -X POST https://registry.hub.docker.com/u/mj41/perl6-star/trigger/$DOCKER_HUB_TOKEN/
    sleep 60 ; while [ `curl -s https://hub.docker.com/r/mj41/perl6-star/builds/ | grep Building | wc -l` != "0" ]; do echo sleep && sleep 60; done
