#!/usr/bin/env bash

CUSTOM_DIR="$HOME/.customization"
SCHEME="gruvbox"

update_minegrub() {
	if [[ -d "$CUSTOM_DIR/minegrub-theme" ]]; then
		cd "$CUSTOM_DIR/minegrub-theme" || return 1
		git pull --rebase
		sudo cp -ruv ./minegrub /boot/grub/themes/
		grep -Fxq 'GRUB_THEME=/boot/grub/themes/minegrub/theme.txt' /etc/default/grub || sudo tee -a /etc/default/grub <<EOF
GRUB_THEME=/boot/grub/themes/minegrub/theme.txt
EOF
		sudo grub-mkconfig -o /boot/grub/grub.cfg
		cd || rerurn 1
	fi
}

update_nerdfonts() {
	if [ "$(
		fc-list | grep JetBrainsMono &>/dev/null
		echo $?
	)" -eq 0 ]; then
		curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
		mkdir -p "$HOME/.local/share/fonts/JetbrainsMono"
		tar -xf ./JetBrainsMono.tar.xz -C "$HOME/.local/share/fonts/JetbrainsMono/"
		fc-cache
		rm JetBrainsMono.tar.xz
	fi
}

update_lazygit() {
	if type -P lazygit >/dev/null; then
		LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
		curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
		tar xf lazygit.tar.gz lazygit
		sudo install lazygit /usr/local/bin
		rm lazygit*
	fi
}

update_system() {
	if type -P fwupdmgr >/dev/null; then sudo fwupdmgr update; fi
	if type -P apt >/dev/null; then sudo apt update && sudo apt upgrade; fi
	if [ "$(
		which nala &>/dev/null
		echo $?
	)" -eq 0 ]; then
		sudo nala update && sudo nala upgrade && sudo nala autoremove
	fi
	[[ -d /snap ]] && sudo snap refresh
	if [ "$(
		which dnf &>/dev/null
		echo $?
	)" -eq 0 ]; then
		sudo dnf upgrade-minimal
		sudo dnf autoremove
	fi
}

update_flatpak() {
	if [ "$(
		which flatpak &>/dev/null
		echo $?
	)" -eq 0 ]; then
		flatpak update
	fi
}

update_colloid() {
	if [[ -d "$CUSTOM_DIR/Colloid-gtk-theme" ]]; then
		cd "$CUSTOM_DIR" || return 1
		for DIR in *; do
			if [[ "$DIR" == "Colloid-gtk-theme" ]]; then
				cd "$DIR" || return 1
				git pull --rebase
				./install.sh --tweaks $SCHEME float
				cd "$CUSTOM_DIR" || return 1
			fi
			if [[ "$DIR" == "Colloid-icon-theme" ]]; then
				cd "$DIR" || return 1
				git pull --rebase
				mkdir -p "$HOME/.local/share/icons"
				./install.sh
				cd ./cursors/ || return 1
				sudo ./install.sh
				cd "$CUSTOM_DIR" || return 1
			fi
		done
		cd || return 1
	fi
}

update_neovim() {
	if [[ -d "/opt/nvim-linux64" ]]; then
		curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
		sudo rm -rf /opt/nvim
		sudo tar -C /opt -xzf nvim-linux64.tar.gz
		rm nvim-linux64.tar.gz
	fi
	if [[ -f "/opt/nvim/nvim.appimage" ]]; then
		curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
		if [ ! "$(md5sum "/opt/nvim/nvim.appimage" | awk '{print $1}')" = "$(md5sum ./nvim.appimage | awk '{print $1}')" ]; then
			chmod u+x nvim.appimage
			sudo rm /opt/nvim/nvim.appimage
			sudo mv ./nvim.appimage /opt/nvim/
			sudo ln -sf /opt/nvim/nvim.appimage /usr/local/bin/nvim
		fi
		rm nvim.appimage
	fi
	if type -P lvim >/dev/null; then lvim +LvimUpdate +q; fi
}

update_node() {
	if [[ -d "$HOME/.nvm" ]]; then
		local NODEJS_VERSION
		NODEJS_VERSION=$(node -v)
		(
			cd "$NVM_DIR"
			git fetch --tags origin
			git checkout $(git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))
		) && \. "$NVM_DIR/nvm.sh"
		if [ ! "$(nvm ls-remote --lts --no-colors | tail -n1 | awk '{print $2}')" = "$(nvm current)" ]; then
			nvm install --lts
			nvm use --lts
			nvm reinstall-packages "$NODEJS_VERSION"
		fi
		cd || return 1
	fi
}

update_rust() {
	if [ -d "$HOME/.cargo" ]; then
		rustup update
		## The construction process can take a long time dependColouring on the capacity of the machine.
		## It is convenient to ask before doing this action.
		while true; do
			echo -ne "Update installed binaries by cargo? (y/n) -> " && read -r opt
			if [ "$(echo "$opt" | awk '{print tolower($0)}')" = "y" ]; then
				for bin in $(cargo install --list | awk 'NR % 2 != 0 {print $1}'); do
					cargo install "$bin" --force
				done
				break
			elif [ "$(echo "$opt" | awk '{print tolower($0)}')" = "n" ]; then
				break
			fi
		done
	fi
}

update_darkman() {
	if [[ -d "$CUSTOM_DIR/darkman" ]]; then
		cd "$CUSTOM_DIR/darkman" || return 1
		git pull --rebase
		make
		sudo make install PREFIX=/usr
		cd || return 1
		systemctl --user enable --now darkman.service
	fi
}

update_colloid_rev() {
	if [[ -d "$CUSTOM_DIR/Colloid-gtk-theme" ]]; then
		cd "$CUSTOM_DIR" || return 1
		for DIR in *; do
			if [[ "$DIR" == "Colloid-gtk-theme" ]]; then
				cd "$DIR" || return 1
				git pull --rebase
				./install.sh --tweaks $SCHEME float
				cd "$CUSTOM_DIR" || return 1
			fi
			if [[ "$DIR" == "Colloid-icon-theme" ]]; then
				cd "$DIR" || return 1
				git pull --rebase
				mkdir -p "$HOME/.local/share/icons"
				./install.sh
				cd ./cursors/ || return 1
				sudo ./install.sh
				cd "$CUSTOM_DIR" || return 1
			fi
		done
		cd || return 1
	fi
}

update_node_rev() {
	if [[ -d "$HOME/.nvm" ]]; then
		local NODEJS_VERSION
		NODEJS_VERSION=$(node -v)
		(
			cd "$NVM_DIR"
			git fetch --tags origin
			git checkout $(git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))
		) && \. "$NVM_DIR/nvm.sh"
		if [ ! "$(nvm ls-remote --lts --no-colors | tail -n1 | awk '{print $2}')" = "$(nvm current)" ]; then
			nvm install --lts
			nvm use --lts
			nvm reinstall-packages "$NODEJS_VERSION"
		fi
		cd || return 1
	fi
}
