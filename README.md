# Flatpak Progress Installer

![Project Preview](preview.png)

A native graphical user interface wrapper built to capture and stream real-time installation progress data out of the Linux Flatpak ecosystem into clean desktop dialogues.

## Motivation
I developed this tool out of personal necessity. I frequently found that standard graphical software managers sometimes struggled to process specific Flatpak installations or .flatpakref files consistently.

While I appreciate the convenience of large software centers, I wanted a lightweight solution that offered the reliability of a terminal installation combined with the visual feedback of a GUI. This project was born from my desire to bridge that gap—providing a transparent, real-time progress view for installations without the overhead of a full software manager.

This tool is built for users who want to know exactly what is happening under the hood during their Flatpak setup.

## 🌐 Compatibility & Requirements
Compatibility: 100% Cross-Distribution (Works on MX Linux, Ubuntu, Debian, Fedora, Arch, openSUSE, etc.)

Dependencies: Before running the script, ensure you have flatpak and zenity installed via your system's package manager:

* **Debian / Ubuntu / MX Linux:** `sudo apt install flatpak zenity`
  
* **Fedora:** `sudo dnf install flatpak zenity`
  
* **Arch Linux:** `sudo pacman -S flatpak zenity`

## 🚀 Quick Installation
Open your terminal, clone this repository, and run the automated installation script:

~~~Bash
git clone https://github.com/cybermaxpower/flatpak-progress-installer.git
cd flatpak-progress-installer
chmod +x install.sh
./install.sh
~~~

## 💡 How to Use
In Your Browser (Brave/Firefox/Chrome): Go to (Flathub)[https://flathub.org], click Install on any app, and select Open xdg-open when prompted.

In Your File Manager (Nemo/Files): Double-click any downloaded .flatpakref or .flatpak file.

## 📄 License
This project is open-source and available under the MIT License.




