#!/bin/bash

# Update package lists and install Python
pkg update -y && pkg upgrade -y
pkg install python -y

# Install pip if not installed
if ! command -v pip &> /dev/null
then
    echo "pip not found, installing pip..."
    pkg install python-pip -y
fi

# Install Python dependencies
pip install -r requirements.txt

# Start the Flask server
echo "Starting the Flask server..."
python3 auth_server.py
