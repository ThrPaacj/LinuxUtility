#!/bin/bash

install_yay(){
if ! command_exists yay; then
    printf "%b\n" "${YELLOW}Installazione di Yay in corso...${RC}"
    sudo pacman -S --needed --noconfirm base-devel git
    cd /opt && sudo git clone https://aur.archlinux.org/yay-bin.git && sudo chown -R "$USER": ./yay-bin
    cd yay-bin && makepkg --noconfirm -si
    printf "%b\n" "${GREEN}Yay installato con successo!${RC}"
else
    printf "%b\n" "${GREEN}Yay già presente nel tuo sistema!${RC}"
fi
}

command_exists() {
for cmd in "$@"; do
    export PATH="$HOME/.local/share/flatpak/exports/bin:/var/lib/flatpak/exports/bin:$PATH"
    command -v "$cmd" >/dev/null 2>&1 || return 1
done
return 0
}

install_dependencies() {
    install_yay
    printf ""
    printf "Hai un PC fisso o un portatile?"
    select tipo in "Fisso" "Portatile"; do
        case $tipo in
            "Fisso")
                printf "Configurazione per PC fisso..."
                break
                ;;
            "Portatile")
                printf "Configurazione per portatile..."
                laptop=true
                break
                ;;
            *)
                printf "Seleziona una delle opzioni (1 o 2)."
                ;;
        esac
    done

    printf "Aggiornamento del sistema..."
    yay -Syu --noconfirm

    printf "Installazione pacchetti base di Hyprland..."
    yay -S --noconfirm \
        hyprland \
        hyprpaper \
        hyprlock \
        waybar \
        fastfetch \
        speedtest-cli \
        xdg-desktop-portal-hyprland \
        xdg-utils \
        wl-clipboard \
        kitty \
        micro \
        network-manager-applet \
        grim \
        slurp \
        mako \
        visual-studio-code-bin \
        vesktop-bin \
        rustdesk-bin \
        ttf-jetbrains-mono \
        ttf-jetbrains-mono-nerd \
        otf-font-awesome \        
        curl \
        mako \
        foot \
        nemo \
        nemo-image-converter \
        nemo-fileroller \
        mpv \
        imv \
        pamixer \
        xdg-user-dirs \
        polkit-gnome \
        trash-cli \ 
        gvfs \
        nwg-look \
        nwg-displays \
        bash-completion \
        zoxide \
        papirus-icon-theme \
        tofi \
        telegram-desktop \
        spotify-launcher \
        btop \
        
    if [ "$laptop" = true ]; then
        printf "Installazione pacchetti aggiuntivi per portatile..."
        yay -S --noconfirm \
            brightnessctl \
            batsignal \
            hypridle \
            batsignal \
            blueman \
            wlsunset \

        printf "Installazione completata."
    fi
    
    printf "Creo le cartelle di sistema..."
    xdg-user-dirs-update

    # Scelta e installazione display manager
    echo ""
    echo "Quale display manager vuoi installare?"
    select dm in "GDM" "SDDM" "LY" "Nessuno"; do
        case $dm in
            "GDM")
                echo "Installazione di GDM..."
                yay -S --noconfirm gdm
                sudo systemctl enable gdm
                break
                ;;
            "SDDM")
                echo "Installazione di SDDM..."
                yay -S --noconfirm sddm
                sudo systemctl enable sddm
                break
                ;;
            "LY")
                echo "Installazione di LY..."
                yay -S --noconfirm ly
                sudo systemctl enable ly
                break
                ;;
            "Nessuno")
                echo "Nessun display manager sarà installato."
                break
                ;;
            *)
                echo "Seleziona una delle opzioni valide (1-4)."
                ;;
        esac
    done


}

download_github() {
    echo ""
    echo "Da quale repository vuoi scaricare la configurazione? (Nicola, Luca, Annulla)"
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
                echo "Download configurazione annullato."
                return
                ;;
            *)
                echo "Seleziona una delle opzioni valide (1-3)."
                ;;
        esac
    done

    echo "Clonazione da $REPO_URL..."
    TEMP_DIR=$(mktemp -d)
    git clone "$REPO_URL" "$TEMP_DIR"

    echo "Copio i file di configurazione in ~/.config..."
    cp -r "$TEMP_DIR"/* ~/.config/

    echo "Pulizia..."
    rm -rf "$TEMP_DIR"

    echo "Configurazione copiata con successo."
}

update_environment (){
    echo ""
    echo "Quale GPU possiedi?"
    select gpu in "AMD" "Intel" "NVIDIA"; do
        case $gpu in
            "AMD")
                echo "Installazione driver per AMD..."
                yay -S --noconfirm mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon
                break
                ;;
            "Intel")
                echo "Installazione driver per Intel..."
                yay -S --noconfirm mesa lib32-mesa vulkan-intel lib32-vulkan-intel
                break
                ;;
            "NVIDIA")
                echo "Installazione driver per NVIDIA..."
                yay -S --noconfirm nvidia-utils nvidia-dkms lib32-nvidia-utils linux-lts-headers
                break
                ;;
            *)
                echo "Seleziona una delle opzioni valide (1-3)."
                ;;
        esac
    done

}


# Menu principale
while true; do
    printf "\n"
    printf "======== MENU DI CONFIGURAZIONE ========\n"
    printf "1) Installa yay, Hyprland e pacchetti base\n"
    printf "2) Installa yay (AUR helper)\n"
    printf "3) Scarica config da GitHub\n"
    printf "4) Aggiorna variabili di sistema\n"
    printf "5) Esci\n"
    printf "========================================\n"
    read -rp "Scegli un'opzione [1-5]: " choice

    case $choice in
        1) install_dependencies ;;
        2) install_yay ;;
        3) download_git ;;
        4) update_environment ;;
        3) printf "Uscita..."; exit 0 ;;
        *) printf "Opzione non valida." ;;
    esac
done