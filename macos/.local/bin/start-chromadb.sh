#!/bin/bash
CONTAINER_NAME="chromadb"
DOCKER="/opt/homebrew/bin/docker"

if $DOCKER ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    # Container exists, start it
    $DOCKER start $CONTAINER_NAME
else
    # Container doesn't exist, create it
    $DOCKER run --name $CONTAINER_NAME \
        -v /Users/zacharylevinw/.local/share/chromadb:/data \
        -p 8000:8000 \
        chromadb/chroma:0.6.3
fi
