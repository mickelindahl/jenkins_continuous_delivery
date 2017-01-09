#!/usr/bin/env bash
export NAME=stake
export TEST_FOLDER=/opt/apps/test
export PROD_FOLDER=/opt/apps
export PROD_NAME=$NAME
TEST_NAME=$NAME"_test"
export TEST_NAME

# Add tokn to git askpass
GIT_ASKPASS_LINE=$(grep -i 'GIT_ASKPASS' $PROD_FOLDER/$PROD_NAME/docker-compose.yml)
GIT_ASKPASS=${GIT_ASKPASS_LINE##*:} # Get token

GIT_ASKPASS="$(echo -e "${GIT_ASKPASS}" | tr -d '[:space:]')"

#GIT_ASKPASS=${GIT_ASKPASS##*:} # Remove leading whitespace
export GIT_ASKPASS
