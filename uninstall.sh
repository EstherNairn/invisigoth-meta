#!/bin/bash
# Invisigoth Uninstall Script
# Run this as a user with sudo privileges
# This will stop the service, remove files, and optionally remove the user and sudoers entry

set -e

SERVICE_NAME="invisigoth"
INSTALL_DIR="/opt/invisigoth"
SUDOERS_FILE="/etc/sudoers.d/invisigoth"
SYSTEMD_FILE="/etc/systemd/system/${SERVICE_NAME}.service"
PURGE_USER=false

# Parse command-line arguments
for arg in "$@"; do
  case "$arg" in
    --purge-user)
      PURGE_USER=true
      ;;
    -h|--help)
      echo "Usage: $0 [--purge-user]"
      echo "  --purge-user     Also delete the 'invisigoth' user and remove sudoers entry"
      exit 0
      ;;
    *)
      echo "[!] Unknown option: $arg"
      echo "    Use -h for help."
      exit 1
      ;;
  esac
done

echo "[*] Stopping Invisigoth service..."
if systemctl is-active --quiet "$SERVICE_NAME"; then
  sudo systemctl stop "$SERVICE_NAME"
fi

echo "[*] Disabling Invisigoth service..."
sudo systemctl disable "$SERVICE_NAME" || true

echo "[*] Removing systemd service file..."
if [ -f "$SYSTEMD_FILE" ]; then
  sudo rm -f "$SYSTEMD_FILE"
  sudo systemctl daemon-reload
  echo "[✓] Systemd service removed."
else
  echo "[i] No systemd service file found."
fi

echo "[*] Deleting Invisigoth install directory at $INSTALL_DIR..."
if [ -d "$INSTALL_DIR" ]; then
  sudo rm -rf "$INSTALL_DIR"
  echo "[✓] Directory removed."
else
  echo "[i] No install directory found."
fi

if $PURGE_USER; then
  echo "[*] Removing passwordless sudo access..."
  if [ -f "$SUDOERS_FILE" ]; then
    sudo rm -f "$SUDOERS_FILE"
    echo "[✓] Sudoers entry removed."
  else
    echo "[i] No sudoers file found."
  fi

  echo "[*] Deleting user 'invisigoth'..."
  if id -u invisigoth >/dev/null 2>&1; then
    sudo userdel -r invisigoth
    echo "[✓] User deleted."
  else
    echo "[i] User 'invisigoth' does not exist."
  fi
else
  echo "[i] Skipping user and sudoers removal (use --purge-user to remove them)."
fi

echo "[✔] Invisigoth has been successfully uninstalled."
