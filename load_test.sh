#!/bin/bash

# Function to install siege on macOS
install_siege_mac() {
    echo "Installing siege on macOS..."
    if ! command -v brew &> /dev/null
    then
        echo "Homebrew not found. Please install Homebrew first: https://brew.sh/"
        exit 1
    fi
    brew install siege
}

# Function to install siege on Linux
install_siege_linux() {
    echo "Installing siege on Linux..."
    if command -v apt-get &> /dev/null
    then
        sudo apt-get update && sudo apt-get install -y siege
    elif command -v yum &> /dev/null
    then
        sudo yum install -y siege
    else
        echo "Neither apt-get nor yum found. Please install siege manually."
        exit 1
    fi
}

# Check if siege is installed
if ! command -v siege &> /dev/null
then
    echo "siege could not be found, installing..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        install_siege_linux
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        install_siege_mac
    else
        echo "Unsupported OS: $OSTYPE. Please install siege manually."
        exit 1
    fi
fi

# URL to test
URL="http://localhost"

# Number of concurrent users
CONCURRENT_USERS=10

# Duration of the test (e.g., 1M for 1 minute, 10S for 10 seconds)
DURATION="1M"

# Run the load test
echo "Running siege load test on $URL with $CONCURRENT_USERS concurrent users for $DURATION..."
siege -c $CONCURRENT_USERS -t $DURATION $URL

echo "Load test completed."
