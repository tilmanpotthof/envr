#!/usr/bin/env bash


BASE_CMD=$1
COMMAND=$2

export ENVR_VERSION=0.1.0
export SCRIPTS=$ENVR_PATH/'scripts/'
export DOCS=$SCRIPTS'/docs'

EXPECTED_SCRIPT_PATH=$SCRIPTS$COMMAND.sh

if [ -z $1 ] || [ ! -f $EXPECTED_SCRIPT_PATH ]; then
	eval echo "\"$(cat $DOCS/general.txt)\""
    exit 1
fi

./$EXPECTED_SCRIPT_PATH $3
