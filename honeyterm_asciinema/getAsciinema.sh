#!/bin/bash

DIRECTORY=/tmp/honeypot


array=(`docker ps -a --format "{{.Names}}"`)
for element in "${array[@]}"
do
    echo $element
    if [ ! -d "$DIRECTORY/$element" ]; then
        mkdir -p $DIRECTORY/$element
    fi
    docker cp "$element":/var/log/honii/ "$DIRECTORY/$element/" > /dev/null 2>&1
    mv $DIRECTORY/$element/honii/* $DIRECTORY/$element/
    rmdir $DIRECTORY/$element/honii
done
