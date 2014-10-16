#!/usr/bin/env bash

source $SCRIPTS/prepare-environment.sh --no-checks

ENVIRONMENT_TO_CHECK=$1

if [ -z $ENVIRONMENT_TO_CHECK ]; then
	echo "Usage: $0 <enviroment>"
	exit 1
fi

ENVIRONMENT_TO_CHECK_PATH=$ENVIRONMENTS_DIR/$ENVIRONMENT_TO_CHECK

if [ ! -d $ENVIRONMENT_TO_CHECK_PATH ]; then
	echo "Enviroment '${ENVIRONMENT_TO_CHECK}' does not exist in directory '${ENVIRONMENT_TO_CHECK_PATH}'"
	echo "Valid environments:"
	echo "`ls $ENVIRONMENTS_DIR`"
	exit 1
fi
