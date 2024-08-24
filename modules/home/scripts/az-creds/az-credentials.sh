#! /usr/bin/env sh

REQUIRED_DEPENDENCIES="gum az jq"
APP_PREFIX="bc-"

for CLI in $REQUIRED_DEPENDENCIES; do
    if ! command -v $CLI &> /dev/null; then
        printf "'${CLI}' is required to be in your path to run this script\n"
        exit 1
    fi
done

gum spin --spinner dot --title "Checking if you are logged in" -- az account get-access-token

if [ $? -eq 0 ]; then 
    gum spin --spinner dot --title "You are already logged in" -- sleep 1
    sleep 0.5
else 
    gum spin --spinner dot --title "You are not logged in, running 'az login'" -- sleep 1
    sleep 0.5
    az login > /dev/null
fi

# The following command gets a maximum of 100 applications the '--all' flag can be added to the 'az' command if you 
# really want to list everything
if ! command -v fzf &> /dev/null; then
    APP_DISPLAY_NAME=$(gum spin --spinner dot --title "Fetching BCs..." -- az ad app list --filter "startswith(displayName,'$APP_PREFIX')" | jq '.[].displayName' -r | gum choose --height 20 --header "Choose the application")
else
    APP_DISPLAY_NAME=$(gum spin --spinner dot --title "Fetching BCs..." -- az ad app list --filter "startswith(displayName,'$APP_PREFIX')" | jq '.[].displayName' -r | fzf)
fi

APP_ID=$(gum spin --spinner dot --title "Getting the application id for ${APP_DISPLAY_NAME}" -- az ad app list --display-name $APP_DISPLAY_NAME | jq '.[0].appId' -r)
RESPONSE=$(gum spin --spinner dot --title "Getting access token for ${APP_DISPLAY_NAME}" -- az account get-access-token --resource $APP_ID)
TOKEN=$(echo $RESPONSE | jq .accessToken -r)

if [[ -z "$TOKEN" ]]; then echo "Could not get token for app '$APP_DISPLAY_NAME' with resource id '$APP_ID'"; exit 1; fi

if ! command -v wl-copy &> /dev/null; then
    echo 'Here is your token: '
    echo $TOKEN
else
    echo 'The token is copied to your clipboard'
    echo $TOKEN | wl-copy --trim-newline
fi
