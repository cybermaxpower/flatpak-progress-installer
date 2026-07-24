#!/bin/bash
# ==============================================================================
# Tool Name:    Automated Installer for Flatpak Progress Installer
# Description:  Deploys the main script to global binaries, creates the desktop 
#               launcher entry, and registers default protocol/MIME handlers.
# ==============================================================================

echo "👀 Checking system dependencies..."

# Check if flatpak is installed
if ! command -v flatpak &> /dev/null; then
    echo "❌ Error: Flatpak is not installed on this system."
    echo "Please install Flatpak first (e.g., 'sudo apt install flatpak') and try again."
    exit 1
fi

echo "🚀 Starting installation..."

# 1. Copy the main runtime engine to the global binary path
echo "📦 Copying installer script to /usr/local/bin..."
sudo cp flatpak-progress-installer.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/flatpak-progress-installer.sh

# 2. Automatically generate/overwrite the clean desktop entry in the proper directory
echo "🖥️  Integrating desktop settings..."
APPS_DIR="$HOME/.local/share/applications"
LAUNCHER_FILE="$APPS_DIR/flatpak-progress-installer.desktop"

mkdir -p "$APPS_DIR"

cat << EOF > "$LAUNCHER_FILE"
[Desktop Entry]
Type=Application
Name=Flatpak Progress Installer
Exec=/usr/local/bin/flatpak-progress-installer.sh %u
Terminal=false
Categories=System;
MimeType=x-scheme-handler/flatpak;x-scheme-handler/flatpak+https;x-scheme-handler/appstream;application/vnd.flatpak.ref;application/vnd.flatpak;
EOF

chmod +x "$LAUNCHER_FILE"

# 3. Force the operating system and Brave to register the new protocol handlers
echo "⚙️  Rebuilding MIME-type application associations..."
update-desktop-database "$APPS_DIR"

# Ensure the user's local mimeapps.list exists
USER_MIME="$HOME/.config/mimeapps.list"
mkdir -p "$HOME/.config"
touch "$USER_MIME"

# Add default application entries cleanly to the user's local profile
for mime in "x-scheme-handler/flatpak" "x-scheme-handler/flatpak+https" "x-scheme-handler/appstream" "application/vnd.flatpak.ref" "application/vnd.flatpak"; do
    xdg-mime default flatpak-progress-installer.desktop "$mime"
done

echo "✅ Installation successful! Your browser and file manager are now mapped to this utility."
