#!/bin/bash

# Function to display the help menu
show_help() {
  echo "Usage: $0 [option]"
  echo ""
  echo "Options:"
  echo "  install-deps         Install necessary dependencies"
  echo "  install-story-geth   Download and install Story-Geth binary"
  echo "  install-story        Download and install Story binary"
  echo "  init-node            Initialize Story Iliad node"
  echo "  create-services      Create and reload systemd services for Story and Story-Geth"
  echo "  start-services       Start Story and Story-Geth services"
  echo "  check-logs-geth      View Story-Geth logs"
  echo "  check-logs-story     View Story logs"
  echo "  check-sync-status    Check the sync status of the node"
  echo "  check-block-sync     Check remaining blocks to sync"
  echo "  export-validator     Export validator public and private keys"
  echo "  create-validator     Create validator with staked amount"
  echo "  help                 Display this help menu"
}

# Check if the Makefile exists
if [ ! -f "Makefile" ]; then
  echo "Makefile not found! Ensure you have a valid Makefile in the current directory."
  exit 1
fi

# Command-line argument processing
case "$1" in
  install-deps)
    make install-deps
    ;;
  install-story-geth)
    make install-story-geth
    ;;
  install-story)
    make install-story
    ;;
  init-node)
    make init-node
    ;;
  create-services)
    make create-story-geth-service
    make create-story-service
    ;;
  start-services)
    make start-services
    ;;
  check-logs-geth)
    make logs-story-geth
    ;;
  check-logs-story)
    make logs-story
    ;;
  check-sync-status)
    make check-sync-status
    ;;
  check-block-sync)
    make check-block-sync
    ;;
  export-validator)
    make export-validator
    ;;
  create-validator)
    make create-validator
    ;;
  help | *)
    show_help
    ;;
esac
