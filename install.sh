#! /usr/bin/env bash

setup() {
    sudo pacman -Syu

    sudo pacman -S \
        hyprland hyprshutdown hyprlock hypridle libnotify \
        waybar swww rofi-wayland \
        kitty zsh sddm \
        pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber \
        blueman \
        thunar
}

create_configs() {
    # SDDM theme

    sudo rm -r /usr/share/sddm/themes/ronin
    sudo cp -r $(pwd)/ronin /usr/share/sddm/themes/ronin
    sudo cp -r $(pwd)/assets/fonts /usr/share/sddm/themes/ronin/fonts
    sudo cp -r $(pwd)/assets/images /usr/share/sddm/themes/ronin/images

    # Kitty theme

    rm -r $HOME/.config/kitty 2> /dev/null
    ln -sf $(pwd)/kitty $HOME/.config/kitty

    # Hyprland configs

    rm -r $HOME/.config/hypr 2> /dev/null
    ln -sf $(pwd)/hypr $HOME/.config/hypr

    # Waybar configs

    rm -r $HOME/.config/waybar 2> /dev/null
    ln -sf $(pwd)/waybar $HOME/.config/waybar

    # NeoVim configs

    rm -r $HOME/.config/nvim 2> /dev/null
    ln -sf $(pwd)/nvim $HOME/.config/nvim
}

main() {
    local can_setup=0

    while [ "$1" != "" ]; do
        case $1 in
            -s|--setup)
                can_setup=1
                ;;
        esac
        shift
    done

    ((can_setup)) && setup
    create_configs
}

main "$@"
