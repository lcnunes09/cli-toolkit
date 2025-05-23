#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLI_DIR="$(dirname "$SCRIPT_DIR")"
BIN_DIR="$CLI_DIR/bin"

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

if [ ! -f ~/.ssh/id_ed25519.pub ] && [ ! -f ~/.ssh/id_rsa.pub ]; then
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

# Step 1: Make all bin/ scripts executable
if [ -d "$BIN_DIR" ] && compgen -G "$BIN_DIR/*" > /dev/null; then
  echo "✅ Making all CLI files in $BIN_DIR executable..."
  chmod +x "$BIN_DIR"/*
else
  echo "⚠️ No CLI scripts found in $BIN_DIR — skipping chmod"
fi

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

# Final instruction to the user
echo ""
echo "🔁 Please restart your terminal or run:"
echo "   source $SHELL_RC"
echo ""
echo "🚀 Bootstrap complete. Try 'ghstatus' or 'ghwhoami'! ✨"
