#!/bin/bash

# Update package lists and install git
sudo apt-get update
sudo apt-get install git -y

# Install tmux
sudo apt-get install tmux -y

# Download and install Go
wget https://go.dev/dl/go1.20.12.linux-amd64.tar.gz

# Check if /usr/local/go exists and delete it if it does
if [ -d "/usr/local/go" ]; then
  sudo rm -rf /usr/local/go
fi

# Extract the downloaded Go tarball to /usr/local
sudo tar -C /usr/local -xzf go1.20.12.linux-amd64.tar.gz

# Update .profile to include Go in the PATH
if ! grep -q "/usr/local/go/bin" ~/.profile; then
  echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
  source ~/.profile
fi

# Clone the GitHub repository
git clone https://github.com/QuilibriumNetwork/ceremonyclient.git

# Create a new tmux session, run the Go project, and attach it to session 0
tmux new-session -d -s 0 'cd ceremonyclient/node && GOEXPERIMENT=arenas go run ./...'

# Automatically detach the session
tmux detach -s 0

echo "Setup complete. tmux session '0' has been created and detached."
