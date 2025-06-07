# Invisigoth Meta

This repository contains the **deployment and system-level control infrastructure** for [Invisigoth](https://github.com/EstherNairn/invisigoth) — a self-bootstrapping AI coding assistant.

This **meta-repo** is human-managed. It defines how Invisigoth is installed, started, secured, and uninstalled, but **the AI itself does not touch this repo**.

---

## 🧠 Purpose

This repo acts as the **control plane** for Invisigoth:

- Install/uninstall scripts to manage the runtime system
- Systemd unit file to run Invisigoth as a service
- Configuration templates for secrets and runtime settings
- Documentation on hardening and architecture
- Git commit authoring conventions for human vs AI

---

## 📁 Directory Structure

```plaintext
.
├── install.sh                   # One-click setup for the Invisigoth runtime
├── uninstall.sh                 # Clean removal of the system
├── config/
│   ├── config.yaml.example      # LLM provider and runtime settings
│   ├── env.example              # Template for .env (API key, etc.)
│   └── invisigoth.service       # systemd unit to run Invisigoth under its own user
├── docs/
│   ├── architecture.md          # System architecture design
│   └── hardening.md             # Security hardening notes
├── LICENSE
└── README.md                    # You're reading it
```

---

## 🚀 Install Instructions

Run as a user with `sudo` privileges:

```bash
./install.sh
```

This script will:

- Create a system user `invisigoth` with a home directory
- Clone the Invisigoth runtime repo to `/opt/invisigoth`
- Set up a Python virtual environment
- Install dependencies via `pip`
- Configure and enable the `invisigoth` systemd service

---

## 🔁 Uninstall Instructions

To uninstall Invisigoth

```bash
./uninstall.sh
```

This stops and disables the service and deletes the install directory.

To fully remove the invisigoth user run the following:

```bash
./uninstall.sh --purge-user
```

---

## 🔐 Secrets and Config

Before starting the service, ensure you have:

- `.env` file in `/opt/invisigoth` with your LLM API key:
  ```
  OPENROUTER_API_KEY=sk-...
  ```

- `config.yaml` in `/opt/invisigoth` for LLM config (see `config/config.yaml.example`)

These should never be committed to Git.

---

## 🛡️ Hardening Recommendations

See:
- `docs/hardening.md` for systemd protections and sudo policy setup
- `docs/architecture.md` for an overview of runtime–meta separation

---

## 📦 Related Repositories

- [invisigoth](https://github.com/EstherNairn/invisigoth): The self-bootstrapping AI system
- This repo: Deployment & lifecycle manager

---

## 📜 License

MIT, same as core project. Scripts are yours to extend.
