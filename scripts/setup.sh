#!/bin/bash

set -e

CLI_DIR="$HOME/cli-toolkit"
BIN_DIR="$CLI_DIR/bin"

echo "🔧 Bootstrapping cli-toolkit..."

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

# Step 1: Make everything in bin/ executable
echo "✅ Making all CLI files in $BIN_DIR executable..."
chmod +x "$BIN_DIR"/*

# Step 2: Add to PATH if not already
SHELL_RC="$HOME/.zshrc"
[[ "$SHELL" == *bash* ]] && SHELL_RC="$HOME/.bashrc"

if ! grep -q "$BIN_DIR" "$SHELL_RC"; then
  echo "🔗 Adding $BIN_DIR to PATH in $SHELL_RC"
  echo -e "\n# cli-toolkit\nexport PATH=\"$BIN_DIR:\$PATH\"" >> "$SHELL_RC"
else
  echo "🔁 PATH already configured in $SHELL_RC"
fi

# Step 3: Reload the shell config
echo "🔄 Reloading shell: $SHELL_RC"
source "$SHELL_RC"

echo "🚀 Bootstrap complete. Try 'ghstatus' or 'ghwhoami'! ✨"