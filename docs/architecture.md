# Placeholder: architecture overview


---

## 🧱 Runtime vs Meta Repositories

Invisigoth is split into two GitHub repositories to preserve modularity and autonomy boundaries:

### 1. `invisigoth` (Runtime AI)
- Contains the main plan–generate–execute loop
- Manages goals, LLM interaction, file updates, Git commits
- Runs autonomously as a `systemd` service
- May eventually self-modify

### 2. `invisigoth-meta` (Control Layer)
- Stores install scripts, deployment policies, and system hardening guides
- Never modified by the AI
- Used only by system administrators or developers
- Contains systemd unit files, `.env` examples, and security notes

This division helps maintain clear trust boundaries between human-managed configuration and autonomous behavior.
