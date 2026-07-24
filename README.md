# 📦 Flatpak Progress Installer

![Project Preview](preview.png)



A lightweight, native Linux GUI utility that intercepts Flatpak protocol links, `.flatpakref` downloads, and standalone bundles, turning console output into a smooth real-time **Zenity** progress bar.

Designed to seamlessly bridge the gap between web browsers (like Brave, Firefox, and Chrome) and your desktop environment without hiding download/installation progress in a hidden terminal.

---

## ✨ Features

* **Real-Time Visual Feedback:** Translates Flatpak's carriage-return (`\r`) terminal stream into a clean, dynamic Zenity percentage bar.
* **Dual Installation Scope:** Pick between installing applications **Per-User** (no root required) or **System-Wide** on the fly.
* **Non-Interactive & Silent:** Automatically manages runtime dependencies (e.g., GNOME/Mesa platforms) without freezing or asking for duplicate terminal confirmations.
* **Smart Remote Detection:** Auto-checks if the Flathub repository is configured in your chosen scope and offers one-click setup if missing.
* **Clean System Integration:** Includes dedicated installation and uninstallation scripts that manage user-level MIME types and `.desktop` launchers cleanly.

---

## 📋 Prerequisites

Make sure your system has the following installed (pre-installed on most GTK-based distributions like MX Linux, Mint, Ubuntu, or Debian):

* `bash`
* `flatpak`
* `zenity`
* `xdg-utils`

---

## 🚀 Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/flatpak-progress-installer.git
   cd flatpak-progress-installer
   ```

2. **Run the installer script:**
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

The setup script will deploy the engine to `/usr/local/bin/`, create the desktop launcher entry, and assign your local user account as the default handler for all Flatpak web triggers and file types.

---

## 🖥️ How It Works

Once installed, **Flatpak Progress Installer** works automatically in the background:

1. **Web Links:** Click **Install** on [Flathub](https://flathub.org). Your browser will prompt to open the link using *Flatpak Progress Installer*.
2. **Local Files:** Double-click any downloaded `.flatpakref` or `.flatpak` bundle file in your file manager.
3. **Execution Flow:**
   * Prompts you to confirm installation.
   * Asks whether to install for **User** or **System**.
   * Opens a native GTK progress bar tracking real-time download and extraction progress.
   * Displays a success notification when ready in your Application Menu!

---

## 🔍 Troubleshooting Handler Issues

If your browser stops launching the installer when clicking Flathub buttons:

1. **Check which app currently owns the Flatpak MIME type:**
   ```bash
   xdg-mime query default application/vnd.flatpak.ref
   ```
   *(It should output `flatpak-progress-installer.desktop`)*

2. **Re-assert user defaults:**
   Simply re-run `./install.sh` at any time to repair your desktop launcher and MIME associations.

3. **Brave / Chromium Protocol Handler Reset:**
   Navigate to `brave://settings/handlers` in your browser and ensure **"Sites can ask to handle protocols"** is enabled, and no `flatpak` schemas are marked as blocked.

---

## 🗑️ Uninstallation

To completely remove the installer, binary, desktop launcher, and associated MIME entries, run:

```bash
chmod +x uninstall.sh
./uninstall.sh
```

> **Tip:** You can pass the `-y` flag to skip the confirmation prompt in automated scripts:
> ```bash
> ./uninstall.sh -y
> ```

---

## ⚖️ Warranty & Liability Disclaimer

### No Warranty ("As-Is" Software)
This software is provided completely **"as-is"** without warranty of any kind, either express or implied. The author makes no guarantees regarding its functionality, stability, or suitability for any specific purpose.

### Limitation of Liability
* **Use at Your Own Risk:** The developer assumes no liability for any system issues, data loss, or hardware damages that may occur from installing, executing, or removing software through this utility.
* **User Responsibility:** Uninstalling Flatpak containers can permanently erase local application data, configurations, or user settings linked to those environments. It is your absolute responsibility to double-check and verify all actions before confirmation.
