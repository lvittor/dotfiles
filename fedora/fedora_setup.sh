# if [[ $EUID -ne 0 ]]; then
#    echo "This script must be run as root, use sudo "$0" instead" 1>&2
#    exit 1
# fi

while true; do
	sudo -n true
	sleep 60
	kill -0 "$$" || exit
done 2>/dev/null &

set -e
# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

SUDO_USER_HOME="$(eval echo "~$SUDO_USER")"
REPOS_FOLDER=$SUDO_USER_HOME/repos
DOTFILES_FOLDER=$SUDO_USER_HOME/repos/dotfiles

# clone this repo
echo "Cloning repo"

if [ ! -d "$REPOS_FOLDER" ]; then
	mkdir -p $REPOS_FOLDER
fi

if [ ! -d "$DOTFILES_FOLDER" ]; then
	git clone https://github.com/CrossNox/dotfiles.git $DOTFILES_FOLDER
fi

cd $DOTFILES_FOLDER
git pull

# set dnf repos
echo "Setting repos"
sudo dnf update -y
sudo dnf install -y fedora-workstation-repositories
# sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
# sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf config-manager --add-repo https://repo.vivaldi.com/archive/vivaldi-fedora.repo
sudo dnf config-manager --set-enabled vivaldi
sudo dnf config-manager --set-enabled google-chrome

# install packages
echo "Installing DNF packages"
sudo dnf install -y $(cat $DOTFILES_FOLDER/fedora/dnf_pkgs)
sudo systemctl enable powertop.service

# f33 default editor
echo "Nano -> vim"
sudo dnf remove -y nano-default-editor
sudo dnf install -y vim-default-editor

$DOTFILES_FOLDER/fedora/setup_scripts/install_terraform.sh
$DOTFILES_FOLDER/fedora/setup_scripts/setup_aws_cli_v2.sh

echo "adding flatpak remote"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak --user override --filesystem=/home/$USER/.icons/:ro
flatpak --user override --filesystem=/usr/share/icons/:ro

REPOS_FOLDER=~/repos

echo "Installing flatpaks"
flatpak install -y --noninteractive com.spotify.Client
flatpak install -y --noninteractive com.discordapp.Discord
flatpak install -y --noninteractive com.github.wwmm.easyeffects
flatpak install -y --noninteractive com.slack.Slack
flatpak install -y --noninteractive org.telegram.desktop

echo "Linking dotfiles with stow"
cd $DOTFILES_FOLDER
stow -vSt ~ home
sudo stow -vSt / root

for x in "shootingstar" "dell-xps"; do
	if [ $x = $HOSTNAME ]; then
		cd hosts
		sudo stow -vSt / $HOSTNAME
		cd ..
	fi
done

# For udev rules
sudo udevadm control --reload-rules && sudo udevadm trigger

# rvm
echo "Installing rvm"
curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
curl -L get.rvm.io | bash -s stable
# echo 'source ~/.rvm/scripts/rvm' >> ~/.bashrc
source ~/.bashrc
rvm install 2.7.0
rvm --default use 2.7.0

# kitty
echo "Installing kitty"
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
mkdir -p ~/.local/bin
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications
sed -i "s/Icon\=kitty/Icon\=\/home\/$USER\/.local\/kitty.app\/share\/icons\/hicolor\/256x256\/apps\/kitty.png/g" ~/.local/share/applications/kitty.desktop

# set up dev env
echo "Setting devenv"
cd $REPOS_FOLDER
virtualenv -p python3 venv
source venv/bin/activate
pip install -r $DOTFILES_FOLDER/fedora/base_requirements.txt
deactivate
pip install toml

# nvm
echo "Install nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.bashrc
nvm install node
npm install --global yarn

# Install mdcat
if [ ! -d "$REPOS_FOLDER/mdcat" ]; then
	git clone https://github.com/lunaryorn/mdcat.git $REPOS_FOLDER/mdcat
fi
cd $REPOS_FOLDER/mdcat
git pull
cargo install mdcat

# Install onefetch
cargo install onefetch

# nnn
if [ ! -d "$REPOS_FOLDER/nnn" ]; then
	git clone https://github.com/jarun/nnn.git $REPOS_FOLDER/nnn
fi
git pull
cd $REPOS_FOLDER/nnn
make O_NERD=1 O_GITSTATUS=1
mv nnn $HOME/.local/bin/
sudo make install-desktop
sudo sed -i 's!Icon=nnn!Icon=/usr/local/share/icons/hicolor/64x64/apps/nnn.png!g' /usr/local/share/applications/nnn.desktop
sudo sed -i 's!Exec=nnn!Exec=bash -lc "nnn %f"!g' /usr/local/share/applications/nnn.desktop
curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh

# Get pretty wallpaper
echo "Getting a nice wallpaper"
mkdir -p ~/Pictures/Wallpapers
cd ~/Pictures/Wallpapers
wget https://cdn.dribbble.com/users/5031/screenshots/3713646/attachments/832536/wallpaper_mikael_gustafsson.png

# glances
# echo "Installing glances"
# curl -L https://bit.ly/glances | /bin/bash
# systemctl --user daemon-reload
# systemctl --user enable glances.service
# systemctl --user start glances.service

