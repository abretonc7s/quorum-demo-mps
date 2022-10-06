#!/bin/sh

mkdir -p /var/log/tessera/;
mkdir -p /data/tm/;

echo "Starting tessera with MPS=$MPS"
if $MPS
then
    echo "creating mps config file"
    envsubst < /data/tessera-config-mps-template.json > /data/tessera-config.json
else
    envsubst < /data/tessera-config-template.json > /data/tessera-config.json
fi

cat /data/tessera-config.json

exec /tessera/bin/tessera \
    -configfile /data/tessera-config.json

