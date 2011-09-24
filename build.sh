#!/bin/bash

CVSROOT=:pserver:anonymous@nant.cvs.sourceforge.net:/cvsroot/nant

# Build NAnt
cvs -d $CVSROOT co -P nant
cd nant

# Patch the Makefile
cp "Makefile" "Makefile.orig"
cat "Makefile.orig" sed -e "s/MCS=mcs/MCS=dmcs/" > "Makefile"
rm "Makefile.orig"

make TARGET=mono-2.0 all
make TARGET=mono-4.0 all

cd ..

# Create the package
/Developer/usr/bin/packagemaker --verbose --doc package.pmdoc -o NAnt.pkg
