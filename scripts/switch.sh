#!/usr/bin/env bash

NEW_ENVIRONMENT=$1

if [ -z $NEW_ENVIRONMENT ]; then
	echo "Usage: $0 <enviroment>"
	exit 1
fi

source ./$SCRIPTS/prepare-environment.sh --no-checks

source ./$SCRIPTS/check.sh $NEW_ENVIRONMENT


echo "Switch to environment: $1"

touch $CURRENT_ENVIRONMENT_FILE
echo $NEW_ENVIRONMENT > $CURRENT_ENVIRONMENT_FILE

source ./$SCRIPTS/prepare-environment.sh

if [ ! -f $ENVIRONMENT_DEPENDENT_FILES ]; then
	echo "WARNING: No file $ENVIRONMENT_DEPENDENT_FILES found. No files will be copied."
else
	for FILEPATH in `cat $ENVIRONMENT_DEPENDENT_FILES`
	do
		if [ -f $CURRENT_ENVIRONMENT_PATH/$FILEPATH ]; then
			echo $FILEPATH
			cp $CURRENT_ENVIRONMENT_PATH/$FILEPATH $FILEPATH
		else
			echo "Environment dependent file '$FILEPATH' does not exist for $CURRENT_ENVIRONMENT"
	    fi
	done
fi