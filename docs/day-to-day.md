# Day to day

How this repo is laid out, and the commands for keeping the setup up to date.

## What's where

| Path in this repo | Becomes | What |
|---|---|---|
| `home/dot_config/mise/config.toml.tmpl` | `~/.config/mise/config.toml` | CLI tools; on macOS also the apps and macOS settings |
| `nvim/` | `~/.config/nvim` (a symlink to it) | LazyVim; edits land in the repo directly |
| `home/dot_zshrc`, `dot_zprofile`, `dot_zshenv`, `dot_zimrc` | `~/.zshrc` etc. | Shell (zim modules, aliases, starship prompt) |
| `home/dot_gitconfig.tmpl`, `home/dot_config/lazygit/` | `~/.gitconfig`, `~/.config/lazygit/` | git, with delta for diffs; your name and email come from `chezmoi init` |
| `home/dot_config/ghostty/config.tmpl` | `~/.config/ghostty/config` | Terminal |
| `home/dot_config/zed/` | `~/.config/zed/` | Zed: vim mode and LazyVim's pane keys. `settings.json` is only created, never overwritten, because Zed writes to it |
| `home/.chezmoiscripts/` | — | The setup steps, run by `chezmoi apply`. Each only runs where it applies |

The setup steps, in order:

| Step | macOS | Fedora |
|---|---|---|
| 10 | Command Line Tools | Base packages (dnf) |
| 20 | mise and the tools, then the apps and macOS settings. Runs again whenever the mise config changes | mise and the tools. Runs again whenever the mise config changes |
| 30 | — | Desktop apps, Docker Engine, fonts, keyboard layout and shortcuts. Runs again whenever the script changes |
| 40 | zsh modules | zsh as the login shell, and its modules |
| 50 | Neovim plugins, language servers and parsers | The same |

Files ending in `.tmpl` are templates: the parts for the other system are left out when chezmoi
writes them. `.chezmoiroot` points chezmoi at `home/`, so the rest of the repo (the README, `docs/`,
`nvim/`, `scripts/`) isn't copied into your home folder. chezmoi uses the repo where it was cloned:
`chezmoi cd` takes you there.

## Day to day

| To... | Run |
|---|---|
| Edit a dotfile | `chezmoi edit --apply ~/.zshrc` |
| Bring in a change made to a dotfile directly | `chezmoi re-add` (not for `.tmpl` files: edit those in the repo) |
| See what `chezmoi apply` would change | `chezmoi diff` |
| Commit and push | `chezmoi cd`, then git as usual |
| Pull changes made on another machine | `chezmoi update` |
| Add a CLI tool | add it to the mise config (`mise registry <tool>` finds its name), then `chezmoi apply` |
| Add a macOS app or setting | add it to the same file, then `chezmoi apply` |
| Update the tools / chezmoi | `mise self-update && mise upgrade` / `chezmoi upgrade` |
| Update Fedora | `sudo dnf upgrade` |
| Pin a tool version for a project | `mise use terraform@1.9` in that project |
| Update Neovim plugins | `:Lazy update` in Neovim, then commit `nvim/lazy-lock.json` |
| Look up a command | `tldr <command>` |

## Docker

- macOS: Colima runs the Linux VM, without Docker Desktop. `colima start` when you need it; it
  doesn't start at login.
- Fedora: Docker Engine, from Docker's repo, runs as a system service.
