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

### 🎮 Driver GPU
- **AMD**: `mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon`
- **Intel**: `mesa lib32-mesa vulkan-intel lib32-vulkan-intel`
- **NVIDIA**: `nvidia-utils nvidia-dkms lib32-nvidia-utils linux-lts-headers`

## 🚀 Come usare lo script

### Prerequisiti
- Arch Linux (o derivate)
- Utente non-root con privilegi sudo
- Connessione internet

### Esecuzione
```bash
chmod +x utility_with_GUI.sh
./utility_with_GUI.sh
```

### Menu principale
1. **Installa tutto**: yay + Hyprland + pacchetti base
2. **Installa solo yay**: Solo AUR helper
3. **Scarica configurazioni**: Configurazioni predefinite da GitHub
4. **Configura GPU**: Installazione driver grafici
5. **Esci**: Termina lo script

## 🔧 Funzioni dettagliate

### `install_yay()`
- Verifica se yay è già installato
- Installa le dipendenze necessarie (`base-devel`, `git`)
- Clona e compila yay dall'AUR
- Gestione errori con messaggi chiari

### `install_dependencies()`
1. **Selezione tipo dispositivo** (fisso/portatile)
2. **Aggiornamento sistema**
3. **Installazione pacchetti base**
4. **Installazione pacchetti specifici per portatili**
5. **Scelta display manager**:
   - GDM, SDDM o LY
   - Abilitazione automatica del servizio
6. **Creazione cartelle utente**

### `download_github()`
- Scelta tra repository di configurazione:
  - Nicola: `https://github.com/TheShotMan05/dots`
  - Luca: `https://github.com/ThrPaacj/dots`
- Copia automatica in `~/.config`
- Pulizia file temporanei

### `update_environment()`
- Rilevamento GPU:
  - AMD: driver open-source
  - Intel: driver Vulkan
  - NVIDIA: driver proprietari
- Installazione automatica pacchetti appropriati

## 🎨 Interfaccia utente

- **Linee decorative** per separare le sezioni
- **Testo centrato** per un aspetto ordinato
- **Sistema di colori**:
  - ✅ Verde: operazioni riuscite
  - ❌ Rosso: errori
  - ℹ️ Blu: informazioni
  - 💛 Giallo: avvisi
  - 🟣 Viola: intestazioni

## 💡 Suggerimenti

1. Per problemi con NVIDIA:
   - Verifica di avere i kernel headers corretti
   - Riavvia dopo l'installazione

2. Le configurazioni scaricate sovrascrivono:
   - File esistenti in `~/.config`

3. Su portatili:
   - `brightnessctl` per gestire la luminosità
   - `batsignal` per monitorare la batteria

## 🐛 Risoluzione problemi

**Problema**: Fallimento installazione yay  
**Soluzione**: Verifica di avere `base-devel` installato

**Problema**: Errori GPU  
**Soluzione**: Riavvia e verifica i driver con:
```bash
glxinfo | grep "OpenGL renderer"
```

**Problema**: Configurazioni mancanti  
**Soluzione**: Controlla i permessi in `~/.config`

## 🤝 Contributi

I contributi sono benvenuti! Aree di miglioramento:
- Aggiunta di nuovi repository di configurazione
- Supporto per più driver GPU
- Miglioramenti all'interfaccia

## 📜 Licenza

MIT License - Vedi [LICENSE](LICENSE) per dettagli

---

> **Nota**: Questo script è ottimizzato per Arch Linux. Potrebbe richiedere adattamenti per altre distribuzioni.
