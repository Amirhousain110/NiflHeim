#!/bin/bash

conf=$HOME/.config/nvim
dfile=https://github.com/Amirhousain110/NiflHeim.git

COLUMNS=$(tput cols)
banner_width=59
indent=$(((COLUMNS - banner_width) / 2))
prefix=''
for ((i = 1; i <= indent; i++)); do
	prefix+=' '
done

CYAN='\033[0;36m'
NC='\033[0m'
GREEN='\033[0;32m'
RED='\033[0;31m'

pkg_install() {

	local distro
	local cmd
	local usesudo
	declare -A pkgmgr
	pkgmgr=(
		[arch]="pacman -S"
		[alpine]="apk add"
		[debian]="apt-get install "
		[ubuntu]="apt-get install "
	)

	distro=$(cat /etc/os-release | tr [:upper:] [:lower:] | grep -Poi '(debian|ubuntu|red hat|centos|arch|alpine)' | uniq)
	cmd="${pkgmgr[$distro]}"
	[[ ! $cmd ]] && return 1
	if [[ $1 ]]; then
		[[ ! $EUID -eq 0 ]] && usesudo=sudo
		echo installing packages command: $usesudo $cmd $@
		$usesudo $cmd $@
	else
		echo $cmd
	fi
}

echo -e "${CYAN}"
echo -e "${prefix}███╗   ██╗██╗███████╗██╗     ██╗  ██╗███████╗██╗███╗   ███╗"
echo -e "${prefix}████╗  ██║██║██╔════╝██║     ██║  ██║██╔════╝██║████╗ ████║"
echo -e "${prefix}██╔██╗ ██║██║█████╗  ██║     ███████║█████╗  ██║██╔████╔██║"
echo -e "${prefix}██║╚██╗██║██║██╔══╝  ██║     ██╔══██║██╔══╝  ██║██║╚██╔╝██║"
echo -e "${prefix}██║ ╚████║██║██║     ███████╗██║  ██║███████╗██║██║ ╚═╝ ██║"
echo -e "${prefix}╚═╝  ╚═══╝╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝     ╚═╝"
echo -e "${prefix}___________________________________________________________"
echo -e "${prefix}Welcome $(whoami) to NiflHeim Installer."
echo -e "${NC}"

read -p "Do you want to continue? (Y/n): " choice1
if [[ $choice1 == "y" || $choice1 == "Y" || $choice1 == "" ]]; then
	echo "Installing NiflHeim..."

	read -p "Do you whant to install required dependencies? (Y/n): " depChoice
	if [[ $depChoice == "y" || $depChoice == "Y" || $depChoice == "" ]]; then
		echo "Installing dependencies..."
		pkg_install "fzf lazygit ripgrep fd tree-sitter tree-sitter-c tree-sitter-cli neovim git curl nodejs gcc"

	elif [[ $depChoice == "n" || $depChoice == "N" ]]; then
		echo "Skipping dependency installation..."

	else
		echo -e "${RED}Invalid choice. Installation cancelled.${NC}"
		exit 1
	fi

	if [[ -f $conf ]]; then

		read -p "Another config detect. Do you whant to back up your current Neovim configuration? (Y/n/c[ancel install]):" choice2
		if [[ $choice2 == "y" || $choice2 == "Y" || $choice2 == "" ]]; then
			echo "Backing up current configuration..."

			confBack=${conf}_$(date +%F_%T).bak

			mv $conf $confBack
			echo "Backup created at $confBack"

			rm -rf $HOME/.local/share/nvim
			rm -rf $HOME/.local/state/nvim
			rm -rf $HOME/.cache/nvim
			git clone $dfile $conf

		elif [[ $choice2 == "n" || $choice2 == "N" ]]; then
			echo "Skipping backup..."

			rm -rf $conf
			rm -rf $HOME/.local/share/nvim
			rm -rf $HOME/.local/state/nvim
			rm -rf $HOME/.cache/nvim
			git clone $dfile $conf

		elif [[ $choice2 == "c" || $choice2 == "C" ]]; then
			echo -e "${RED}Installation cancelled${NC}"
			exit 0
		else
			echo -e "${RED}Invalid choice. Installation cancelled.${NC}"
			exit 1
		fi
	else

		git clone $dfile $conf
	fi
	echo -e "${GREEN}NiflHeim installed successfully!${NC}"

	read -p "Do you want to install NiflHeim on your root user?(Y/n)" choiceRoot
	if [[ $choiceRoot == "y" || $choiceRoot == "Y" || $choiceRoot == "" ]]; then

		sudo true
		rm -rf /root/.config/nvim
		rm -rf /root/.local/share/nvim
		rm -rf /root/.local/state/nvim
		rm -rf /root/.cache/nvim
		git clone $dfile /root/.config/nvim
		echo -e "${GREEN}NiflHeim installed successfully for root user!${NC}"

	else
		echo -e "${CYAN}Skipping root user installation.${NC}"
		exit 0
	fi

else
	echo -e "${RED}Installation cancelled.${NC}"
	exit 0
fi
