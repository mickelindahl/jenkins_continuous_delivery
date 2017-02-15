#!/bin/bash

# Source  environment variables
. $1/jenkins.env.sh

# Skip if deploy test directory has not been created
if [ ! -d "$TEST_FOLDER/$TEST_NAME" ]; then
  # Control will enter here if $DIRECTORY doesn't exist.
  exit 0
fi

# Goto test folder
cd $TEST_FOLDER/$TEST_NAME

# Test container are stoped and removed if created
docker-compose stop
docker-compose rm -f
# docker volume rm $NAME"test_node_modules"  #Exclude for a faster builds

# Remove project folder
cd ..
rm -rf $TEST_FOLDER
