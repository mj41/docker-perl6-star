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
