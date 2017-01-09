#!/bin/bash

# Source environment variables
. $1/jenkins.env.sh 

# Goto production folder
cd $PROD_FOLDER/$PROD_NAME

# Pull latest code 
git pull origin master

# Deploy in container
docker-compose stop
docker-compose build --no-cache
docker-compose up -d
