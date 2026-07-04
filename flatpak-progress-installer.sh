#!/bin/bash
# ==============================================================================
# Tool Name:    Flatpak Progress Installer
# Description: A native graphical user interface for installing Flatpak applications.
#              It intercepts and translates carriage-return console data ('\r') 
#              from the Flatpak subsystem, turning dynamic line overwrites into 
#              a smooth, real-time streaming Zenity progress bar.
# Supported:    Flathub App IDs (e.g., org.gimp.GIMP), local .flatpakref files,
#              and downloaded .flatpak standalone bundles.
# Usage:        flatpak-progress-installer.sh <Target>
# ==============================================================================

# Ensure Zenity plays nicely with both Wayland and X11
export GDK_BACKEND=wayland,x11

# 1. Ensure an input target was passed first
if [ -z "$1" ]; then
    zenity --error --title="Flatpak Installer" --text="No installation App ID or flatpak file provided." --width=350
    exit 1
fi

TARGET="$1"

# Strip out browser or system protocol schemas if present
TARGET="${TARGET#flatpak+}"
TARGET="${TARGET#file://}"

# Extract the pure App ID (e.g., io.github.juancarlosbernal.FolderPlay)
CLEAN_ID=$(basename "$TARGET")
CLEAN_ID="${CLEAN_ID%.flatpakref}"
CLEAN_ID="${CLEAN_ID%.flatpak}"

# Extract a beautiful, human-friendly app name (e.g., FolderPlay)
DISPLAY_NAME="${CLEAN_ID##*.}"
[ -z "$DISPLAY_NAME" ] && DISPLAY_NAME="$CLEAN_ID"

# 2. Prompt user confirmation before initiating download bandwidth
zenity --question --title="Confirm Flatpak Installation" --text="Are you sure you want to install <b>$DISPLAY_NAME</b>?\n\nThis will safely configure a secure sandbox environment and fetch any missing runtime dependencies." --width=420
if [ $? -ne 0 ]; then
    exit 0
fi

# 3. CHOOSE INSTALLATION SCOPE
INSTALL_TYPE=$(zenity --list --radiolist --title="Installation Scope" --text="How would you like to install <b>$DISPLAY_NAME</b>?" --width=600 --height=350 --column="Select" --column="Scope" --column="Description" TRUE "User" "Install only for your individual user account" FALSE "System" "Install system-wide for all users (Requires Authorization)")

if [ $? -ne 0 ] || [ -z "$INSTALL_TYPE" ]; then
    echo "Installation cancelled by user."
    exit 0
fi

if [ "$INSTALL_TYPE" = "System" ]; then
    SCOPE_FLAG=""
    REMOTE_FLAG=""
else
    SCOPE_FLAG="--user"
    REMOTE_FLAG="--user"
fi

# 4. SMART INTERCEPTOR: CHECK IF ALREADY INSTALLED
if flatpak info $SCOPE_FLAG "$CLEAN_ID" >/dev/null 2>&1; then
    zenity --info --title="Already Installed" --text="<b>$DISPLAY_NAME</b> is already installed inside your chosen environment." --width=380
    exit 0
fi

# 5. Guard: Ensure the chosen environment has the Flathub remote repository added
if ! flatpak remotes $REMOTE_FLAG | grep -q "flathub"; then
    zenity --question --title="Flathub Repository Required" --text="Flathub is required to download this application in this scope.\n\nWould you like to automatically configure Flathub now?" --width=400
    if [ $? -eq 0 ]; then
        flatpak remote-add $REMOTE_FLAG --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    else
        exit 0
    fi
fi

# Create a temporary log file to catch any runtime pipeline errors safely
INSTALL_LOG=$(mktemp)

# ==========================================
# 6. CARRIAGE-RETURN TRANSLATION & LIVE STREAM
# ==========================================
# Added --noninteractive to suppress multiple text confirmation requests
flatpak install $SCOPE_FLAG -y --noninteractive "$TARGET" 2>&1 | tr '\r' '\n' | tee "$INSTALL_LOG" | while read -r line; do
    [ -z "$line" ] && continue
    
    # Catch streaming percentages (e.g., "Downloading... 45%")
    if [[ "$line" =~ ([0-9]+)% ]]; then
        PERCENT="${BASH_REMATCH[1]}"
        
        STATUS_TEXT="Downloading remote files..."
        if [[ "$line" == *"Installing"* || "$line" == *"installing"* ]]; then
            STATUS_TEXT="Writing sandbox containers to disk..."
        elif [[ "$line" == *"Checking"* ]]; then
            STATUS_TEXT="Verifying security signatures..."
        fi
        
        echo "$PERCENT"
        echo "# $STATUS_TEXT ($PERCENT%)"
        
    elif [[ "$line" == *"Receiving"* || "$line" == *"Downloading"* ]]; then
        echo "# Fetching application data..."
    elif [[ "$line" == *"Installing"* ]]; then
        echo "# Unpacking runtime components..."
    fi
done | zenity --progress --title="Flatpak Installer" --text="Connecting to download mirrors..." --percentage=0 --auto-close --no-cancel --width=470

INSTALL_EXIT_STATUS=${PIPESTATUS[0]}

# ==========================================
# 7. POST-INSTALL CHECK & VALIDATION
# ==============================================
if [ $INSTALL_EXIT_STATUS -eq 0 ]; then
    zenity --info --title="Success" --text="<b>$DISPLAY_NAME</b> has been installed cleanly and added to your Application Menu!" --width=380
    rm -f "$INSTALL_LOG"
    exit 0
else
    ERROR_MSG=$(grep -i "error:" "$INSTALL_LOG" | tail -n 1)
    if [ -z "$ERROR_MSG" ]; then
        ERROR_MSG=$(cat "$INSTALL_LOG" | tail -n 2)
    fi
    rm -f "$INSTALL_LOG"
    
    zenity --error --title="Installation Failed" --text="The Flatpak system engine ran into an error during runtime configuration.\n\n<b>Details:</b>\n<i>$ERROR_MSG</i>" --width=420
    exit 1
fi
