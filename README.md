# envr

Work in progress...

## Configuration Files

You can configure environment specific variables in `environments/<my-environment-name>/environment-config.sh`. For example `environments/localhost/environment-config.sh`.

    #!/bin/bash

    WORDPRESS_URL="localhost\/my-wordpress"
    PIWIK_URL="localhost\/my-piwik"
    DB_AUTH="-u root -S /Applications/XAMPP/xamppfiles/var/mysql/mysql.sock"
    DB_NAME='my_wordpress_db'
    
All files that are dependent from your environment have to be defined in `.environment-dependent-files`. Again a wordpress and piwik example.

    wordpress/wp-config.php
    wordpress/.htaccess
    piwik/config/config.ini.php

Envr automatically replaces variables in you database dump if you want to. You can define these variables in `.db_variables` and then they are replaces by the values defined in the `environment-config.sh`.

    WORDPRESS_URL
    PIWIK_URL

## Commands

    usage: ./envr.sh <command> [<args>]

    Available commands are:
      switch          Switch the environment
      save            Save current environment (dependent files)
      check           Check if an environment exists
      dump-db         Dump the database for the current environment
      restore-db      Restore the latest dump the the database
      normalize-sql   Normalize the last sql dump and prepare it for each environments
      version         Display the version
 