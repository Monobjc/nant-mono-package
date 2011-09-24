#!/bin/bash

echo "Applying permissions..."

cd "$2"
cd ..
chown -R root:admin NAnt
