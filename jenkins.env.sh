#!/usr/bin/env bash
export GIT_PROJECT=greendrive
export TEST_FOLDER=/opt/apps/test
export PROD_FOLDER=/opt/apps
export PROD_NAME=greendrive
export GIT_ASKPASS=/opt/apps/git_askpass.sh

TEST_NAME=$PROD_NAME"_test"
export TEST_NAME

# Grep git askpass token from docker-compose.yml and make available
GIT_TOKEN_LINE=$(grep -i 'GIT_PERSONAL_ACCESS_TOKEN' $PROD_FOLDER/$PROD_NAME/docker-compose.yml)
GIT_TOKEN=${GIT_TOKEN_LINE##*:} # Get token
GIT_TOKEN="$(echo -e "${GIT_TOKEN}" | tr -d '[:space:]')"

# Add credentials to askpass file
echo "#! /bin/bash" > $GIT_ASKPASS && echo "echo "$GIT_TOKEN >> $GIT_ASKPASS
