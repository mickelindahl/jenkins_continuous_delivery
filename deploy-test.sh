#!/bin/bash

# Surce envirnomnt variables
. ./env.sh

# Create and goto test folder
mkdir -p $TEST_FOLDER  && cd $TEST_FOLDER

# Clone repo nad chang name
git clone https://$GIT_ASKPASS@github.com/mickelindahl/$NAME.git
mv $TEST_FOLDER/$PROD_NAME $TEST_FOLDER/$TEST_NAME

# Copy configuration files from production to test 
cd $PROD_FOLDER/$PROD_NAME
cp docker-compose.yml $TEST_FOLDER/$TEST_NAME
cp Dockerfile $TEST_FOLDER/$TEST_NAME
cp .env $TEST_FOLDER/$TEST_NAME

# Stop  production
docker-compose stop

# Goto test
cd $TEST_FOLDER/$TEST_NAME

# Change container name and remmove external
# volume for db in compose file 
sed -i 's/_web/_web_test/g' docker-compose.yml
sed -i 's/_db/_db_test/g' docker-compose.yml
sed -i 's/\-\s\.\/postgres\/data/\#/g' docker-compose.yml

# Create the dumpall directory
mkdir -p postgres/dumpall

# Build and deploy
docker-compose build --no-cache
docker-compose up -d

