# Invisigoth Install Script
# Run this as a user with sudo privilege
# It will install dependencies, configure systemd, and set up passwordless sudo.

set -e

if ! sudo -v; then
  echo "[ERROR] This script must be run by a user with sudo privileges."
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICE_PATH="$SCRIPT_DIR/systemd/invisigoth.service"
INSTALL_DIR="/opt/invisigoth"
PUBKEY_COPY="$SCRIPT_DIR/invisigoth_id_ed25519.pub"

# Update the system and install base packages required for installation
echo "[*] Installing required system packages..."
sudo apt update && sudo apt install -y python3 python3-venv python3-pip git

# Create user account for invisigoth
echo "[+] Creating system user 'invisigoth' (if not exists)..."
if ! id -u invisigoth >/dev/null 2>&1; then
    sudo useradd --create-home  --shell /bin/bash invisigoth
    echo "[✓] User 'invisigoth' created."
else
    echo "[i] User 'invisigoth' already exists, skipping."
fi

# Generate SSH key for invisigoth if it doesn't exist
if ! sudo -u invisigoth test -f /home/invisigoth/.ssh/id_ed25519; then
    echo "[*] Generating SSH key for 'invisigoth'..."
    sudo -u invisigoth --login ssh-keygen -t ed25519 -q -N ""
    echo "[✓] SSH key generated."
else
    echo "[i] SSH key already exists for 'invisigoth', skipping."
fi

# Export public key
sudo cp /home/invisigoth/.ssh/id_ed25519.pub "$PUBKEY_COPY"
sudo chown "$(whoami):$(whoami)" "$PUBKEY_COPY"

# Give invisigoth account passwordless access
echo "[*] Configuring passwordless sudo (for autonomous execution)..."
echo "invisigoth ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/invisigoth > /dev/null
sudo chmod 0440 /etc/sudoers.d/invisigoth

echo "[*] Cloning Invisigoth repository..."
if [ ! -d "invisigoth" ]; then
  sudo git clone https://github.com/EstherNairn/invisigoth.git $INSTALL_DIR
fi

sudo chown -R invisigoth:invisigoth "$INSTALL_DIR" 

echo "[*] Setting up virtual environment..."
sudo -u invisigoth bash -c "
cd /opt/invisigoth
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
"

echo "[*] Creating logs directory..."
sudo -u invisigoth mkdir -p /opt/invisigoth/logs
sudo -u invisigoth touch /opt/invisigoth/logs/app.log

echo "[*] Copying systemd service..."
sudo cp ./systemd/invisigoth.service /etc/systemd/system/invisigoth.service

echo "[*] Enabling and starting Invisigoth..."
sudo systemctl daemon-reexec
sudo systemctl enable invisigoth
sudo systemctl start invisigoth

echo "[✔] Invisigoth is installed and running."
echo "[!] Please add the following SSH public key to your GitHub account:"
cat "$PUBKEY_COPY"
