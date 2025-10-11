# Flutter Installation

Anleitung für zwei häufig genutzte Entwicklungsumgebungen: ein Chromebook mit aktivierter Linux-Entwicklungsumgebung (Crostini) sowie Arch Linux mit Plasma 5 unter Wayland.

## Chromebook (ChromeOS + Crostini)

1. **Linux (Beta) aktivieren**  
   - Einstellungen → *Erweitert* → *Entwickler* → *Linux-Entwicklungsumgebung* aktivieren.  
   - Ein Standard-Container (Debian) wird eingerichtet.
2. **System aktualisieren und Grundpakete installieren**
   ```bash
   sudo apt update && sudo apt upgrade
   sudo apt install bash curl file git unzip xz-utils zip
   ```
3. **Flutter SDK laden**  
   ```bash
   cd ~
   curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.0-stable.tar.xz
   tar xf flutter_linux_3.24.0-stable.tar.xz
   ```
   - Bei neuen Releases die Versionsnummer im Download-Link anpassen (siehe https://docs.flutter.dev/release/archive).
4. **Flutter zum PATH hinzufügen**  
   ```bash
   echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
   source ~/.bashrc
   ```
5. **Abhängigkeiten für Linux-Desktop Builds (optional)**  
   ```bash
   sudo apt install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev
   ```
6. **Flutter initialisieren**  
   ```bash
   flutter doctor --android-licenses
   flutter doctor
   ```
   - Für Android-Entwicklung zusätzlich das Android SDK/Studio installieren (Download über https://developer.android.com).
7. **VS Code / IDE (optional)**  
   - Visual Studio Code im Debian-Container installieren (`sudo apt install code` aus dem Microsoft-Repository) und die Flutter- sowie Dart-Erweiterung aktivieren.

## Arch Linux (Plasma 5 + Wayland)

1. **System aktualisieren**
   ```bash
   sudo pacman -Syu
   ```
2. **Flutter und Basis-Abhängigkeiten installieren**
   - Variante A (Empfohlen, offizielles Paket):
     ```bash
     sudo pacman -S --needed flutter
     ```
   - Variante B (Manuelle Installation):
     ```bash
     cd /opt
     sudo curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.0-stable.tar.xz
     sudo tar xf flutter_linux_3.24.0-stable.tar.xz
     sudo ln -s /opt/flutter/bin/flutter /usr/local/bin/flutter
     ```
3. **Desktop-Abhängigkeiten vollständig halten**
   ```bash
   sudo pacman -S --needed bash curl git unzip xz cmake ninja pkgconf gtk3 libglvnd libgcrypt webkit2gtk lzma
   ```
4. **Wayland/Plasma Hinweise**
   - Flutter-Apps laufen unter Wayland über den XWayland-Kompatibilitätslayer; kein spezielles Flag nötig.  
   - Sicherstellen, dass Qt/GTK-Wayland-Pakete installiert sind:
     ```bash
     sudo pacman -S --needed qt5-wayland qt6-wayland gtk3
     ```
   - Beim Start eines Linux-Targets `flutter run -d linux` nutzt der Runner automatisch X11 oder Wayland je nach Umgebung.
5. **Android-Unterstützung (optional)**
   ```bash
   sudo pacman -S --needed android-tools android-udev
   ```
   - Android Studio aus dem AUR (`android-studio`) oder per JetBrains Toolbox installieren.  
   - USB-Debugging aktivieren und udev-Regeln neu laden: `sudo udevadm control --reload-rules && sudo udevadm trigger`.
6. **Flutter initialisieren**
   ```bash
   flutter doctor --android-licenses
   flutter doctor
   ```
7. **Shell-Integrationen**
   - Für manuelle Installation PATH ergänzen (`echo 'export PATH="$PATH:/opt/flutter/bin"' >> ~/.bashrc`).  
   - Unter Plasma kann das `.bashrc` bzw. `.zshrc` vom Terminal-Emulator geladen werden; bei grafischen IDEs ggf. separate PATH-Konfiguration setzen.

> **Tipp:** `flutter upgrade` hält das SDK aktuell. Nach Updates den `flutter doctor` erneut ausführen, um neue Anforderungen zu erkennen.
