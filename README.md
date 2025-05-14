# Hyprland Configuration Tool

![Bash](https://img.shields.io/badge/Shell-Bash-4EAA25?logo=gnu-bash)
![Arch Linux](https://img.shields.io/badge/OS-Arch_Linux-1793D1?logo=arch-linux)
![Hyprland](https://img.shields.io/badge/WM-Hyprland-4455BB)

Uno script Bash completo per configurare Hyprland su Arch Linux con interfaccia utente intuitiva e colorata.

## 📋 Panoramica

Questo script automatizza l'installazione e la configurazione di:
- Hyprland (compositor Wayland)
- Tutti i pacchetti essenziali
- Driver GPU specifici
- Display manager a scelta
- Configurazioni predefinite

## 🛠️ Funzionalità principali

1. **Installazione automatica di yay** (AUR helper)
2. **Configurazione completa di Hyprland**
3. **Supporto per hardware diverso**:
   - PC fissi e portatili
   - GPU AMD/Intel/NVIDIA
4. **Download configurazioni** da repository GitHub
5. **Interfaccia utente intuitiva** con:
   - Menu interattivi
   - Messaggi colorati
   - Feedback visivo

## 📦 Pacchetti installati

### 🧰 Pacchetti base (installati sempre)
```plaintext
hyprland firefox hyprpaper hyprlock waybar fastfetch speedtest-cli
xdg-desktop-portal-hyprland xdg-utils wl-clipboard kitty micro
network-manager-applet grim slurp mako visual-studio-code-bin
vesktop-bin rustdesk-bin ttf-jetbrains-mono ttf-jetbrains-mono-nerd
otf-font-awesome curl foot nemo nemo-image-converter nemo-fileroller
mpv imv pamixer xdg-user-dirs polkit-gnome trash-cli gvfs nwg-look
nwg-displays bash-completion zoxide papirus-icon-theme tofi
telegram-desktop spotify-launcher btop uwsm pavucontrol
```

### 💻 Pacchetti aggiuntivi per portatili
```plaintext
brightnessctl batsignal hypridle blueman wlsunset
```

### 🖥️ Display Manager (a scelta)
```plaintext
GDM | SDDM | LY | Nessuno
```
