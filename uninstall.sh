#!/bin/bash
# ==============================================================================
# Tool Name:    Automated Uninstaller for Flatpak Progress Installer
# Description:  Safely removes binary files, desktop launchers, and cleans up
#               associated user-level MIME type registrations.
# ==============================================================================

# 0. Prompt for confirmation unless -y / --yes flag is passed
if [[ "$1" != "-y" && "$1" != "--yes" ]]; then
    read -p "❓ Are you sure you want to uninstall Flatpak Progress Installer? [y/N] " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            ;;
        *)
            echo "❌ Uninstallation cancelled."
            exit 0
            ;;
    esac
fi

echo "👀 Starting uninstallation..."

# 1. Remove the global binary executable
if [ -f "/usr/local/bin/flatpak-progress-installer.sh" ]; then
    echo "🗑️  Removing binary from /usr/local/bin..."
    sudo rm -f /usr/local/bin/flatpak-progress-installer.sh
fi

# 2. Remove the desktop application launcher
APPS_DIR="$HOME/.local/share/applications"
LAUNCHER_FILE="$APPS_DIR/flatpak-progress-installer.desktop"

if [ -f "$LAUNCHER_FILE" ]; then
    echo "🗑️  Removing desktop launcher entry..."
    rm -f "$LAUNCHER_FILE"
fi

# 3. Clean up user-level MIME type associations
USER_MIME="$HOME/.config/mimeapps.list"
if [ -f "$USER_MIME" ]; then
    echo "⚙️  Cleaning up user MIME associations..."
    sed -i '/flatpak-progress-installer\.desktop/d' "$USER_MIME"
fi

# 4. Rebuild the desktop application database
if command -v update-desktop-database &> /dev/null && [ -d "$APPS_DIR" ]; then
    echo "⚙️  Rebuilding application database..."
    update-desktop-database "$APPS_DIR"
fi

echo "✅ Flatpak Progress Installer has been completely uninstalled."