#!/usr/bin/env bash
set -e

echo "🚀 Restoring sashomarchy configuration..."

# Create config directories
mkdir -p ~/.config/tmux ~/.config/yazi ~/.config/btop ~/.config/omarchy/themes ~/.config/omarchy/defaults ~/wallpapers

# Restore configs
cp config/bash/.bashrc ~/.bashrc
cp -r config/tmux/* ~/.config/tmux/
cp -r config/yazi/* ~/.config/yazi/
cp -r config/btop/* ~/.config/btop/
cp -r config/omarchy/themes/* ~/.config/omarchy/themes/
cp -r config/omarchy/defaults/* ~/.config/omarchy/defaults/
cp -r wallpapers/* ~/wallpapers/
chmod +x scripts/rotate-terminal-wallpaper.sh

echo "✅ sashomarchy configs restored successfully!"