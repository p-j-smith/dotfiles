# dotfiles

My setup for macOS and Fedora, managed by [chezmoi](https://chezmoi.io): the shell, CLI tools
(with mise), Neovim, Ghostty and Zed, plus the apps and settings for each system.

## Install

1. In a terminal:

   ```sh
   sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin" init --apply --use-builtin-git true p-j-smith
   ```

   - When it asks, type your name and email address (for git commits).
   - macOS: when the Command Line Tools dialog appears, click **Install** and wait. It asks for
     your password once, to install the apps.
   - Fedora: it asks for your password for `sudo`.

2. Open a new terminal (on Fedora, log out and back in).
3. By hand:
   - macOS: sign in with your Apple ID and run Software Update; sign in to VS Code Settings Sync
     and Slack; open Rectangle, allow Accessibility access and turn on Launch at login
   - Fedora: make Ghostty the default terminal; sign in to VS Code Settings Sync and Slack

4. To push changes back to GitHub (not needed to install), create an SSH key:

   ```sh
   ssh-keygen -t ed25519   # choose a passphrase

   cat > ~/.ssh/config <<'CONFIG'
   Host *
       AddKeysToAgent yes
       IdentityFile ~/.ssh/id_ed25519
       ServerAliveInterval 30
   CONFIG

   chmod 700 ~/.ssh
   chmod 600 ~/.ssh/id_ed25519 ~/.ssh/config
   chmod 644 ~/.ssh/id_ed25519.pub

   gh auth login   # choose SSH; it offers to upload ~/.ssh/id_ed25519.pub
   chezmoi git -- remote set-url origin git@github.com:p-j-smith/dotfiles.git
   ```

Everyday use is in [docs/day-to-day.md](docs/day-to-day.md), and keyboard shortcuts in
[docs/shortcuts-macos.md](docs/shortcuts-macos.md) and [docs/shortcuts-fedora.md](docs/shortcuts-fedora.md).
