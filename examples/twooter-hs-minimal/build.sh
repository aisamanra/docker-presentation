#!/bin/sh

echo "Running image and saving container id..."
docker run --cidfile=cid.tmp twooter-hs /bin/false
echo "Copying application out of container..."
docker cp $(cat cid.tmp):/.cabal/bin/twooter-hs .
rm -f cid.tmp
docker build -t twooter-hs-minimal .
