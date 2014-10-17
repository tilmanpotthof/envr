#!/usr/bin/env bash

ENVR_CONFIG='.envr_config'

if [ -f $ENVR_CONFIG ]; then
	source $ENVR_CONFIG
else
	echo "WARNING: Found no $ENVR_CONFIG file. Please use the install.sh script."
	exit 0
fi

./$ENVR_PATH/scripts/envr.sh $0 $1 $2
