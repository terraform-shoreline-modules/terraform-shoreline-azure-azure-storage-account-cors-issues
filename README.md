
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Azure Storage Account CORS Issues

This incident type typically refers to an issue with Cross-Origin Resource Sharing (CORS) configuration in an Azure Storage account. CORS issues can cause errors or prevent certain types of requests from being processed by the server. This can lead to disruptions in service or data access for users or applications relying on the Azure Storage account.

### Parameters

```shell
export STORAGE_ACCOUNT_NAME="PLACEHOLDER"
export STORAGE_ACCOUNT_KEY="PLACEHOLDER"
export RESOURCE_GROUP_NAME="PLACEHOLDER"
export ALLOWED_ORIGINS="PLACEHOLDER"
export METHODS="PLACEHOLDER"
```

## Debug

### List the storage accounts in the subscription

```shell
az storage account list --resource-group ${RESOURCE_GROUP_NAME}
```

### Show the details of a specific storage account

```shell
az storage account show --name ${STORAGE_ACCOUNT_NAME} --resource-group ${RESOURCE_GROUP_NAME}
```

### Check the CORS rules for a storage account

```shell
az storage cors list --account-name ${STORAGE_ACCOUNT_NAME} --account-key ${STORAGE_ACCOUNT_KEY}
```

## Repair

### Check and update the Azure storage account configuration settings to ensure that CORS is correctly configured.

```shell
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
```