#!/bin/bash

###########################################################################################################################
#
###########################################################################################################################
set -e -u -x

RED='\033[1;31m'
CYAN='\033[0;36m'
GREEN='\033[1;32m'
PURPLE='\033[1;35m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/America/New_York /etc/localtime

usermod -s /usr/bin/bash root
cp -aT /etc/skel/ /root/
chmod 700 /root

sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

ln -s /usr/lib/systemd/system/lxdm.service /etc/systemd/system/display-manager.service

systemctl enable pacman-init.service choose-mirror.service
systemctl set-default graphical.target

# set multi user systemd target
#systemctl set-default multi-user.target

# create work-area directory
mkdir -pv work-area && cd work-area
export pwd=$(pwd)
echo "$(whoami) = ${UID}"

# Run https://blackarch.org/strap.sh as root and follow the instructions.
curl -O https://blackarch.org/strap.sh
chmod +x strap.sh && ./strap.sh

pacman -S blackman blackarch-config blackarch-wallpaper menumaker

cp -r /usr/share/blackarch/config/awesome/etc/xdg/awesome/rc.lua.blackarch /etc/xdg/awesome/rc.lua
cp -r /usr/share/blackarch/config/awesome/usr/share/awesome/themes/blackarch /usr/share/awesome/themes/

cp -r /usr/share/blackarch/config/bash/bashrc ~/.bashrc
cp -r /usr/share/blackarch/config/bash/bash_profile ~/.bash_profile

cp -r /usr/share/blackarch/config/fluxbox/* /usr/share/fluxbox

cp -r /usr/share/blackarch/config/gtk-2.0/* /usr/share/gtk-2.0

cp -r /usr/share/blackarch/config/x11/xprofile /etc/xprofile
cp -r /usr/share/blackarch/config/x11/Xresources ~/.Xresources
cp -r /usr/share/blackarch/config/x11/Xdefaults ~/.Xdefaults

mkdir -pv ~/.config/i3
cp -r /usr/share/blackarch/config/i3/config ~/.config/i3/config
cp -r /usr/share/blackarch/config/i3/i3status.conf ~/.i3status.conf

cp -r /etc/lxdm-blackarch/* /etc/lxdm/
cp -r /usr/share/lxdm-blackarch/* /usr/share/lxdm/
cp -r /usr/share/xsessions-blackarch /usr/share/xsessions

cp -r /usr/share/blackarch/config/openbox/etc/xdg/openbox/ /etc/xdg/openbox/
cp -r /usr/share/blackarch/config/openbox/usr/share/themes/blackarch/openbox-3 /usr/share/themes/blackarch/

cp /usr/share/blackarch/config/spectrwm ~/.spectrwm.conf

cp -r /usr/share/blackarch/config/vim/vim ~/.vim
cp -r /usr/share/blackarch/config/vim/vimrc ~/.vimrc

mmaker -vf --no-legacy --no-debian FluxBox
mmaker -vf --no-legacy --no-debian OpenBox3

cd $pwd && git clone https://github.com/Naereen/nanorc.git ~/.nano/
ln -s ~/.nano/.nanorc ~/.nanorc

sed -i 's/^#\s*\(%wheel\s*ALL=(ALL)\s*NOPASSWD:\s*ALL\)/\1/' /etc/sudoers

echo -e "${CYAN}############################################################################################################"
echo -e "${CYAN}# Trying to create illumilive linux user and set passwd, for use with arch aur package building"
echo -e "${CYAN}############################################################################################################${NC}"
userdel illumilive && rm -rf /home/illumilive
echo -e "${CYAN} 1: ${PURPLE}trying to create illumilive linux user for use with building arch linux aur packages!${NC}"
username="illumilive"
password="toor"
pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
useradd -m -p $pass $username
[ $? -eq 0 ] && echo -e "${CYAN} RESULT: User has been added to system!\\n ${BLUE}:username= illumilive\\n :password= toor${NC}" && sleep 3 || echo -e "${RED} RESULT: Failed to add a user!${NC}"
usermod -aG wheel illumilive
echo -e ${PURPLE} $(id illumilive) ${NC}

# install trizen aur helper
runuser -l illumilive -c 'cd $HOME && mkdir -pv work-area && cd work-area'
runuser -l illumilive -c 'cd $HOME/work-area && git clone https://github.com/trizen/trizen.git'
runuser -l illumilive -c 'cd $HOME/work-area/trizen/archlinux/ && makepkg -si'

# install a gpg signature
runuser -l illumilive -c 'gpg --recv-keys 8C004C2F93481F6B'

runuser -l illumilive -c 'trizen -S dpkg perl-file-homedir perl-git-wrapper perl-list-compare perl-parse-debcontrol debianutils intltool-debian po-debconf debhelper sensible-utils devscripts dh-make dh-autoreconf python2-debian dput rpm-org git-buildpackage python2-bugzilla fluxmod-styles'

runuser -l illumilive -c 'cd $HOME/work-area && trizen --get distribution-gpg-keys'
runuser -l illumilive -c 'cd $HOME/work-area/distribution-gpg-keys && makepkg -si'

runuser -l illumilive -c 'cd $HOME/work-area && trizen --get mock-core-configs'
runuser -l illumilive -c 'cd $HOME/work-area/mock-core-configs && makepkg -si'

runuser -l illumilive -c 'trizen -S python-pyroute2'

runuser -l illumilive -c 'cd $HOME/work-area && trizen --get mock'
runuser -l illumilive -c 'cd $HOME/work-area/mock && makepkg -si'

runuser -l illumilive -c 'trizen -S apt apt-mirror'

runuser -l illumilive -c 'cd $HOME/work-area && git clone https://github.com/Naereen/nanorc.git ~/.nano/'
runuser -l illumilive -c 'ln -s ~/.nano/.nanorc ~/.nanorc'
runuser -l illumilive -c 'echo $(whoami) = ${UID}'

echo "$(whoami) = ${UID} = $PWD"


