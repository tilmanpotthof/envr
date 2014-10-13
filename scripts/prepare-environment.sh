#!/usr/bin/env bash

CURRENT_ENVIRONMENT_FILE=".current_environment"
ENVIRONMENT_DEPENDENT_FILES=".environment-dependent-files"
ENVIRONMENTS_DIR="environments"
BASE_PATH=`pwd`
LATEST_SQL="sql/latest.sql"


if [ -n $1 ] && [ "$1" == "--no-checks" ]; then
    return
fi

if [ ! -f $CURRENT_ENVIRONMENT_FILE ]; then
	echo "Environment file is missing: $CURRENT_ENVIRONMENT_FILE"
	exit 1;
fi

if [ -n $1 ]; then
	CURRENT_ENVIRONMENT=$1
fi
if [ -z $1 ]; then
	CURRENT_ENVIRONMENT=`cat $CURRENT_ENVIRONMENT_FILE`
fi

if [ -z $CURRENT_ENVIRONMENT ]; then
	echo "No current environment specified in $CURRENT_ENVIRONMENT_FILE"
fi

./$SCRIPTS/check.sh $CURRENT_ENVIRONMENT

CURRENT_ENVIRONMENT_PATH=$ENVIRONMENTS_DIR/$CURRENT_ENVIRONMENT

source ./$CURRENT_ENVIRONMENT_PATH/environment-config.sh
