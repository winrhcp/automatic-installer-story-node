#!/bin/bash

# Function to display the numbered menu
show_menu() {
  echo "===================================="
  echo "       Story Node Management        "
  echo "===================================="
  echo "1) Install necessary dependencies"
  echo "2) Download and install Story-Geth binary"
  echo "3) Download and install Story binary"
  echo "4) Initialize Story Iliad node"
  echo "5) Create systemd services for Story and Story-Geth"
  echo "6) Start Story and Story-Geth services"
  echo "7) View Story-Geth logs"
  echo "8) View Story logs"
  echo "9) Check sync status"
  echo "10) Check block sync progress"
  echo "11) Export validator keys"
  echo "12) Create validator with staked amount"
  echo "13) Exit"
}

# Function to process the user's choice
read_choice() {
  local choice
  read -p "Enter your choice [1-13]: " choice
  case $choice in
    1)
      make install-deps
      ;;
    2)
      make install-story-geth
      ;;
    3)
      make install-story
      ;;
    4)
      make init-node
      ;;
    5)
      make create-story-geth-service
      make create-story-service
      ;;
    6)
      make start-services
      ;;
    7)
      make logs-story-geth
      ;;
    8)
      make logs-story
      ;;
    9)
      make check-sync-status
      ;;
    10)
      make check-block-sync
      ;;
    11)
      make export-validator
      ;;
    12)
      make create-validator
      ;;
    13)
      echo "Exiting..."
      exit 0
      ;;
    *)
      echo "Invalid choice! Please choose a number between 1 and 13."
      ;;
  esac
}

# Main loop
while true; do
  show_menu
  read_choice
  echo ""  # Empty line for better readability
done
