# Ubuntu Webots Bootstrap

I give lectures using Ubuntu.

This repository starts from base images of blank Ubuntu, and sets up everything else using shell scripts and git repositories.

## Purpose

- Use minimal Ubuntu base images
- Install and configure tools via automation
- Keep the environment reproducible with shell scripts and git sources

## Workflow

1. Start from a blank Ubuntu image
2. Run setup/install shell scripts
3. Pull required code from git repositories
4. Use the resulting system for lectures

## Design concept

- Distribute the initial VM image via USB/disk, so students boot a prepared Ubuntu VM locally.
- Students log in with a standard non-root account.
- On first login, a launcher pops up and asks the student to select the lecture or use case.
- The bootstrap logic then downloads and installs only the required packages and scripts from the network.
- This avoids delivering the full multi-gig VM image over a slow network, while still using the network for package installation.
- The repo remains the single source for bootstrap logic, lecture/use-case profiles, and reproducible install steps.
