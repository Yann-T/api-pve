#!/bin/bash
echo "If you don't installed jq, you should. Otherwise this script won't work."

# --------------------- #
#Variables with prompts
# --------------------- #

#Username
read -p "Please enter the username: " username
echo

#Password
read -sp "Password: " password
echo

#Proxmox address
read -p "Proxmox IP address: " proxmox
echo

# ---------------------- #
# Authentication tokens
# ---------------------- #

#cookie
curl --silent --insecure --data "username=$username@pam&password=$password" https://$proxmox:8006/api2/json/access/ticket | jq --raw-output '.data.ticket' | sed 's/^/PVEAuthCookie=/' > cookie

# csrftoken
curl --silent --insecure --data "username=$username@pam&password=$password" https://$proxmox:8006/api2/json/access/ticket | jq --raw-output '.data.CSRFPreventionToken' | sed 's/^/CSRFPreventionToken:/' > csrftoken


curl --silent --insecure --cookie "cookie" --header "csrftoken" https://$proxmox:8006/api2/nodes | jq .