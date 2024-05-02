#!/bin/bash
sudo apt update && sudo apt upgrade -y

sudo apt install jq -y

# --------------------- #
#Variables with prompts
# --------------------- #

#Username
read -p "Please enter the username: " username

#Password
read -sp "Password: " password

#Proxmox address
read -p "Proxmox IP address: " proxmox


# ---------------------- #
# Authentication tokens
# ---------------------- #

#cookie
curl --silent --insecure --data "username=$username@pam&password=$password" $proxmox:8006/api2/json/access/ticket | jq --raw-output '.data.ticket' | sed 's/^/PVEAuthCookie=/' > cookie

# csrftoken
curl --silent --insecure --data "username=$username@pam&password=$password" $proxmox:8006/api2/json/access/ticket | jq --raw-output '.data.CSRFPreventionToken' | sed 's/^/CSRFPreventionToken:/' > csrftoken


curl --silent --insecure --cookie "$(<cookie)" --header "$(<csrftoken)" $proxmox:8006/api2/nodes | jq .