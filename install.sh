#!/bin/bash
# Automated Installer for Flatpak Progress Installer


echo "👀 Checking system dependencies..."

# Check if both required dependencies are present
MISSING_DEPS=()

if ! command -v flatpak &> /dev/null; then
    MISSING_DEPS+=("flatpak")
fi

if ! command -v zenity &> /dev/null; then
    MISSING_DEPS+=("zenity")
fi

# If any dependencies are missing, alert the user and exit
if [ ${#MISSING_DEPS[@]} -ne 0 ]; then
    echo "Error: Missing required system dependencies: ${MISSING_DEPS[*]}"
    echo "Please install them via your distribution's package manager and try again."
    exit 1
fi

echo "🚀 Starting installation..."

# 1. Copy the main runtime engine to the global binary path
echo "📦 Copying installer script to /usr/local/bin..."
sudo cp flatpak-progress-installer.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/flatpak-progress-installer.sh

# 2. Copy the desktop integration file to the user's local application directory
echo "🖥️  Integrating desktop settings..."
APPS_DIR="$HOME/.local/share/applications"
mkdir -p "$APPS_DIR"
cp flatpak-progress-installer.desktop "$APPS_DIR/"

# 3. Force the operating system to register the new protocol handlers
echo "⚙️  Rebuilding MIME-type application associations..."
update-desktop-database "$APPS_DIR"
xdg-mime default flatpak-progress-installer.desktop x-scheme-handler/flatpak+https
xdg-mime default flatpak-progress-installer.desktop x-scheme-handler/flatpak

echo "✅ Installation successful! Your browser and file manager are now ready to use this utility."