# pipx
echo "Installing pipx and some apps"
python3 -m pip install --user pipx
python3 -m pipx ensurepath
pipx completions
pipx install cookiecutter
pipx install poetry
pipx install sqlparse
pipx install black
pipx install git+https://github.com/dsanson/termpdf.py.git
pipx install termdown
pipx install pywal
pipx install bspcq
pipx install gsutil
# pipx install git+https://github.com/CrossNox/nbtodos.git

# jedi
pip3 install --user jedi

# fonts
echo "Downloading fonts"
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "Droid Sans Mono Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
curl -fLo "Fira Code Regular Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete.ttf
curl -fLo "DejaVu Sans Mono wifi ramp" https://github.com/isaif/polybar-wifi-ramp-icons/raw/main/DejaVuSansMono-wifi-ramp.ttf
curl -fLo "WeatherIcons Regular" https://github.com/erikflowers/weather-icons/raw/master/font/weathericons-regular-webfont.ttf
curl -fLo "MaterialIcons Regular" https://github.com/google/material-design-icons/raw/master/font/MaterialIcons-Regular.ttf
curl -fLo "CryptoFont" https://github.com/monzanifabio/cryptofont/raw/master/fonts/cryptofont.ttf

fc-cache -v

# NB
curl -L https://raw.github.com/xwmx/nb/master/nb -o /usr/local/bin/nb &&
	chmod +x /usr/local/bin/nb &&
	nb completions install

nb env install && nb completions install --download

npm install -g sass

source ~/.bashrc

if [ ! -d "$REPOS_FOLDER/picom" ]; then
	git clone https://github.com/ibhagwan/picom.git ~/repos/picom
fi
git pull
cd ~/repos/picom
git submodule update --init --recursive
meson --buildtype=release . build
ninja -C build
sudo ninja -C build install

if [ ! -d "$REPOS_FOLDER/xdo" ]; then
	git clone https://github.com/baskerville/xdo.git ~/repos/xdo
fi
git pull
cd ~/repos/xdo
make
sudo make install

curl -fsSL https://raw.githubusercontent.com/khanhas/spicetify-cli/master/install.sh | sh
sudo chmod a+wr /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify
sudo chmod a+wr -R /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify/Apps

if [ ! -d "$REPOS_FOLDER/rofi-emoji" ]; then
	git clone https://github.com/Mange/rofi-emoji.git ~/repos/rofi-emoji
fi
git pull
cd ~/repos/rofi-emoji
autoreconf -i
mkdir build
cd build/
../configure
make
sudo make install

if [ ! -d "$REPOS_FOLDER/xbanish" ]; then
	git clone https://github.com/jcs/xbanish.git ~/repos/xbanish
fi
git pull
cd ~/repos/xbanish/
make
mv xbanish ~/.local/bin/

if [ ! -d "$REPOS_FOLDER/rofi-calc" ]; then
	git clone https://github.com/svenstaro/rofi-calc.git ~/repos/rofi-calc
fi
git pull
cd ~/repos/rofi-calc
autoreconf -i
mkdir build
cd build/
../configure
make
sudo make install

if [ ! -d "$REPOS_FOLDER/rofi-pass" ]; then
	git clone https://github.com/carnager/rofi-pass.git ~/repos/rofi-pass
fi
git pull
cd ~/repos/rofi-pass
sudo make install

if [ ! -d "$REPOS_FOLDER/xtitle" ]; then
	git clone https://github.com/baskerville/xtitle.git ~/repos/xtitle
fi
git pull
cd ~/repos/xtitle
sudo make
sudo make install

if [ ! -d "$REPOS_FOLDER/i3lock-color" ]; then
	git clone https://github.com/Raymo111/i3lock-color.git ~/repos/i3lock-color
fi
git pull
cd ~/repos/i3lock-color
./install-i3lock-color.sh

if [ ! -d "$REPOS_FOLDER/rofi-bluetooth" ]; then
	git clone https://github.com/ClydeDroid/rofi-bluetooth.git ~/repos/rofi-bluetooth
fi
git pull
cd ~/repos/rofi-bluetooth
cp rofi-bluetooth ~/.local/bin

mkdir ~/AppImages
cd ~/AppImages
wget https://github.com/Ultimaker/Cura/releases/download/4.13.1/Ultimaker_Cura-4.13.1.AppImage
chmod +x Ultimaker_Cura-4.13.1.AppImage
wget https://raw.githubusercontent.com/Ultimaker/Cura/master/icons/cura-64.png

cat >>~/.local/share/applications/UltimakerCura.desktop <<EOF
[Desktop Entry]
Type=Application
Name=Ultimaker Cura
Comment=Ultimaker Cura
Icon=$HOME/AppImages/cura-64.png
Exec=$HOME/AppImages/Ultimaker_Cura-4.13.1.AppImage
Terminal=false
Categories=Design
EOF

if [ ! -d "$REPOS_FOLDER/rofi-network-manager" ]; then
	git clone https://github.com/P3rf/rofi-network-manager.git ~/repos/rofi-network-manager
fi
git pull
cd ~/repos/rofi-network-manager
chmod +x rofi-network-manager.sh
cp rofi-network-manager.sh ~/.config/polybar/scripts/
cp rofi-network-manager.rasi ~/.config/rofi/
cp rofi-network-manager.conf ~/.config/rofi/

cd /tmp
curl -fLo "ntfd" https://github.com/kamek-pf/ntfd/releases/download/0.2.2/ntfd-x86_64-unknown-linux-musl
chmod +x ntfd
mv ntfd ~/.local/bin
