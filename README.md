# 📀 CLI Toolkit
A lightweight and expressive CLI toolkit for Git cleanup and automation.

## 🛠 Installation (Recommended: Setup Script)

Clone the repo and run the setup script:
```bash
git clone git@github.com:lcnunes09/cli-toolkit.git && cd cli-toolkit && ./scripts/setup.sh
```

This will:

- ✅ Make all CLI files in bin/ executable
- ✅ Add the CLI path to your shell config (.zshrc or .bashrc)
- ✅ Warn you about missing tools like Git or SSH
- ✅ Reload your shell automatically


# ✅ Usage Examples

## 🩹 ghclean – Clean merged Git branches

### ✨ Features

- Deletes merged local branches (except protected ones)
- Deletes matching remote branches
- Safe to run only from main, dev, or master

🧠 Note: Works only from main, dev, or master to avoid accidental deletion from feature branches

```bash
ghclean --help
ghclean --dry-run           # Show what would be deleted
ghclean --remote-only       # Only delete remote branches
ghclean --confirm           # Prompt before each deletion
ghclean --remote-only --confirm
```

## 🌿 ghprune – Remove stale local branches

Deletes local branches that no longer exist on the remote.

```bash
ghprune                  # See which local branches were actually removed
```

## 📂 ghsafe – Backup your repo

Creates a .bundle archive of all Git branches for backup.

```bash
ghsafe
```

## 📆 ghstatus – Repo summary at a glance

Shows current branch, uncommitted changes, unpushed commits, remote tracking, etc.

```bash
ghstatus                  # status for current branch
ghstatus --verbose        # status + details
ghstatus --base main      # check branches unmerged into 'main'
ghstatus --base dev -v    # verbose for branches unmerged into dev
```

## 🧑‍🚀 ghwhoami – Show Git identity

Displays your configured Git name, email, SSH connection status, and whether an SSH key is present.


```bash
ghwhoami
```

## 🤖 Coming Soon Ideas

- `ghtrack` – Fix or report branches not tracking origin
- `ghdiff` – Show diff vs main with flags
- `ghreset` – Hard reset local branch to remote
- `ghfix` – Common Git misconfig fixes

# 📜 License

MIT
