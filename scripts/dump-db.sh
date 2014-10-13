#!/usr/bin/env bash

source ./$SCRIPTS/prepare-environment.sh $1

mysqldump $DB_AUTH --extended-insert=FALSE $DB_NAME > sql/latest.sql

./$SCRIPTS/normalize-sql.sh
