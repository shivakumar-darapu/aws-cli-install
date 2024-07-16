#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Check if AWS CLI is installed
if command_exists aws; then
    echo "AWS CLI is already installed."
else
    echo "AWS CLI is not installed. Proceeding with installation..."

    # Determine the Linux distribution
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        VERSION=$VERSION_ID
    else
        echo "Cannot determine the Linux distribution."
        exit 1
    fi

    case $OS in
        ubuntu|debian)
            sudo apt update
            sudo apt install -y unzip curl
            curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
            unzip awscliv2.zip
            sudo ./aws/install
            ;;

        centos|rhel|fedora)
            sudo yum install -y unzip curl
            curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
            unzip awscliv2.zip
            sudo ./aws/install
            ;;

        *)
            echo "Unsupported Linux distribution: $OS"
            exit 1
            ;;
    esac

    # Verify the installation
    if command_exists aws; then
        echo "AWS CLI installation completed successfully."
    else
        echo "AWS CLI installation failed."
        exit 1
    fi
fi
