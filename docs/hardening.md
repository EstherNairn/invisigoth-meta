# Invisigoth Hardening & Security Notes

Invisigoth is designed to run autonomously on a self-contained system. If you plan to deploy it in a long-running environment, especially in any networked or cloud-facing scenario, consider applying these security best practices.

---

## 1. 🔐 Passwordless `sudo` (Required for Autonomy)

If Invisigoth is to manage its own updates, restarts, or services, it needs passwordless access to `sudo`.

Use `visudo` to edit the sudoers file:

```bash
sudo visudo
```

### Recommended (Scoped Access):
```
invisigoth ALL=(ALL) NOPASSWD: /bin/systemctl, /usr/bin/apt, /usr/bin/apt-get
```

### Less Secure (Full Autonomy):
```
invisigoth ALL=(ALL) NOPASSWD: ALL
```

Use this if you're running in an airgapped lab or tightly controlled VM.

---

## 2. 🔒 Lock Down SSH

- Disable password-based SSH login in `/etc/ssh/sshd_config`:
  ```
  PasswordAuthentication no
  ```
- Use SSH key authentication only.
- Restrict SSH to a non-standard port (optional).
- Allow SSH only from trusted IPs via UFW or firewall.

---

## 3. 🌐 Web Dashboard Protection

By default, the Flask dashboard listens on `0.0.0.0:5000`, making it accessible over the LAN.

If you're exposing it:
- Use a reverse proxy like **Nginx** or **Caddy** with HTTPS
- Require basic HTTP auth or a login page
- Or tunnel access via SSH (e.g. `ssh -L 5000:localhost:5000 invisigoth@<vm-ip>`)

---

## 4. 🔁 Git Commit Identity

To distinguish AI-generated commits:

```bash
git config --global user.name "Invisigoth AI"
git config --global user.email "invisigothAI@proton.me"
```

Or use GitHub’s noreply email for cleaner attribution.

---

## 5. 🔍 Monitoring & Logging

- View system logs: `journalctl -u invisigoth -f`
- Consider setting up log rotation for `logs/`
- Use `fail2ban` or similar to monitor suspicious access attempts

---

## 6. 🛡️ General Host Hardening

- Keep system updated: `sudo apt update && sudo apt upgrade -y`
- Disable unused services
- Limit outbound internet access if appropriate
- Snapshot the VM periodically (Proxmox makes this easy)

---

## 7. 📁 Protect Secrets

Ensure:
- `.env` and `config.yaml` are owned by `invisigoth` and readable only by it.
- They are excluded from Git using `.gitignore`.

---

## 8. 🧪 Reset Host Keys for Cloned VMs

After cloning a Proxmox template, run:

```bash
sudo rm /etc/ssh/ssh_host_*
sudo dpkg-reconfigure openssh-server
sudo systemctl restart ssh
```

---

## ✅ Summary: Minimally Required for Autonomous Operation

- [x] `invisigoth` has a password
- [x] `invisigoth` is in the `sudo` group
- [x] Passwordless sudo is configured
- [x] SSH uses key-based auth
- [x] Web dashboard is LAN-restricted or tunneled
