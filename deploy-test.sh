#!/bin/bash

# Source environment variables

echo "PROJECT_PATH:"$1
. $1/jenkins.env.sh

echo "Creating and entering test folder:"$TEST_FOLDER
mkdir -p $TEST_FOLDER  && cd $TEST_FOLDER

echo "Cloning repo"
git clone https://$GIT_ASKPASS@github.com/mickelindahl/$GIT_PROJECT.git

echo "Rename repo "$TEST_FOLDER/$PROD_NAME" -> "$TEST_FOLDER/$TEST_NAME
mv $TEST_FOLDER/$PROD_NAME $TEST_FOLDER/$TEST_NAME


echo "Enter "$PROD_FOLDER/$PROD_NAME 
cd $PROD_FOLDER/$PROD_NAME

echo "Copy file docker-compose.yml to "$TEST_FOLDER/$TEST_NAME
cp docker-compose.yml $TEST_FOLDER/$TEST_NAME

echo "Copy file Dockerfile to "$TEST_FOLDER/$TEST_NAME
more Docke file
cp Dockerfile $TEST_FOLDER/$TEST_NAME

echo "Copy file .env to "$TEST_FOLDER/$TEST_NAME
cp .env $TEST_FOLDER/$TEST_NAME

echo "Stop  production"
docker-compose stop

echo "Goto test"
cd $TEST_FOLDER/$TEST_NAME

echo "Change container name and remmove external"
echo "volume for db in compose file"
sed -i 's/_web/_web_test/g' docker-compose.yml
sed -i 's/_db/_db_test/g' docker-compose.yml
sed -i 's/\-\s\.\/postgres\/data/\#/g' docker-compose.yml

echo "Create the dumpall directory"
mkdir -p postgres/dumpall

echo "Build and deploy"
#docker-compose build --no-cache
docker-compose build # Faster builds, seems not to be true, or not...
docker-compose up -d

