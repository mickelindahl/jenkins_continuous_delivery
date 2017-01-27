#!/usr/bin/env bash
export GIT_PROJECT=greendrive
export TEST_FOLDER=/opt/apps/test
export PROD_FOLDER=/opt/apps
export PROD_NAME=greendrive

TEST_NAME=$PROD_NAME"_test"
export TEST_NAME

# Grep git askpass token from docker-compose.yml and make available
GIT_PERSONAL_ACCESS_TOKEN_LINE=$(grep -i 'GIT_PERSONAL_ACCESS_TOKEN' $PROD_FOLDER/$PROD_NAME/docker-compose.yml)
GIT_PERSONAL_ACCESS_TOKEN=${GIT_PERSONAL_ACCESS_TOKEN_LINE##*:} # Get token
GIT_PERSONAL_ACCESS_TOKEN="$(echo -e "${GIT_PERSONAL_ACCESS_TOKEN}" | tr -d '[:space:]')"
