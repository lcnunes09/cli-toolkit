#!/usr/bin/env bash

HIST_FILE="$HOME/.zsh_history"
BACKUP_FILE="$HIST_FILE.bak.$(date +%Y%m%d%H%M%S)"
CLEAN_FILE="$HIST_FILE.clean"

echo "🩹 Fixing Zsh history..."

# Step 1: Backup
echo "📦 Backing up current history to: $BACKUP_FILE"
cp "$HIST_FILE" "$BACKUP_FILE"

# Step 2: Clean using strings
echo "🧹 Cleaning file content..."
strings "$BACKUP_FILE" > "$CLEAN_FILE"

# Step 3: Replace corrupted file
mv "$CLEAN_FILE" "$HIST_FILE"
chmod 600 "$HIST_FILE"

# Step 4: Reload (this may fail silently if not in a proper shell context)
fc -R "$HIST_FILE" 2>/dev/null || echo "⚠️ Reload failed — restart your shell manually."

echo "✅ Zsh history has been cleaned and replaced."
