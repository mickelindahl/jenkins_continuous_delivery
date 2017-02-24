#!/bin/bash

# Source environemnt variables
. $1/jenkins.env.sh

# Goto porject
cd /$PROD_FOLDER/$PROD_NAME

# Bring container back uo
docker-compose up -d

# Remove all images untagged images
docker rmi $(docker images -f "dangling=true" -q)
