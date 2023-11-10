#!/bin/bash

# Set the values for the following parameters
storage_account_name=${STORAGE_ACCOUNT_NAME}
storage_account_key=${STORAGE_ACCOUNT_KEY}
allowed_origins=${ALLOWED_ORIGINS}
methods=${METHODS}

# Check if CORS is enabled for the storage account
cors_enabled=$(az storage cors list--account-name $storage_account_name --account-key $storage_account_key -o tsv)

if [ -z "$cors_enabled" ]
then
    # If CORS is not enabled, enable it and set allowed origins
    az storage cors add --methods $methods --origins $allowed_origins --services bfqt
    echo "CORS has been enabled and allowed origins have been set for the storage account."
else
   # If CORS is enabled, clear existing CORS rules and then add new CORS rules
    az storage cors clear --account-name $storage_account_name --services bfqt
    az storage cors add --methods $methods --origins $allowed_origins --services bfqt
    echo "Existing CORS rules have been cleared, and new allowed origins have been set for the storage account."
fi