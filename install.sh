#! /usr/bin/env bash

find_program() {
    echo $1 | awk '/'$2'/ { print "MATCH" }'
}

echo_bold()     { echo -e "\033[1m $1 \033[m" ; }

echo_warning()  { echo -e "\t\033[1;93m $1 \033[m" ; }

echo_good()     { echo -e "\t\033[1;92m $1 \033[m" ; }

echo_bad() {
    [[ $1 -eq 0 ]] && echo -e "\t\033[1;91m $2 \033[m"
    [[ $1 -ne 0 ]] && echo -e "\t\033[1;97;101m $2 \033[1;91;49m $3 \033[m" ;
}

setup() {
    local programs=$1
    local verbose=$2
    local some_error=0

    echo_bold "Installing requirements..."

    sudo pacman --noconfirm -Syu


    # SDDM install
    if [[ "$(find_program $programs "sddm")" == "MATCH" ]]; then

        (($verbose)) && echo "Installing SDDM..."

        sudo pacman --noconfirm -S sddm
        local stats=$?

        [[ $stats -ne 0 ]] && some_error=$stats
    fi


    # Kitty install
    if [[ "$(find_program $programs "kitty")" == "MATCH" ]]; then

        (($verbose)) && echo "Installing Kitty Terminal Emulator..."

        sudo pacman --noconfirm -S kitty
        local stats=$?

        [[ $stats -ne 0 ]] && some_error=$stats
    fi


    # ZShell install
    if [[ "$(find_program $programs "zsh")" == "MATCH" ]]; then

        (($verbose)) && echo "Installing ZShell..."

        sudo pacman --noconfirm -S git zsh
        local stats=$?

        [[ $stats -ne 0 ]] && some_error=$stats
    fi


    # Hyprland install
    if [[ "$(find_program $programs "hyprland")" == "MATCH" ]]; then

        (($verbose)) && echo "Installing Hyprland configs..."

        sudo pacman --noconfirm -S \
            hyprland hyprshutdown hyprlock hypridle \
            libnotify swww rofi-wayland dex cliphist \
            pipewire pipewire-alsa pipewire-jack pipewire-pulse pipewire-audio \
            wireplumber blueman git base-devel \
            grim slurp thunar
        local stats=$?

        [[ $stats -ne 0 ]] && some_error=$stats
    fi


    # Waybar install
    if [[ "$(find_program $programs "waybar")" == "MATCH" ]]; then

        (($verbose)) && echo "Installing Waybar..."

        sudo pacman --noconfirm -S \
            waybar hyprshutdown \
            libnotify rofi-wayland \
            pipewire pipewire-alsa pipewire-jack pipewire-pulse pipewire-audio \
            wireplumber blueman
        local stats=$?

        [[ $stats -ne 0 ]] && some_error=$stats
    fi


    # NeoVim install
    if [[ "$(find_program $programs "nvim")" == "MATCH" ]]; then

        (($verbose)) && echo "Installing NeoVim..."

        sudo pacman --noconfirm -S git nvim
        local stats=$?

        [[ $stats -ne 0 ]] && some_error=$stats
    fi

    (($verbose)) && [[ $some_error -ne 0 ]] && echo_warning "Setupped with errors!"
    (($verbose)) && [[ $some_error -eq 0 ]] && echo_good    "Setupped configs successfully!"
}



create_configs() {
    local programs=$1
    local verbose=$2
    local some_error=0

    echo_bold "Linking configurations..."


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
            some_error=1
            (($verbose)) && echo_bad 1 "sddm" "isn't installed"
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
            some_error=1
            (($verbose)) && echo_bad 1 "kitty" "isn't installed"
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
            some_error=1
            (($verbose)) && echo_bad 1 "zsh" "isn't installed"
        fi
    fi


    # Hyprland configs
    if [[ "$(find_program $programs "hyprland")" == "MATCH" ]]; then
        which start-hyprland &> /dev/null
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
            some_error=1
            (($verbose)) && echo_bad 1 "hyprland" "isn't installed"
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
            some_error=1
            (($verbose)) && echo_bad 1 "waybar" "isn't installed"
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
            some_error=1
            (($verbose)) && echo_bad 1 "nvim" "isn't installed"
        fi
    fi

    (($verbose)) && [[ $some_error -ne 0 ]] && echo_warning "Created configs with errors!"
    (($verbose)) && [[ $some_error -eq 0 ]] && echo_good    "Created configs successfully!"
}



configure() {
    local programs=$1
    local verbose=$2
    local some_error=0

    echo_bold "Configuring..."


    # SDDM setup
    if [[ "$(find_program $programs "sddm")" == "MATCH" ]]; then

        which sddm &> /dev/null
        installed=$?

        if [[ $installed -eq 0 ]]; then
            (($verbose)) && echo "Setupping SDDM as Display Manager..."

            actual_dm=$(systemctl status display-manager | awk ' NR <= 1 { print $2 } ')
            sudo systemctl disable "$actual_dm"
            sudo systemctl enable "sddm.service"
        else
            some_error=1
            (($verbose)) && echo_bad 1 "sddm" "isn't installed"
        fi
    fi


    # Fonts cache
    if [[ "$(find_program $programs "fonts")" == "MATCH" ]]; then

        (($verbose)) && echo "Cleaning cache fonts..."

        fc-cache -rf
        local stats=$?

        [[ $stats -ne 0 ]] || some_error=$stats
    fi


    # ZShell default
    if [[ "$(find_program $programs "zsh")" == "MATCH" ]]; then

        which zsh &> /dev/null
        installed=$?

        if [[ $installed -eq 0 ]]; then
            (($verbose)) && echo "Setupping ZShell as default shell..."

            chsh -s $(which zsh) $USER
        else
            some_error=1
            (($verbose)) && echo_bad 1 "zsh" "isn't installed"
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
            cd .. && rm -rf yay-bin

            echo_warning "You can execute `yay -Y --gendb` to gen yay db"
        else
            some_error=1
            (($verbose)) && echo_bad 1 "git" "is needed to install yay"
        fi
    fi

    (($verbose)) && [[ $some_error -ne 0 ]] && echo_warning "Configured with errors!"
    (($verbose)) && [[ $some_error -eq 0 ]] && echo_good    "Configured successfully!"
}



programs_options="sddm,kitty,zsh,fonts,hyprland,waybar,nvim,yay"
print_help() {
    echo ""
    echo "Usage:"
    echo "   ./install.sh [OPTIONS]"
    echo ""
    echo "This is a basic theme installer"
    echo ""
    echo "Options:"
    echo "   -p, --programs <programs>   Define which programs will be installed and configured."
    echo "                                   Atual options: $programs_options"
    echo "   -s, --setup                 Define if programs will be installed before configure."
    echo "   -c, --configure             Define if additioanl configurations will be do."
    echo "                                   For exemple: Clean fonts cache, configure yay, define SDDM default, etc."
    echo ""
    echo "   -sp <programs>              Define programs and execute setup."
    echo "   -cp <programs>              Define programs and configure."
    echo "   -scp <programs>             Define programs, setup and configure."
    echo ""
    echo "   -h, --help"
    echo "   -v, --verbose"
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
