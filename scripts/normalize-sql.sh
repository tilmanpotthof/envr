#!/bin/bash

source ./$SCRIPTS/prepare-environment.sh

DB_VARIABLES=".db_variables"


for VARIABLE_NAME in $(cat $DB_VARIABLES)
do
	VALUE=$(eval "echo \$${VARIABLE_NAME}")
	PLACEHOLDER="{{{$VARIABLE_NAME}}}"

	echo "prepare sql from $CURRENT_ENVIRONMENT for $VARIABLE_NAME with '$VALUE'"
	perl -pi -e 's!'$VALUE'!'$PLACEHOLDER'!g' $LATEST_SQL
done

echo "✓ done preparing all environments"

for ENVIRONMENT in `ls $ENVIRONMENTS_DIR`
do
	source ./$SCRIPTS/prepare-environment.sh $ENVIRONMENT
	echo "create sql for $ENVIRONMENT with $WORDPRESS_URL"
	cp $LATEST_SQL $CURRENT_ENVIRONMENT_PATH/$LATEST_SQL

	for VARIABLE_NAME in $(cat $DB_VARIABLES)
	do
		VALUE=$(eval "echo \$${VARIABLE_NAME}")
		PLACEHOLDER="{{{$VARIABLE_NAME}}}"

		## step to replace urls that are stores in non-atomic fields with phps serialize function
		for MATCH in `perl -wnE 'print $_ =~ /s:[0-9]+:\\\"http:\/\/'$PLACEHOLDER'.*?\";/g' $CURRENT_ENVIRONMENT_PATH/$LATEST_SQL | perl -pne 's/;s:/;\ns:/g'`
		do
			URL=`echo $MATCH | perl -ne '$_ =~ /\\\"(.*)\\\"/g;print $1' | perl -pne 's/'$PLACEHOLDER'/'$VALUE'/g'`
			LENGTH=${#URL}
			REPLACEMENT='s:'$LENGTH':\\\"'$URL'\\\";'

			# escape backslash in MATCH
			ESCAPED_MATCH=`echo $MATCH | perl -pne 's!\\\\!\\\\\\\\!g'`

			perl -pi -e 's!'$ESCAPED_MATCH'!'$REPLACEMENT'!g' $CURRENT_ENVIRONMENT_PATH/$LATEST_SQL
		done

		perl -pi -e 's!'$PLACEHOLDER'!'$VALUE'!g' $CURRENT_ENVIRONMENT_PATH/$LATEST_SQL

	done
done

echo "✓ done creating sql for all environments"

