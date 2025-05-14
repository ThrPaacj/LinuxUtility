#!/bin/bash

# Colori
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
RC='\033[0m' # Reset Color

# Variabili globali
laptop=false
TEMP_DIR=$(mktemp -d)
WIDTH=60

# Funzione per disegnare una linea orizzontale
draw_line() {
    printf "%${WIDTH}s\n" | tr ' ' '='
}

# Funzione per centrare il testo
center_text() {
    local text="$1"
    local width=$WIDTH
    local padding=$(( (width - ${#text}) / 2 ))
    printf "%${padding}s" ''
    printf "%s\n" "$text"
}

# Funzione per mostrare un messaggio di successo
success_msg() {
    echo -e "${GREEN}✓ $1${RC}"
}

# Funzione per mostrare un messaggio di errore
error_msg() {
    echo -e "${RED}✗ $1${RC}"
}

# Funzione per mostrare un messaggio informativo
info_msg() {
    echo -e "${BLUE}➜ $1${RC}"
}

# Funzione per verificare l'esistenza di un comando
command_exists() {
    for cmd in "$@"; do
        export PATH="$HOME/.local/share/flatpak/exports/bin:/var/lib/flatpak/exports/bin:$PATH"
        command -v "$cmd" >/dev/null 2>&1 || return 1
    done
    return 0
}

# Funzione per installare yay
install_yay() {
    draw_line
    center_text "INSTALLAZIONE DI YAY"
    draw_line
    
    if command_exists yay; then
        success_msg "Yay è già installato nel sistema!"
        return 0
    fi
    
    info_msg "Installazione di Yay in corso..."
    
    if ! sudo pacman -S --needed --noconfirm base-devel git; then
        error_msg "Fallita installazione delle dipendenze per Yay!"
        return 1
    fi
    
    if ! cd /opt || ! sudo git clone https://aur.archlinux.org/yay-bin.git || ! sudo chown -R "$USER": ./yay-bin; then
        error_msg "Fallita clonazione del repository Yay!"
        return 1
    fi
    
    if ! cd yay-bin || ! makepkg --noconfirm -si; then
        error_msg "Fallita compilazione di Yay!"
        return 1
    fi
    
    success_msg "Yay installato con successo!"
    return 0
}

# Funzione per installare le dipendenze
install_dependencies() {
    draw_line
    center_text "INSTALLAZIONE PACCHETTI BASE"
    draw_line
    
    # Installazione Yay se non presente
    if ! command_exists yay; then
        install_yay || return 1
    fi
    
    # Selezione tipo PC
    echo -e "${CYAN}"
    PS3="Seleziona il tipo di dispositivo (1-2): "
    select tipo in "Fisso" "Portatile"; do
        case $tipo in
            "Fisso")
                info_msg "Configurazione per PC fisso selezionata"
                laptop=false
                break
                ;;
            "Portatile")
                info_msg "Configurazione per portatile selezionata"
                laptop=true
                break
                ;;
            *)
                error_msg "Selezione non valida. Riprova."
                ;;
        esac
    done
    echo -e "${RC}"
    
    # Aggiornamento sistema
    info_msg "Aggiornamento del sistema in corso..."
    if ! yay -Syu --noconfirm; then
        error_msg "Fallito aggiornamento del sistema!"
        return 1
    fi
    
    # Installazione pacchetti base
    info_msg "Installazione pacchetti base di Hyprland..."
    local base_packages=(
        hyprland hyprpaper hyprlock waybar fastfetch speedtest-cli
        xdg-desktop-portal-hyprland xdg-utils wl-clipboard kitty micro
        network-manager-applet grim slurp mako visual-studio-code-bin
        vesktop-bin rustdesk-bin ttf-jetbrains-mono ttf-jetbrains-mono-nerd
        otf-font-awesome curl foot nemo nemo-image-converter nemo-fileroller
        mpv imv pamixer xdg-user-dirs polkit-gnome trash-cli gvfs nwg-look
        nwg-displays bash-completion zoxide papirus-icon-theme tofi
        telegram-desktop spotify-launcher btop uwsm
    )
    
    if ! yay -S --noconfirm "${base_packages[@]}"; then
        error_msg "Fallita installazione pacchetti base!"
        return 1
    fi
    
    # Pacchetti aggiuntivi per portatile
    if [ "$laptop" = true ]; then
        info_msg "Installazione pacchetti aggiuntivi per portatile..."
        local laptop_packages=(
            brightnessctl batsignal hypridle blueman wlsunset
        )
        
        if ! yay -S --noconfirm "${laptop_packages[@]}"; then
            error_msg "Fallita installazione pacchetti portatile!"
            return 1
        fi
    fi
    
    # Creazione cartelle di sistema
    info_msg "Creazione cartelle di sistema..."
    if ! xdg-user-dirs-update; then
        error_msg "Fallita creazione cartelle di sistema!"
    fi
    
    # Selezione display manager
    echo -e "${CYAN}"
    PS3="Seleziona il display manager da installare (1-4): "
    select dm in "GDM" "SDDM" "LY" "Nessuno"; do
        case $dm in
            "GDM"|"SDDM"|"LY")
                info_msg "Installazione di $dm in corso..."
                if yay -S --noconfirm "${dm,,}"; then
                    sudo systemctl enable "${dm,,}"
                    success_msg "$dm installato e abilitato con successo!"
                else
                    error_msg "Fallita installazione di $dm!"
                fi
                break
                ;;
            "Nessuno")
                info_msg "Nessun display manager verrà installato."
                break
                ;;
            *)
                error_msg "Selezione non valida. Riprova."
                ;;
        esac
    done
    echo -e "${RC}"
    
    success_msg "Installazione completata con successo!"
    return 0
}

