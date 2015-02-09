#!/usr/bin/env bash

ENVR_PATH="${0%/*}"

ENVR_CONFIG='.envr_config'
ENVR_CONFIG_SAMPLE=$ENVR_PATH/$ENVR_CONFIG'.template'

if [ ! -f $ENVR_CONFIG ]; then
	while [[ ! $INSTALL_HERE =~ ^[YyNn]$ ]]
	do
	    read -p "Install envr in this folder $(pwd)? [y/n] " -n 1 -r INSTALL_HERE
	    echo ""
	done
	if [[ $INSTALL_HERE =~ ^[Nn]$ ]]
    then
        echo "Switch to the folder where you want do install envr and run envr install.sh again."
        exit 0
    fi

	eval echo "\"$(cat $ENVR_CONFIG_SAMPLE)\"" > $ENVR_CONFIG
	echo "✓ created $ENVR_CONFIG file"
else
	echo "WARNING: $ENVR_CONFIG file already exists. Delete it before you want to reinstall envr."
	exit 0
fi

cp $ENVR_PATH/envr.sh ./
echo "✓ copied envr script to current directory"

mkdir -p environments
echo "✓ created environments directory"

cp -r $ENVR_PATH/environments/www.sample-environment.com environments/
echo "✓ created environment: www.sample-environment.com"

touch .environment-dependent-files
echo "✓ created config: .environment-dependent-files"
