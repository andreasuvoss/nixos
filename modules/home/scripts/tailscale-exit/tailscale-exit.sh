#! /usr/bin/env bash

TAILSCALE_STATUS=$(tailscale status --json)
EXIT_NODE_HOSTS=$(echo $TAILSCALE_STATUS | jq '.Peer | to_entries | .[].value | select(.ExitNodeOption==true) | .HostName' -r)
EXIT_NODE_CHOSEN=$(echo -e "$EXIT_NODE_HOSTS\nDISCONNECT" | gum choose --height 20 --header "Those the exit node")

if [ $EXIT_NODE_CHOSEN = "DISCONNECT" ]; then
    tailscale set --exit-node "" --exit-node-allow-lan-access=true
else
    tailscale set --exit-node "$EXIT_NODE_CHOSEN" --exit-node-allow-lan-access=true
fi
