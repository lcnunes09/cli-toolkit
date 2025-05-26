#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLI_DIR="$(dirname "$SCRIPT_DIR")"
BIN_DIR="$CLI_DIR/bin"
FIX_SCRIPT_SRC="$CLI_DIR/scripts/fix-zsh-history.sh"
GLOBAL_FIXZSH="/usr/local/bin/fixzsh"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔧 CLI Toolkit Bootstrap Starting"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Step 0: Check for dependencies
MISSING=()

if ! command -v git >/dev/null 2>&1; then
  MISSING+=("Git")
fi

if ! command -v ssh >/dev/null 2>&1; then
  MISSING+=("SSH")
fi

if [ ! -f "$HOME/.ssh/id_ed25519.pub" ] && [ ! -f "$HOME/.ssh/id_rsa.pub" ]; then
  MISSING+=("SSH Key")
fi

if [ ${#MISSING[@]} -ne 0 ]; then
  echo "⚠️ Missing required tools or configuration:"
  for item in "${MISSING[@]}"; do
    echo "   - ❌ $item not found or not set up"
  done
  echo "💡 Please install or configure the above before using all cli-toolkit tools."
  echo ""
fi

# Step 0.5: Check GitHub SSH connectivity
echo "🔐 Checking GitHub SSH authentication..."
SSH_TEST=$(ssh -T git@github.com -o StrictHostKeyChecking=no 2>&1 || true)

if echo "$SSH_TEST" | grep -q "successfully authenticated"; then
  echo "✅ SSH is connected to GitHub!"
else
  echo "⚠️ SSH to GitHub failed or is not set up:"
  echo "   $SSH_TEST"
  echo "💡 Run this to set up SSH: https://docs.github.com/en/authentication/connecting-to-github-with-ssh"
  echo ""
fi

# Step 1: Make all bin/ scripts executable
if [ -d "$BIN_DIR" ] && compgen -G "$BIN_DIR/*" > /dev/null; then
  echo "✅ Making all CLI files in $BIN_DIR executable..."
  chmod +x "$BIN_DIR"/*
else
  echo "⚠️ No CLI scripts found in $BIN_DIR — skipping chmod"
fi

# --- FIX-ZSH GLOBAL INSTALL ---
# Step 1.5: Install fixzsh as a global command
if [ -f "$FIX_SCRIPT_SRC" ]; then
  echo "🩹 Installing fixzsh command globally..."
  chmod +x "$FIX_SCRIPT_SRC"
  sudo ln -sf "$FIX_SCRIPT_SRC" "$GLOBAL_FIXZSH"
  echo "✅ fixzsh is now available system-wide."
else
  echo "⚠️ fix-zsh-history.sh not found in scripts/. Skipping global install."
fi
# --- FIX-ZSH END ---

# Step 2: Detect user shell and pick the right rc file
CURRENT_SHELL=$(basename "$(getent passwd "$LOGNAME" | cut -d: -f7)")
if [[ "$CURRENT_SHELL" == "zsh" ]]; then
  SHELL_RC="$HOME/.zshrc"
elif [[ "$CURRENT_SHELL" == "bash" ]]; then
  SHELL_RC="$HOME/.bashrc"
else
  SHELL_RC="$HOME/.profile"
fi

# Step 3: Add bin/ to PATH if not already there
if ! grep -Fxq "export PATH=\"$BIN_DIR:\$PATH\"  # added by cli-toolkit" "$SHELL_RC"; then
  echo "🔗 Adding $BIN_DIR to PATH in $SHELL_RC"
  echo -e "\n# cli-toolkit\nexport PATH=\"$BIN_DIR:\$PATH\"  # added by cli-toolkit" >> "$SHELL_RC"
else
  echo "🔁 PATH already configured in $SHELL_RC"
fi

# Step 4: Add helpful alias to quickly jump to the repo
if ! grep -q "alias ghcli=" "$SHELL_RC"; then
  echo "➕ Adding ghcli alias to $SHELL_RC"
  echo "alias ghcli='cd $CLI_DIR'" >> "$SHELL_RC"
fi

# Final instructions
echo ""
echo "🚀 Bootstrap complete."
echo ""
echo "🔁 Please restart your terminal or run:"
echo "   source $SHELL_RC"
echo ""
echo "✨ After that, try one of the following:"
echo "   ghstatus   → repo overview"
echo "   ghwhoami   → see Git identity"
echo "   fixzsh     → repair corrupted Zsh history (now globally available)"
echo ""
