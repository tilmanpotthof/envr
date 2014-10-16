#!/usr/bin/env bash

source ./$SCRIPTS/prepare-environment.sh $1

mkdir -p sql

mysqldump $DB_AUTH --single-transaction --extended-insert=FALSE $DB_NAME > sql/latest.sql

./$SCRIPTS/normalize-sql.sh
