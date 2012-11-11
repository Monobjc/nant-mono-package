#!/bin/bash

# Version check
if [ "x$VERSION" == "x" ]; then
    VERSION=`date "+%Y-%m-%d"`
fi

# Applications
PKG_MAKER="/Developer/Applications/PackageMaker.app/Contents/MacOS/PackageMaker"
if [ ! -f $PKG_MAKER ]; then
	echo "PackageMaker was not found."
	exit -1
fi

# Folders
SRC_DIR="`pwd`/src"
BIN_DIR="`pwd`/NAnt"

# Git repositories
NANT_GIT="https://github.com/nant/nant.git"
NANT_CONTRIB_GIT="https://github.com/nant/nantcontrib.git"

# Prepare the folders
rm -Rf "$SRC_DIR"
rm -Rf "$BIN_DIR"
mkdir -p "$SRC_DIR"
mkdir -p "$BIN_DIR"

# Fetch the sources
cd "$SRC_DIR"
git clone "$NANT_GIT"
git clone "$NANT_CONTRIB_GIT"
cd -

# Build the sources
cd "$SRC_DIR/nant"
make MCS=dmcs TARGET=mono-4.0 all
cd -
cd "$SRC_DIR/nantcontrib"
nant build
cd -

# Copy the result for NAnt
cp -R "$SRC_DIR/nant/build/mono-4.0.unix/nant-debug"/* "$BIN_DIR/"

# Copy the NAnt-Contrib
NANT_CONTRIB_BIN_DIR="$SRC_DIR/nantcontrib/build/nantcontrib-debug/bin"
NANT_CONTRIB_EXTENSION_DIR="$BIN_DIR/bin/extensions/common/neutral/NAntContrib"
NANT_CONTRIB_LIB_DIR="$BIN_DIR/bin/lib/common/neutral/NAntContrib"
mkdir -p "$NANT_CONTRIB_EXTENSION_DIR"
mkdir -p "$NANT_CONTRIB_LIB_DIR"
cp "$NANT_CONTRIB_BIN_DIR"/NAnt.* "$NANT_CONTRIB_EXTENSION_DIR/"
cp "$NANT_CONTRIB_BIN_DIR"/CollectionGen.dll "$NANT_CONTRIB_LIB_DIR/"
cp "$NANT_CONTRIB_BIN_DIR"/Interop.MsmMergeTypeLib.dll "$NANT_CONTRIB_LIB_DIR/"
cp "$NANT_CONTRIB_BIN_DIR"/Interop.StarTeam.dll "$NANT_CONTRIB_LIB_DIR/"
cp "$NANT_CONTRIB_BIN_DIR"/Interop.WindowsInstaller.dll "$NANT_CONTRIB_LIB_DIR/"
cp "$NANT_CONTRIB_BIN_DIR"/SLiNgshoT.Core.dll "$NANT_CONTRIB_LIB_DIR/"
cp "$NANT_CONTRIB_BIN_DIR"/SourceSafe.Interop.dll "$NANT_CONTRIB_LIB_DIR/"

# Create the archive
ARCHIVE="NAnt-$VERSION.tar.gz"
tar -zcf $ARCHIVE NAnt

# Create the package
PMDOC_SRC="package.pmdoc"
PMDOC_DST="package-$VERSION.pmdoc"
mkdir -p "$PMDOC_DST"
for f in $(ls "$PMDOC_SRC"); do
	file=`basename $f`
	sed -e "s/@VERSION@/$VERSION/g" "$PMDOC_SRC/$file" > "$PMDOC_DST/$file"
done
"$PKG_MAKER" --verbose --doc "$PMDOC_DST" -o "NAnt-$VERSION.pkg"
