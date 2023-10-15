#!/bin/bash
URL="https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
TMP_FILE=$(mktemp)
DNSMASQ_FILE="/etc/dnsmasq.d/blocklist.conf"

curl -s $URL -o $TMP_FILE

if [ $? -ne 0 ]; then
  echo "Error: Failed to fetch the hosts file."
  exit 1
fi

awk 'BEGIN { start=0 } 
     /# Start StevenBlack/ { start=1 } 
     start == 1 && $1 == "0.0.0.0" { print "address=/" $2 "/#" }' $TMP_FILE > $DNSMASQ_FILE

rm $TMP_FILE

if [ -s $DNSMASQ_FILE ]; then
  echo "Successfully created $DNSMASQ_FILE."
else
  echo "Error: Failed to create $DNSMASQ_FILE."
  exit 1
fi

/bin/systemctl restart dnsmasq

