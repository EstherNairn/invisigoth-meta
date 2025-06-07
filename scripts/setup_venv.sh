#!/bin/bash
# Setup virtual environment for Invisigoth on Debian-based systems

if ! command -v python3 &> /dev/null
then
    echo "python3 not found, please install it with 'sudo apt install python3'"
    exit 1
fi

if ! command -v python3-venv &> /dev/null
then
    echo "python3-venv not found, installing it..."
    sudo apt update && sudo apt install -y python3-venv
fi

# Create virtual environment
python3 -m venv venv

# Activate it
echo "To activate the virtual environment, run:"
echo "source venv/bin/activate"

# Install dependencies
venv/bin/pip install --upgrade pip
venv/bin/pip install -r requirements.txt
