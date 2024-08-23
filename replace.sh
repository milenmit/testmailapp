#!/bin/bash

# Load the .env file
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Check if DOMAIN is set
if [ -z "$DOMAIN" ]; then
    echo "DOMAIN is not set in the .env file. Exiting."
    exit 1
fi

# Files to update
FILES=(
    "./postfix/conf/main.cf"
    "./postfix/conf/transport"
    "./postfix/conf/virtual"
    "./flask_app/templates/index.html"
)

# Replace {{domain}} with the actual domain in each file
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        sed -i "s/{{domain}}/$DOMAIN/g" "$file"
        echo "Updated $file"
    else
        echo "File $file does not exist. Skipping."
    fi
done