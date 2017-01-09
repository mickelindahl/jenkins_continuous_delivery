#!/usr/bin/env bash
export GIT_PROJECT=greendrive
export TEST_FOLDER=/opt/apps/test
export PROD_FOLDER=/opt/apps
export PROD_NAME=greendrive
TEST_NAME=$PROD_NAME"_test"
export TEST_NAME

# Grep git askpass token from docker-compose.yml and make available
GIT_ASKPASS_LINE=$(grep -i 'GIT_ASKPASS' $PROD_FOLDER/$PROD_NAME/docker-compose.yml)
GIT_ASKPASS=${GIT_ASKPASS_LINE##*:} # Get token
GIT_ASKPASS="$(echo -e "${GIT_ASKPASS}" | tr -d '[:space:]')"

export GIT_ASKPASS
