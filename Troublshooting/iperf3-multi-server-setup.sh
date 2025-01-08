#!/bin/bash

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root. Use sudo to run it."
  exit 1
fi

# Define ports
ports=(55001 55002 55003 55004)

# Function to install packages
install_packages() {
  echo "Installing required packages..."
  #apt update -y
  apt install -y iperf3 screen
}

# Function to set up iperf3 servers in screen
setup_iperf3_servers() {
  echo "Setting up iperf3 servers in screen sessions..."
  for port in "${ports[@]}"; do
    screen -dmS iperf_server_$port iperf3 -s -p $port
    echo "Started iperf3 server on port $port in screen session iperf_server_$port"
  done
}

# Function to display client commands
display_client_commands() {
  echo "Client commands to connect to these servers:"
  for port in "${ports[@]}"; do
    echo "iperf3 -c <server_ip> -p $port"
  done
}

# Main script execution
install_packages
setup_iperf3_servers
display_client_commands

echo "All iperf3 servers are up and running!"
