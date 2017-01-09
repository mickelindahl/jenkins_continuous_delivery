#!/bin/bash

# Source  environment variables
. $1/jenkins.env.sh

# Goto test folder
cd $TEST_FOLDER/$TEST_NAME

# Remove test container and  node modules volume
docker-compose stop
docker-compose rm -f
# docker volume rm $NAME"test_node_modules"  #Exclude for a faster builds

# Remove project folder
cd ..
rm -rf $TEST_FOLDER
