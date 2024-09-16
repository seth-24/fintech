#!/bin/bash

# Update package lists and upgrade installed packages
echo "Updating and upgrading package lists..."
apt update -y && apt upgrade -y

# Install Python if not installed
echo "Checking if Python 3 is installed..."
if ! command -v python3 &> /dev/null; then
  echo "Python 3 not found, installing..."
  apt install python3 -y
fi

# Install pip if not installed
echo "Checking if pip is installed..."
if ! command -v pip3 &> /dev/null; then
  echo "pip not found, installing..."
  apt install python3-pip -y
fi

# Install git if not installed
if ! command -v git &> /dev/null; then
  echo "git not found, installing..."
  apt install git -y
fi

# Clone your GitHub repository
echo "Cloning your GitHub repository..."
git clone https://github.com/seth-24/fintech.git

# Navigate to the directory of the cloned repository
cd fintech

# Install Python dependencies (Flask and others)
echo "Installing Python dependencies..."
pip3 install -r requirements.txt

# Ensure Flask server script is present
if [ ! -f "auth_server.py" ]; then
  echo "Error: auth_server.py not found!"
  exit 1
fi

# Make sure the script is executable
chmod +x auth_server.py

# Start the Flask server in the background
echo "Starting the Flask server in the background..."
nohup python3 auth_server.py &

echo "Server is running in the background. You can view logs using 'tail -f nohup.out' (if nohup.out exists)."

# Repository link
echo "For more information, please visit your repository: https://github.com/seth-24/fintech"
