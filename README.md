# 📀 CLI Toolkit

A lightweight and expressive CLI toolkit for Git cleanup, repo hygiene, and everyday automation. Designed to save your time — and your branches.

## 🛠 Installation (Recommended: Setup Script)

Clone the repo and run the setup script:

```bash
git clone git@github.com:lcnunes09/cli-toolkit.git && cd cli-toolkit && ./scripts/setup.sh
```

This will:

* ✅ Make all CLI tools in `bin/` executable
* ✅ Add the CLI directory to your shell path (`.zshrc` or `.bashrc`)
* ✅ Warn you if Git or SSH are missing or misconfigured
* ✅ Add an alias `ghcli` to jump to the repo folder
* ✅ Install the `fixzsh` command globally
* ✅ Remind you to source your shell to finish setup

> 💡 `fixzsh` is now globally available after running `setup.sh` — no need to configure anything else.

---

## ✅ Usage Cheatsheet

### 🩹 `ghclean` – Clean merged Git branches

Deletes all merged local and remote branches in one go — except protected ones like main, dev, and master.

```bash
ghclean --help
ghclean --dry-run             # Preview deletions
ghclean --remote-only         # Only delete remote branches
ghclean --confirm             # Prompt before each deletion
ghclean --dry-run --confirm   # Preview and prompt
```

* ✅ Safe: must run from a base branch (main, dev, master)
* ✅ Smart: skips protected branches and shows a cleanup summary
* ✅ Powerful: cleans all merged branches in one pass

### 🌿 `ghprune` – Remove stale local branches

Deletes local branches that were removed remotely (e.g. after a PR is merged):

```bash
ghprune                  # See which local branches were actually removed
```

### 💾 `ghsafe` – Backup your repo

Creates a .bundle archive of your repo — all branches included:

```bash
ghsafe
```

Perfect for backups or safe transfer.

### 📊 `ghstatus` – Repo summary at a glance

Displays Git info like:

* Current branch
* Uncommitted changes
* Unpushed commits
* Remote tracking
* Unmerged branches (into base)

```bash
ghstatus                 # Quick status
ghstatus --verbose       # Full details
ghstatus --base main     # Check what's not merged into 'main'
ghstatus -v --base dev   # Verbose for unmerged into dev
```

### 🧑‍💻 `ghwhoami` – See your Git identity

Displays your configured Git name, email, SSH connection status, and whether an SSH key is present.

```bash
ghwhoami
```

---

## 🧼 `fixzsh` – Repair a corrupt `.zsh_history`

If your terminal ever shows:

```bash
zsh: corrupt history file /home/yourname/.zsh_history
```

Just run:

```bash
fixzsh
```

This command will:

* 🔐 Backup your current (possibly corrupted) history file
* 🛉 Strip out invalid or unreadable content
* 🔁 Replace it with a clean version
* ✅ Eliminate the startup error for good

> `fixzsh` is installed globally by `setup.sh` — use it from **anywhere**, anytime.

---

## 🤖 Coming Soon Ideas

* `ghtrack` – Fix or report branches not tracking origin
* `ghdiff` – Show diff vs main with flags
* `ghreset` – Hard reset local branch to remote
* `ghfix` – Common Git misconfig fixes

Do you want to collaborate? Open an issue or PR!

---

## 📜 License

MIT
