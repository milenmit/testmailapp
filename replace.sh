#!/bin/bash

# Load the .env file
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Check if DOMAIN and API_KEY are set
if [ -z "$DOMAIN" ]; then
    echo "DOMAIN is not set in the .env file. Exiting."
    exit 1
fi

if [ -z "$API_KEY" ]; then
    echo "API_KEY is not set in the .env file. Exiting."
    exit 1
fi

# Files to update
FILES=(
    "./postfix/conf/main.cf"
    "./postfix/conf/transport"
    "./postfix/conf/virtual"
    "./flask_app/templates/index.html"
)

# Replace {{domain}} and {{API_KEY}} with the actual values in each file
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        sed -i "s/{{domain}}/$DOMAIN/g" "$file"
        sed -i "s/{{API_KEY}}/$API_KEY/g" "$file"
        echo "Updated $file"
    else
        echo "File $file does not exist. Skipping."
    fi
done
