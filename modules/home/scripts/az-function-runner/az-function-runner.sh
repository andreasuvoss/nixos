#! /usr/bin/env sh

REQUIRED_DEPENDENCIES="gum az jq fzf"

for CLI in $REQUIRED_DEPENDENCIES; do
    if ! command -v $CLI &> /dev/null; then
        printf "'${CLI}' is required to be in your path to run this script\n"
        exit 1
    fi
done

gum spin --spinner dot --title "Checking if you are logged in" -- az account get-access-token

if [ $? -eq 0 ]; then 
    gum spin --spinner dot --title "You are already logged in" -- sleep 0.2
else 
    gum spin --spinner dot --title "You are not logged in, running 'az login'" -- sleep 0.2
    az login > /dev/null
fi

# Get the subscription name
SUBSCRIPTION=$(az account show | jq '.name' -r)

# Get all functionapps in the subscription
FUNCTIONAPPS=$(gum spin --spinner dot --title "Fetching functionapps in subscription ${SUBSCRIPTION}..." -- az functionapp list)
FUNCTIONAPP_NAME=$(echo $FUNCTIONAPPS | jq '.[].name' -r | fzf)

# Pull details for the selected functionapp
FUNCTIONAPP_JSON=$(echo $FUNCTIONAPPS | jq --arg FUNCTIONAPP_NAME "$FUNCTIONAPP_NAME" '.[] | select(.name==$FUNCTIONAPP_NAME)')
FUNCTIONAPP_RG=$(echo $FUNCTIONAPP_JSON | jq '.resourceGroup' -r)
FUNCTIONAPP_HOST_NAME=$(echo $FUNCTIONAPP_JSON | jq '.defaultHostName' -r)
FUNCTION_ACCESS_RESTRICTIONS=$(gum spin --spinner dot --title "Getting access restrictions for ${FUNCTIONAPP_NAME}..." -- az functionapp config access-restriction show -g $FUNCTIONAPP_RG -n $FUNCTIONAPP_NAME)

# Check network access restrictions for the function
MY_IP="$(curl 'https://myip.dk' -s)"
MY_IP_SEARCH="${MY_IP}/32"
EXISTING_ACCESS_RESTRICTION=$(echo $FUNCTION_ACCESS_RESTRICTIONS | jq --arg IP $MY_IP_SEARCH '.ipSecurityRestrictions.[] | select(.ip_address==$IP)')

# Ask to add IP to allow list if it is not there already
if [[ -z "$EXISTING_ACCESS_RESTRICTION" ]]; then 
    ADD_RESTRICTION=$(gum confirm "Your IP ($MY_IP) is blocked would you like to allow it?" && gum spin --spinner dot --title "Allowing IP ${MY_IP} access to function ${FUNCTIONAPP_NAME}" -- az functionapp config access-restriction add --ip-address $MY_IP -p 300 --resource-group $FUNCTIONAPP_RG --name $FUNCTIONAPP_NAME)
fi

# Fetch functions within the function app
FUNCTIONS=$(gum spin --spinner dot --title "Fetching functions for functionapp ${FUNCTIONAPP_NAME}..." -- az functionapp function list -g $FUNCTIONAPP_RG -n $FUNCTIONAPP_NAME)
FUNCTION_NAME=$(echo $FUNCTIONS | jq '.[].config.name' -r | fzf)

# Get the master key for executing the selected function
FUNCTION_MASTER_KEY=$(gum spin --spinner dot --title "Getting function master key for ${FUNCTIONAPP_NAME}..." -- az functionapp keys list -g $FUNCTIONAPP_RG -n $FUNCTIONAPP_NAME | jq '.masterKey' -r)

# Execute the selected function
COMMAND=$(gum spin --spinner dot --title "Executing function ${FUNCTION_NAME} on ${FUNCTIONAPP_NAME}" -- curl "https://${FUNCTIONAPP_HOST_NAME}/admin/functions/${FUNCTION_NAME}" -H 'Content-Type: application/json' -H "x-functions-key: ${FUNCTION_MASTER_KEY}" -d '{}' -X 'POST' -s)

if [[ -z "$COMMAND" ]]; then 
    echo "Successfully executed the function ${FUNCTION_NAME} on ${FUNCTIONAPP_NAME}"
else
    echo $COMMAND
    echo "An error occurred when attempting to run the function"
fi
