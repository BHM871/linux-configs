#! /usr/bin/env bash

find_program() {
    echo $1 | awk '/'$2'/ { print "MATCH" }'
}

setup() {
    local programs=$1
    local verbose=$2

    echo -e "Installing requirements..."

    sudo pacman -Syu


    # SDDM install
    if [[ "$(find_program $programs "sddm")" == "MATCH" ]]; then

        (($verbose)) && echo "Installing SDDM..."

        sudo pacman -S sddm
    fi


    # Kitty install
    if [[ "$(find_program $programs "kitty")" == "MATCH" ]]; then

        (($verbose)) && echo "Installing Kitty Terminal Emulator..."

        sudo pacman -S kitty
    fi


    # ZShell install
    if [[ "$(find_program $programs "zsh")" == "MATCH" ]]; then

        (($verbose)) && echo "Installing ZShell..."

        sudo pacman -S git zsh
    fi


    # Hyprland install
    if [[ "$(find_program $programs "hyprland")" == "MATCH" ]]; then

        (($verbose)) && echo "Installing Hyprland configs..."

        sudo pacman -S \
            hyprland hyprshutdown hyprlock hypridle \
            libnotify swww rofi-wayland dex \
            pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber \
            blueman thunar git base-devel
    fi


    # Waybar install
    if [[ "$(find_program $programs "waybar")" == "MATCH" ]]; then

        (($verbose)) && echo "Installing Waybar..."

        sudo pacman -S \
            waybar hyprshutdown \
            libnotify rofi-wayland \
            pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber \
            blueman
    fi


    # NeoVim install
    if [[ "$(find_program $programs "nvim")" == "MATCH" ]]; then

        (($verbose)) && echo "Installing NeoVim..."

        sudo pacman -S git nvim
    fi
}



