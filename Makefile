# Define variables
BIN_DIR=$(HOME)/go/bin
STORY_GETH_VERSION=0.9.3
STORY_VERSION=0.10.1
GETH_TAR=geth-linux-amd64-$(STORY_GETH_VERSION)-b224fdf.tar.gz
STORY_TAR=story-linux-amd64-$(STORY_VERSION)-57567e5.tar.gz
MONIKER="Your_moniker_name"
GETH_URL=https://story-geth-binaries.s3.us-west-1.amazonaws.com/geth-public/$(GETH_TAR)
STORY_URL=https://story-geth-binaries.s3.us-west-1.amazonaws.com/story-public/$(STORY_TAR)

# Install dependencies
install-deps:
	sudo apt update && sudo apt-get install -y curl git make jq build-essential gcc unzip wget lz4 aria2

# Download and install Story-Geth binary
install-story-geth:
	wget $(GETH_URL) && tar -xzvf $(GETH_TAR)
	mkdir -p $(BIN_DIR)
	sudo cp geth-linux-amd64-$(STORY_GETH_VERSION)-b224fdf/geth $(BIN_DIR)/story-geth
	source ~/.bash_profile
	story-geth version

# Download and install Story binary
install-story:
	wget $(STORY_URL) && tar -xzvf $(STORY_TAR)
	cp $(HOME)/story-linux-amd64-$(STORY_VERSION)-57567e5/story $(BIN_DIR)
	source ~/.bash_profile
	story version

# Initialize Story Iliad node
init-node:
	story init --network iliad --moniker $(MONIKER)

# Create systemd service for Story-Geth
create-story-geth-service:
	sudo tee /etc/systemd/system/story-geth.service > /dev/null <<EOF
	[Unit]
	Description=Story Geth Client
	After=network.target

	[Service]
	User=root
	ExecStart=$(BIN_DIR)/story-geth --iliad --syncmode full
	Restart=on-failure
	RestartSec=3
	LimitNOFILE=4096

	[Install]
	WantedBy=multi-user.target
	EOF
	sudo systemctl daemon-reload && sudo systemctl enable story-geth

# Create systemd service for Story
create-story-service:
	sudo tee /etc/systemd/system/story.service > /dev/null <<EOF
	[Unit]
	Description=Story Consensus Client
	After=network.target

	[Service]
	User=root
	ExecStart=$(BIN_DIR)/story run
	Restart=on-failure
	RestartSec=3
	LimitNOFILE=4096

	[Install]
	WantedBy=multi-user.target
	EOF
	sudo systemctl daemon-reload && sudo systemctl enable story

# Start services and check status
start-services:
	sudo systemctl start story-geth && sudo systemctl status story-geth
	sudo systemctl start story && sudo systemctl status story

# Check Story-Geth logs
logs-story-geth:
	sudo journalctl -u story-geth -f -o cat

# Check Story logs
logs-story:
	sudo journalctl -u story -f -o cat

# Check node sync status
check-sync-status:
	curl localhost:26657/status | jq

# Check block sync progress
check-block-sync:
	@while true; do \
		local_height=$$(curl -s localhost:26657/status | jq -r '.result.sync_info.latest_block_height'); \
		network_height=$$(curl -s https://rpc-story.josephtran.xyz/status | jq -r '.result.sync_info.latest_block_height'); \
		blocks_left=$$((network_height - local_height)); \
		echo -e "\033[1;38mYour node height:\033[0m \033[1;34m$$local_height\033[0m | \033[1;35mNetwork height:\033[0m \033[1;36m$$network_height\033[0m | \033[1;29mBlocks left:\033[0m \033[1;31m$$blocks_left\033[0m"; \
		sleep 5; \
	done

# Export validator keys
export-validator:
	story validator export
	story validator export --export-evm-key

# Create validator with stake
create-validator:
	story validator create --stake 1000000000000000000 --private-key "your_private_key"

.PHONY: install-deps install-story-geth install-story init-node create-story-geth-service create-story-service start-services logs-story-geth logs-story check-sync-status check-block-sync export-validator create-validator
