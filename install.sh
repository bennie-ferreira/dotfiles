#!/bin/bash

# Colors
CRE=$(tput setaf 1) # Red
CYE=$(tput setaf 3) # Yellow
CGR=$(tput setaf 2) # Green
CBL=$(tput setaf 4) # Blue
CBM=$(tput setaf 5) # Magenta
CCY=$(tput setaf 6) # Cyan
BLD=$(tput bold)    # Bold
CNC=$(tput sgr0)    # Reset colors

# Helpers icon
ok_icon="${CGR}✅${CNC}"
warn_icon="${CYE}⚠️${CNC}"
err_icon="${CRE}❌${CNC}"
info_icon="${CCY}💡${CNC}"

# Functions
logo() {
	curl -L git.io/pizzza
	text="$1"
	printf "%b" "
${CGR} 👻 ${CRE} 👻 ${CBL} 👻 ${CYE} 👻

${BLD}${CRE}[ ${CYE}${text} ${CRE}]${CNC}\n\n"
}

install_step() {
	step="$1"
	cmd="$2"

	echo "${info_icon} ${BLD}${CYE}${step}${CNC}"
	if eval "$cmd"; then
		echo "   ${ok_icon} ${CGR}Sucesso${CNC}"
	else
		echo "   ${err_icon} ${CRE}Falha${CNC}"
		exit 1
	fi
	echo
}

# Void Main
clear
logo "Hello World"

echo "${info_icon} ${BLD}${CYE}Iniciando instalação dos Dotfiles...${CNC}"

install_step "Atualizando sistema..." "sudo pacman -Syu"
install_step "Ínstalando dependências..." "sudo pacman -S --needed openbox nitrogen picom lxappearance polybar rofi tmux autorandr arandr pavucontrol neovim starship bat fzf xcape nemo networkmanager \
	network-manager-applet lightdm lightdm-gtk-greeter xcape capitaine-cursors bash-completion ttf-firacode-nerd alacritty wmctrl \
	noto-fonts-emoji noto-fonts noto-fonts-cjk noto-fonts-extra geany ttf-jetbrains-mono code pulseaudio pulseaudio-alsa pulseaudio-bluetooth \
	xdotool maim rofi xclip dunst"

install_step "Iniciando servidor de audio..." "systemctl --user enable --now pulseaudio.service"

install_step "Instalando Yay..." " cd ~ ; git clone https://aur.archlinux.org/yay.git ; cd yay ; makepkg -si ; yay --version"

install_step "Instalando dependências Yay..." "yay -S --needed brave-bin papirus-icon-theme tokyonight-gtk-theme-git ttf-jetbrains-mono-nerd ttf-material-design-icons-git ttf-font-awesome nerd-fonts \
				betterlockscreen; fc-cache -fv"

install_step "Iniciando sessao do lightdm..." "sudo systemctl enable lightdm.service ; sudo systemctl start lightdm.service"
install_step "Iniciando sessão NetworkManager..." "sudo systemctl enable --now NetworkManager"

install_step "Copiando arquivos de configuração..." "cp -v -r .config/* ~/.config ; cp -v -r wallpapers ~/"
install_step "Copiando arquivos de temas..." "cp -v -r themes/* ~/.themes"
install_step "Copiando configuração .bashrc" "cp -v .bashrc ~/.bashrc"
install_step "Copiando configuração .gtkrc-2.0" "cp -v .gtkrc-2.0 ~/.gtkrc-2.0"

echo "${ok_icon} ${BLD}${CGR}Tudo pronto! Seus dotfiles foram instalados com sucesso.${CNC}"