create_configs() {
    local programs=$1
    local verbose=$2

    echo -e "Linking configurations..."


    # SDDM theme
    if [[ "$(find_program $programs "sddm")" == "MATCH" ]]; then

        which sddm &> /dev/null
        installed=$?

        if [[ $installed -eq 0 ]]; then
            (($verbose)) && echo "Setupping SDDM Ronin theme..."

            sudo mkdir -p /usr/share/sddm/themes       &> /dev/null
            sudo rm -r    /usr/share/sddm/themes/ronin &> /dev/null

            sudo cp -r $(pwd)/ronin         /usr/share/sddm/themes/ronin
            sudo cp -r $(pwd)/assets/fonts  /usr/share/sddm/themes/ronin/fonts
            sudo cp -r $(pwd)/assets/images /usr/share/sddm/themes/ronin/images
        else
            echo "SDDM isn't installed"
        fi
    fi


    # Fonts configs
    if [[ "$(find_program $programs "fonts")" == "MATCH" ]]; then

        (($verbose)) && echo "Setupping fonts..."

        mkdir -p $HOME/.local/share/fonts
        cp $(pwd)/assets/fonts/* $HOME/.local/share/fonts/
    fi


    # Kitty theme
    if [[ "$(find_program $programs "kitty")" == "MATCH" ]]; then

        which kitty &> /dev/null
        installed=$?

        if [[ $installed -eq 0 ]]; then
            (($verbose)) && echo "Setupping kitty theme..."

            rm -r $HOME/.config/kitty 2> /dev/null
            ln -sf $(pwd)/kitty $HOME/.config/kitty
        else
            echo "Kitty isn't installed"
        fi
    fi


    # ZShell theme
    if [[ "$(find_program $programs "zsh")" == "MATCH" ]]; then

        which zsh &> /dev/null
        installed=$?

        if [[ $installed -eq 0 ]]; then
            (($verbose)) && echo "Setupping ZShell theme..."

            cp $(pwd)/zsh/.zshrc            $HOME/
            cp $(pwd)/zsh/.zsh_variables    $HOME/
            cp $(pwd)/zsh/.zsh_aliases      $HOME/
            cp $(pwd)/zsh/.p10k.zsh         $HOME/
        else
            echo "ZShell isn't installed"
        fi
    fi


    # Hyprland configs
    if [[ "$(find_program $programs "hyprland")" == "MATCH" ]]; then
        which start_hyprland &> /dev/null
        installed=$?

        if [[ $installed -eq 0 ]]; then
            (($verbose)) && echo "Setupping Hyprland configs..."

            rm -r $HOME/.config/hypr/images $HOME/.config/hypr/scripts $HOME/.config/hypr/styles 2> /dev/null
            rm -r $HOME/.config/hypr 2> /dev/null

            ln -sf $(pwd)/hypr          $HOME/.config/hypr

            ln -sf $(pwd)/assets/images $HOME/.config/hypr/images
            ln -sf $(pwd)/scripts       $HOME/.config/hypr/scripts
            ln -sf $(pwd)/styles        $HOME/.config/hypr/styles
        else
            echo "Hyprland isn't installed"
        fi
    fi


    # Waybar configs
    if [[ "$(find_program $programs "waybar")" == "MATCH" ]]; then

        which waybar &> /dev/null
        installed=$?

        if [[ $installed -eq 0 ]]; then
            (($verbose)) && echo "Setupping Waybar configs..."

            rm -r $HOME/.config/waybar/scripts $HOME/.config/waybar/styles 2> /dev/null
            rm -r $HOME/.config/waybar 2> /dev/null

            ln -sf $(pwd)/waybar    $HOME/.config/waybar

            ln -sf $(pwd)/scripts   $HOME/.config/waybar/scripts
            ln -sf $(pwd)/styles    $HOME/.config/waybar/styles
        else
            echo "Waybar isn't installed"
        fi
    fi


    # NeoVim configs
    if [[ "$(find_program $programs "nvim")" == "MATCH" ]]; then

        which nvim &> /dev/null
        installed=$?

        if [[ $installed -eq 0 ]]; then
            (($verbose)) && echo "Setupping NeoVim configs..."

            rm -r $HOME/.config/nvim 2> /dev/null

            ln -sf $(pwd)/nvim $HOME/.config/nvim
        else
            echo "NeoVim isn't installed"
        fi
    fi
}



configure() {
    local programs=$1
    local verbose=$2

    echo "Configuring..."


    # SDDM setup
    if [[ "$(find_program $programs "sddm")" == "MATCH" ]]; then

        which sddm &> /dev/null
        installed=$?

        if [[ $installed -eq 0 ]]; then
            (($verbose)) && echo "Setupping SDDM as Display Manager..."

            # TODO
        else
            echo "SDDM isn't installed"
        fi
    fi


    # Fonts cache
    if [[ "$(find_program $programs "fonts")" == "MATCH" ]]; then

        (($verbose)) && echo "Cleaning cache fonts..."

        fc-cache -rf
    fi


    # ZShell default
    if [[ "$(find_program $programs "zsh")" == "MATCH" ]]; then

        which zsh &> /dev/null
        installed=$?

        if [[ $installed -eq 0 ]]; then
            (($verbose)) && echo "Setupping ZShell as default shell..."

            chsh -s $(which zsh) $USER
        else
            echo "ZShell isn't installed"
        fi
    fi


    # yay install
    if [[ "$(find_program $programs "yay")" == "MATCH" ]]; then

        which git &> /dev/null
        installed=$?

        if [[ $installed -eq 0 ]]; then
            (($verbose)) && echo "Installing yay..."

            git clone https://aur.archlinux.org/yay-bin.git
            cd yay-bin && makepkg -si
            cd .. && rm -r yay-bin

            yay -Y --gendb
        else
            echo "git is needed to install yay"
        fi
    fi
}



programs_options="sddm,kitty,zsh,fonts,hyprland,waybar,nvim,yay"
print_help() {
    echo -e ""
    echo -e "Usage:"
    echo -e "   ./install.sh [OPTIONS]"
    echo -e ""
    echo -e "This is a basic theme installer"
    echo -e ""
    echo -e "Options:"
    echo -e "   -p, --programs <programs>   Define which programs will be installed and configured."
    echo -e "                                   Atual options: $programs_options"
    echo -e "   -s, --setup                 Define if programs will be installed before configure."
    echo -e "   -c, --configure             Define if additioanl configurations will be do."
    echo -e "                                   For exemple: Clean fonts cache, configure yay, define SDDM default, etc."
    echo -e ""
    echo -e "   -sp <programs>              Define programs and execute setup."
    echo -e "   -cp <programs>              Define programs and configure."
    echo -e "   -scp <programs>             Define programs, setup and configure."
    echo -e ""
    echo -e "   -h, --help"
    echo -e "   -v, --verbose"
}



main() {
    local programs="$programs_options"
    local can_setup=0
    local can_configure=0
    local verbose=0
    local print_help=0

    while [ "$1" != "" ]; do
        case $1 in
            -p|--programs)
                shift
                programs="$(echo "$1" | awk '{ print tolower($0) }')"
                ;;
            -s|--setup)
                can_setup=1
                ;;
            -c|--configure)
                can_configure=1
                ;;
            -sp)
                shift
                programs="$(echo "$1" | awk '{ print tolower($0) }')"
                can_setup=1
                ;;
            -cp)
                shift
                programs="$(echo "$1" | awk '{ print tolower($0) }')"
                can_configure=1
                ;;
            -scp)
                shift
                programs="$(echo "$1" | awk '{ print tolower($0) }')"
                can_setup=1
                can_configure=1
                ;;
            -v|--verbose)
                verbose=1
                ;;
            -h|--help)
                print_help=1
                ;;
        esac
        shift
    done

    (($print_help)) && print_help && exit 0

    (($can_setup)) && setup $programs $verbose
    create_configs $programs $verbose
    (($can_configure)) && configure $programs $verbose
}

main "$@"
