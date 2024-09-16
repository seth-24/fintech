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

# Create server_control.sh script for controlling the server (start/stop)
echo "Creating server control script..."
cat <<EOL > server_control.sh
#!/bin/bash

# Function to start the Flask server
start_server() {
  echo "Starting the Flask server..."
  nohup python3 auth_server.py &> server.log &
  echo \$! > server.pid  # Save the PID of the server process
  echo "Server started and running in the background."
}

# Function to stop the Flask server
stop_server() {
  if [ -f "server.pid" ]; then
    PID=\$(cat server.pid)
    echo "Stopping the Flask server with PID: \$PID"
    kill \$PID
    rm server.pid  # Remove the PID file after stopping
    echo "Server stopped."
  else
    echo "Server is not running or PID file not found."
  fi
}

# Check for user input
case "\$1" in
  start)
    start_server
    ;;
  stop)
    stop_server
    ;;
  *)
    echo "Usage: server_control.sh {start|stop}"
    ;;
esac
EOL

# Make server control script executable
chmod +x server_control.sh

echo "Setup is complete. You can now use './server_control.sh start' to start the server and './server_control.sh stop' to stop it."

# Repository link
echo "For more information, please visit your repository: https://github.com/seth-24/fintech"
