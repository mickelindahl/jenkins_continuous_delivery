#!/bin/bash

# Source  environment variables
. ./env.sh

# Goto test folder
cd $TEST_FOLDER/$TEST_NAME

# Remove test container and  node modules volume
docker-compose stop
docker-compose rm -f
docker volume rm $NAME"test_node_modules"

# Remove project folder
cd ..
rm -rf $TEST_FOLDER
