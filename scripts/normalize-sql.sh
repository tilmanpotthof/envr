#!/bin/bash

source ./$SCRIPTS/prepare-environment.sh

DB_VARIABLES=".db_variables"
TMP_PHP_FILE="___.php"


if [ ! -f $DB_VARIABLES ]; then
	echo "WARNING: No file $DB_VARIABLES found. No config variables will be replaced in the dump."
	exit 0
fi

for VARIABLE_NAME in $(cat $DB_VARIABLES)
do
	VALUE=$(eval "echo \$${VARIABLE_NAME}")
	PLACEHOLDER="{{{$VARIABLE_NAME}}}"

	echo "prepare sql from $CURRENT_ENVIRONMENT for $VARIABLE_NAME with '$VALUE'"
	perl -pi -e 's!'$VALUE'!'$PLACEHOLDER'!g' $LATEST_SQL
done

echo "✓ done preparing all environments"

PHP_CLI=$(php --version | grep "(cli)" | wc -l)

function replace {
    PHP_COMMAND='print serialize("'$1'");'

    if [ $PHP_CLI == 1 ]; then
        php -r "$PHP_COMMAND"
    else
        echo "<?php "$PHP_COMMAND > $TMP_PHP_FILE
        php -f $TMP_PHP_FILE
    fi
}

for ENVIRONMENT in `ls $ENVIRONMENTS_DIR`
do
	source ./$SCRIPTS/prepare-environment.sh $ENVIRONMENT
	echo "create sql for $ENVIRONMENT with $WORDPRESS_URL"
	ENVIRONMENT_SQL=$CURRENT_ENVIRONMENT_PATH/$LATEST_SQL
	mkdir -p $(dirname $ENVIRONMENT_SQL)
	cp $LATEST_SQL $ENVIRONMENT_SQL

	for VARIABLE_NAME in $(cat $DB_VARIABLES)
	do
		VALUE=$(eval "echo \$${VARIABLE_NAME}")
		PLACEHOLDER="{{{$VARIABLE_NAME}}}"

		## step to replace urls that are stores in non-atomic fields with phps serialize function
		for MATCH in `perl -wnE 'print $_ =~ /(s:[0-9]+:\\\"h?t?t?p?:?\/?\/?'$PLACEHOLDER'.*?\";)/g' $ENVIRONMENT_SQL | perl -pne 's/;s:/;\ns:/g'`
		do
			URL=`echo $MATCH | perl -ne '$_ =~ /\\\"(.*)\\\"/g;print $1' | perl -pne 's!'$PLACEHOLDER'!'$VALUE'!g'`
			REPLACEMENT=$(replace $URL)

			# escape backslash in MATCH
			ESCAPED_MATCH=`echo $MATCH | perl -pne 's!\\\\!\\\\\\\\!g' | perl -pne 's!\?!\\\?!g'`

			perl -pi -e 's!'$ESCAPED_MATCH'!'$REPLACEMENT'!g' $ENVIRONMENT_SQL
		done

		perl -pi -e 's!'$PLACEHOLDER'!'$VALUE'!g' $ENVIRONMENT_SQL

	done
done

rm -f $TMP_PHP_FILE

echo "✓ done creating sql for all environments"

