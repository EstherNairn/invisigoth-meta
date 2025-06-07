# Invisigoth Meta

This repository contains system-level configuration, install scripts, and operational policies for the [Invisigoth AI coding assistant](https://github.com/EstherNairn/invisigoth).

It is **not the AI itself**, but the control layer around it.

## 📁 Contents

- `scripts/` — install, uninstall, setup, and maintenance scripts
- `docs/` — architecture, hardening, and operational policy
- `systemd/` — system service files for deploying Invisigoth on Linux systems

## 🚫 What This Repo Does NOT Contain

- No runtime logic
- No goal files
- No LLM-specific code
- No self-modifying AI behavior

## 🧠 Purpose

This repository is intended to be human-managed. The AI assistant (Invisigoth) does **not** push to this repo and cannot modify its contents. It serves as the configuration, bootstrap, and safety shell around the project.

## 🔐 Example Use Cases

- Set up Invisigoth on a Proxmox VM via `scripts/install.sh`
- Tune sudo policies and logging
- Monitor, update, or redeploy the AI safely

---

## 📦 Related Repositories

- [Invisigoth Runtime](https://github.com/EstherNairn/invisigoth) — the self-bootstrapping AI assistant
- This repo (`invisigoth-meta`) — control plane for setup, safety, and system integration
