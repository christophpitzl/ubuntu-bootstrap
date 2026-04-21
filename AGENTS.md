# Agent notes

This file contains repository-level notes for automation agents, maintainers, and tooling.

## Purpose

- Use minimal Ubuntu desktop base images for student VMs.
- Install required tools and packages through scripted automation.
- Keep the VM bootstrap process reproducible with shell scripts and GitHub-hosted lecture install scripts.

## Workflow

1. Start from a blank Ubuntu desktop image.
2. Copy `first-login-setup.sh` into `/home/student`.
3. Run `/home/student/first-login-setup.sh` once from the standard student account.
4. Log out and log back in.
5. On login, the helper installs itself into autostart, pulls the bootstrap repo, and launches the profile selector.
6. The selected lecture profile installs required packages from the network.

## Design concept

- Deliver the initial VM image locally via USB/disk so students boot a prepared Ubuntu VM.
- Use a standard non-root student account for safety and consistency.
- Keep the bootstrap repo generic and let lecture repos publish their own `scripts/setup.sh` via GitHub Pages.
- Use first-login automation to avoid manual setup steps and keep the VM ready across reboots.

## Implementation status

- `bootstrap.sh` — main launcher and profile selector.
- `common.sh` — shared helper functions and network checks.
- `profiles/` — lecture profile wrappers that fetch published `scripts/setup.sh` from lecture repos.
- `first-login-setup.sh` — first-login auto-fetch setup helper.
- `README.md` — consolidated user-facing setup and install instructions.

## Notes for agents

- Prefer the first-login auto-fetch workflow over manual VM configuration whenever possible.
- Keep documentation in `README.md` user-focused and `AGENTS.md` agent/implementation-focused.
- Use clear git commit conventions such as `docs:`, `fix:`, `feat:`, and `chore:` for commit messages.
