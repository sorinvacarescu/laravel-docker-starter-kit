#!/bin/bash

# Define the file and the text to replace
FILE="docker-compose.yml"
SEARCH_TEXT="app_name"
REPLACE_TEXT=${PWD##*/}

sed -i "s/$SEARCH_TEXT/$REPLACE_TEXT/g" "$FILE"


echo "Replaced 'app_name' with '${REPLACE_TEXT}' in '${FILE}'"
