#!/bin/bash

CVSROOT=:pserver:anonymous@nant.cvs.sourceforge.net:/cvsroot/nant

# Build NAnt
cvs -d $CVSROOT co -P nant

# Patch the Makefile and build NAnt
cd nant
cp Makefile Makefile.orig
cat Makefile.orig | sed -e "s/MCS=mcs/MCS=dmcs/" > Makefile
rm Makefile.orig
make TARGET=mono-2.0 all
make TARGET=mono-4.0 all
cd -

# Create the archive
ARCHIVE="`pwd`""/NAnt.tar.gz"
cd nant/build/mono-4.0.unix/nant-*
tar -zcf $ARCHIVE .
cd -

# Create the package
/Developer/usr/bin/packagemaker --verbose --doc package.pmdoc -o NAnt.pkg
