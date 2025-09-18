#!/bin/bash

# Load Config
config_path="$(dirname "$(dirname "$(dirname "$(realpath "$0")")")")/config.sh"

if [ ! -f "$config_path" ]; then
    echo "Config file not found: $config_path"
    exit 1
fi

echo "Loading config.sh from $config_path"
source "$config_path"

echo "Activating Owner Mode"
echo "Owner Auth Path: $owner_auth_path"

# Remove existing remotes if they exist
echo "Removing existing remotes..."
if dvc remote list | grep -q "^storage"; then
    dvc remote remove storage
fi

if dvc remote list | grep -q "^uploads"; then
    dvc remote remove uploads
fi

# Add remotes with new configuration
if [ -z "$database_ID" ]; then
    echo "❌ Error: database_ID is empty"
    exit 1
fi

echo "Database ID: $database_ID"
dvc remote add -d storage gdrive://${database_ID}
dvc remote modify storage gdrive_service_account_json_file_path "$user_auth_path"
dvc remote modify storage gdrive_use_service_account true



echo "Adding uploads remote..."
if [ -z "$user_upload_ID" ]; then
    echo "❌ Error: user_upload_ID is empty"
    exit 1
fi
echo "User Upload ID: $user_upload_ID"
dvc remote add uploads gdrive://${user_upload_ID}
dvc remote modify uploads gdrive_service_account_json_file_path "$user_auth_path"
dvc remote modify uploads gdrive_use_service_account true

# Verify configuration
echo "Verifying remote configuration..."
if dvc remote list | grep -q "^storage" && dvc remote list | grep -q "^uploads"; then
    echo "✅ Remote configuration successful"
else
    echo "❌ Error: Remote configuration failed"
    exit 1
fi

echo "User Mode Activated ✅"

echo "Running DVC steps"
dvc pull
dvc config core.autostage true
echo "DVC steps completed ✅ "
