#!/bin/bash
#
# Invisigoth Install Script
# Run this as a user with sudo privileges (NOT as root and NOT as the invisigoth user).
# It will install dependencies, configure systemd, and set up passwordless sudo.

if ! sudo -v; then
  echo "[ERROR] This script must be run by a user with sudo privileges."
  exit 1
fi

set -e

echo "[*] Installing required system packages..."
sudo apt update && sudo apt install -y python3 python3-venv python3-pip git

echo "[*] Cloning Invisigoth repository..."
if [ ! -d "invisigoth" ]; then
  git clone https://github.com/YOUR_GITHUB_USERNAME/invisigoth.git
fi

cd invisigoth

echo "[*] Setting up virtual environment..."
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

echo "[*] Creating logs directory..."
mkdir -p logs
touch logs/app.log

echo "[*] Configuring passwordless sudo (for autonomous execution)..."
echo "invisigoth ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/invisigoth > /dev/null
sudo chmod 0440 /etc/sudoers.d/invisigoth

echo "[*] Copying systemd service..."
sudo cp invisigoth.service /etc/systemd/system/invisigoth.service

echo "[*] Enabling and starting Invisigoth..."
sudo systemctl daemon-reexec
sudo systemctl enable invisigoth
sudo systemctl start invisigoth

echo "[✔] Invisigoth is installed and running."
