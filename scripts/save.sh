#!/usr/bin/env bash

source ./$SCRIPTS/prepare-environment.sh


for FILEPATH in `cat $ENVIRONMENT_DEPENDENT_FILES`
do
	if [ -f $FILEPATH ]; then
		FILE_DIR=${FILEPATH%/*}
		if [ ! -d $CURRENT_ENVIRONMENT_PATH/$FILE_DIR ]; then
			mkdir -p $CURRENT_ENVIRONMENT_PATH/$FILE_DIR 
			echo "created directory $CURRENT_ENVIRONMENT_PATH/$FILE_DIR"
		fi
		cp $FILEPATH $CURRENT_ENVIRONMENT_PATH/$FILEPATH
		echo "✓ $FILEPATH - copied successfully to environment '$CURRENT_ENVIRONMENT'"
	else
		echo "Environment dependent file '$FILEPATH' does not exist."
    fi
done