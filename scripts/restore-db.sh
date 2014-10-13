#!/usr/bin/env bash

source ./$SCRIPTS/prepare-environment.sh

mysql $DB_AUTH $DB_NAME < $CURRENT_ENVIRONMENT_PATH/sql/latest.sql
