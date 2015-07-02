#!/bin/sh

set -e
#set -x

TYPE="$1"
RELEASE="$2"
INSTALL_PREFIX="$3"
PAR1="$4"

RUN_TESTS=1
if [ "$PAR1" == "skip_testing" ]; then
	RUN_TESTS=0
fi

CACHE_DIR="cache"

TARBALL_FNAME="rakudo-star-${RELEASE}.tar.gz"
if [ -e "$CACHE_DIR/$TARBALL_FNAME" ]; then
	echo "Using cache file '$CACHE_DIR/$TARBALL_FNAME' instead of downloading it."
	mv "$CACHE_DIR/$TARBALL_FNAME" ./star-tarball.tar.gz
else
	echo "Downloading $TARBALL_FNAME."
	TARBALL_URL="http://rakudo.org/downloads/star/$TARBALL_FNAME"
	curl -o star-tarball.tar.gz --get -L -O $TARBALL_URL
fi
tar -xzf star-tarball.tar.gz
rm -f star-tarball.tar.gz

XDIR="rakudo-star-${RELEASE}"
mv $XDIR rakudo-star-tmp

cd rakudo-star-tmp
perl Configure.pl --backend=moar --gen-moar --prefix="$INSTALL_PREFIX"
make
if [ "$RUN_TESTS" == 1 ]; then
	make test
fi
make install

cd  ..
rm -rf rakudo-star-tmp

# Initialize panda
export PATH="$PATH:$INSTALL_PREFIX/bin:$INSTALL_PREFIX/languages/perl6/site/bin"
DESTDIR="$INSTALL_PREFIX" panda --version
