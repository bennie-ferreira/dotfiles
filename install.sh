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
	fi
	echo
}

# Void Main
clear
logo "Hello World"

echo "${info_icon} ${BLD}${CYE}Iniciando instalação dos Dotfiles...${CNC}"

# # Exemplo de passos — substitua com os seus
# install_step "Copiando arquivos de configuração..." "cp -r ./dotfiles ~/.config 2>/dev/null"
# install_step "Instalando dependências..." "sudo apt-get update -y >/dev/null && sudo apt-get install -y neovim git zsh >/dev/null"
# install_step "Aplicando temas..." "echo 'source ~/.config/zsh/theme.zsh' >> ~/.zshrc"

# echo "${ok_icon} ${BLD}${CGR}Tudo pronto! Seus dotfiles foram instalados com sucesso.${CNC}"
# echo
