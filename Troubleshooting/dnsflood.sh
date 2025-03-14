#!/bin/bash

# Target domain
DOMAIN="contoso.com"

# Nameservers
NAMESERVERS=(
  "ns1.contoso.com"
  "ns2.contoso.com"
  "ns3.contoso.com"
  "ns4.contoso.com"
)

# Store process IDs
PIDS=()

# Function to perform dig query in a loop
query_dns() {
  local NS=$1
  while true; do
    dig @$NS $DOMAIN A +short
    sleep 2  # Adjust the sleep interval as needed
  done
}

# Start queries in parallel and store their PIDs
for NS in "${NAMESERVERS[@]}"; do
  query_dns "$NS" &
  PIDS+=($!)
done

# Trap SIGINT (Ctrl+C) to kill background processes
trap 'echo "Stopping queries..."; kill ${PIDS[@]}; exit' SIGINT

# Keep script running until manually stopped
wait
