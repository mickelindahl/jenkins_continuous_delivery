#!/bin/bash

# Source environemnt variables
. ./env.sh

# Goto porject
cd /$PROD_FOLDER/$PROD_NAME

# Bring container back uo
docker-compose up -d
