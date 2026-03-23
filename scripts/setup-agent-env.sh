#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <path_to_thunder_distribution.zip>"
  exit 1
fi

ZIP_FILE="$1"

if [ ! -f "$ZIP_FILE" ]; then
  echo "Error: File $ZIP_FILE not found"
  exit 1
fi

echo "Preparing ../tmp directory..."
mkdir -p ../.tmp

echo "Copying distribution to ../tmp..."
cp "$ZIP_FILE" ../.tmp/

cd ../.tmp || exit 1
ZIP_BASENAME=$(basename "$ZIP_FILE")

echo "Unzipping $ZIP_BASENAME..."
unzip -q -o "$ZIP_BASENAME"

# Determine THUNDER_HOME based on the zip file name
THUNDER_HOME=$(basename "$ZIP_BASENAME" .zip)

if [ ! -d "$THUNDER_HOME" ]; then
  # Fallback: find any extracted folder starting with thunder-
  THUNDER_HOME=$(find . -maxdepth 1 -type d -name 'thunder-*' | head -n 1)
fi

if [ ! -d "$THUNDER_HOME" ]; then
  echo "Error: Could not locate extracted THUNDER_HOME directory."
  exit 1
fi

echo "Changing directory to THUNDER_HOME: $THUNDER_HOME"
cd "$THUNDER_HOME" || exit 1

echo "Updating deployment.yaml..."
DEPLOY_YAML="repository/conf/deployment.yaml"
if [ -f "$DEPLOY_YAML" ]; then
    # Check if 8090 is already in the CORS block to prevent duplicates
    HAS_CORS=$(awk '/^[^ ]/{b=$1} b=="cors:" && /https:\/\/localhost:8090/{print 1}' "$DEPLOY_YAML")
    
    awk -v skip_cors="$HAS_CORS" '
    /^[^ ]/ { block=$1 }
    
    # Strip existing JWT issuer to prevent duplicates
    block=="jwt:" && /issuer:/ { next }
    
    { print }

    # Safely inject CORS origin if missing
    block=="cors:" && /allowed_origins:/ && !skip_cors && !cors_done {
        print "    - \"https://localhost:8090\""
        cors_done=1
    }

    # Safely inject JWT issuer
    block=="jwt:" && /preferred_key_id:/ && !jwt_done {
        print "    issuer: \"https://localhost:8091\""
        jwt_done=1
    }
    ' "$DEPLOY_YAML" > "${DEPLOY_YAML}.tmp" && mv "${DEPLOY_YAML}.tmp" "$DEPLOY_YAML"
else
    echo "Warning: $DEPLOY_YAML not found."
fi

echo "Updating apps/console/config.js..."
if [ -f "apps/console/config.js" ]; then
    perl -pi -e 's/port:\s*8090/port: 8091/g' "apps/console/config.js"
else
    echo "Warning: apps/console/config.js not found."
fi

echo "Updating apps/gate/config.js..."
if [ -f "apps/gate/config.js" ]; then
    perl -pi -e 's/port:\s*8090/port: 8091/g' "apps/gate/config.js"
else
    echo "Warning: apps/gate/config.js not found."
fi

echo "Running setup.sh..."
if [ -f "setup.sh" ]; then
    sh setup.sh
else
    echo "Warning: setup.sh not found."
fi

echo "Running start.sh..."
if [ -f "start.sh" ]; then
    sh start.sh
else
    echo "Warning: start.sh not found."
fi
