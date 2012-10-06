#!/bin/bash

echo "Applying permissions..."

cd "$2"
cd ..
chown -R root:admin NAnt


echo "Creating launcher..."

cd "/Library/Frameworks/Mono.framework/Versions/Current/bin"
echo "#!/bin/sh" > nant
echo "exec /Library/Frameworks/Mono.framework/Versions/Current/bin/mono /Library/Frameworks/Mono.framework/Versions/Current/share/NAnt/bin/NAnt.exe \"$@\"" >> nant
chown -R root:admin nant


echo "Creating symlink..."

cd "/usr/bin"
ln -s "/Library/Frameworks/Mono.framework/Commands/nant" nant
