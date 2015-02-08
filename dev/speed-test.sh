#!/bin/bash

IMAGE="mj41/perl6-star:my"

echo "Create new Docker container and run perl6 hello world:"
time docker run -i -t --name p6-speed-test-container1 $IMAGE /bin/bash -c $'time perl6 -e\'say "Hello world from Docker container!"\''
echo

echo "Remove just created container:"
time docker rm -f p6-speed-test-container1
echo

echo "Create new container, run perl6 hello world and remove container:"
time docker run -i -t --rm --name p6-speed-test-container2 $IMAGE /bin/bash -c $'time perl6 -e\'say "Hello world from Docker container!"\''
echo
