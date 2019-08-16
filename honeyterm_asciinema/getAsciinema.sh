#!/bin/bash

DIRECTORY=/tmp/honeypot

if [ ! -d "$DIRECTORY" ]; then
    mkdir $DIRECTORY
fi

array=(`docker ps --format "{{.Names}}"`)
for element in "${array[@]}"
do
    echo $element
    docker cp "$element":/tmp/asciinema.json "$DIRECTORY/$element".json > /dev/null 2>&1
    docker cp "$element":/tmp/login "$DIRECTORY/$element".json > /dev/null 2>&1
done