# Funzione per scaricare configurazioni da GitHub
download_github() {
    draw_line
    center_text "DOWNLOAD CONFIGURAZIONI"
    draw_line
    
    echo -e "${CYAN}"
    PS3="Seleziona il repository da cui scaricare (1-3): "
    select autore in "Nicola" "Luca" "Annulla"; do
        case $autore in
            "Nicola")
                REPO_URL="https://github.com/TheShotMan05/dots"
                break
                ;;
            "Luca")
                REPO_URL="https://github.com/ThrPaacj/dots"
                break
                ;;
            "Annulla")
                info_msg "Operazione annullata."
                return
                ;;
            *)
                error_msg "Selezione non valida. Riprova."
                ;;
        esac
    done
    echo -e "${RC}"
    
    info_msg "Clonazione da $REPO_URL..."
    if ! git clone "$REPO_URL" "$TEMP_DIR"; then
        error_msg "Fallita clonazione del repository!"
        return 1
    fi
    
    info_msg "Copia dei file di configurazione in ~/.config..."
    if ! cp -r "$TEMP_DIR"/* ~/.config/; then
        error_msg "Fallita copia dei file di configurazione!"
        return 1
    fi
    
    info_msg "Pulizia dei file temporanei..."
    rm -rf "$TEMP_DIR"
    
    success_msg "Configurazione copiata con successo!"
    return 0
}

# Funzione per aggiornare l'ambiente in base alla GPU
update_environment() {
    draw_line
    center_text "CONFIGURAZIONE GPU"
    draw_line
    
    echo -e "${CYAN}"
    PS3="Seleziona il tipo di GPU (1-3): "
    select gpu in "AMD" "Intel" "NVIDIA"; do
        case $gpu in
            "AMD")
                info_msg "Installazione driver per AMD..."
                packages=(mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon)
                break
                ;;
            "Intel")
                info_msg "Installazione driver per Intel..."
                packages=(mesa lib32-mesa vulkan-intel lib32-vulkan-intel)
                break
                ;;
            "NVIDIA")
                info_msg "Installazione driver per NVIDIA..."
                packages=(nvidia-utils nvidia-dkms lib32-nvidia-utils linux-lts-headers)
                break
                ;;
            *)
                error_msg "Selezione non valida. Riprova."
                ;;
        esac
    done
    echo -e "${RC}"
    
    if ! yay -S --noconfirm "${packages[@]}"; then
        error_msg "Fallita installazione driver GPU!"
        return 1
    fi
    
    success_msg "Driver GPU installati con successo!"
    return 0
}

# Funzione per mostrare il menu principale
show_main_menu() {
    clear
    draw_line
    center_text "HYPRLAND CONFIGURATION TOOL"
    draw_line
    echo -e "${MAGENTA}"
    center_text "Scegli un'opzione:"
    echo -e "${YELLOW}"
    options=(
        "Installa yay, Hyprland e pacchetti base"
        "Installa solo yay (AUR helper)"
        "Scarica configurazioni da GitHub"
        "Configura driver GPU"
        "Esci"
    )
    
    for i in "${!options[@]}"; do
        printf "%2d) %s\n" $((i+1)) "${options[i]}"
    done
    echo -e "${RC}"
    draw_line
}

# Funzione principale
main() {
    # Verifica che siamo su Arch Linux
    if ! grep -q "Arch Linux" /etc/os-release 2>/dev/null; then
        error_msg "Questo script è solo per Arch Linux!"
        exit 1
    fi
    
    # Verifica che l'utente non sia root
    if [ "$(id -u)" -eq 0 ]; then
        error_msg "Non eseguire questo script come root!"
        exit 1
    fi
    
    # Loop del menu principale
    while true; do
        show_main_menu
        
        read -rp "Scelta [1-5]: " choice
        case $choice in
            1) install_dependencies ;;
            2) install_yay ;;
            3) download_github ;;
            4) update_environment ;;
            5) 
                info_msg "Uscita dallo script..."
                exit 0
                ;;
            *) 
                error_msg "Scelta non valida!"
                sleep 1
                ;;
        esac
        
        read -rp "Premi Invio per continuare..."
    done
}

# Esegui la funzione principale
main