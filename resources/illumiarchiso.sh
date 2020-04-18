#!/usr/bin/bash
####################################################################################################################
#
####################################################################################################################

export pwd=$(pwd)

sudo pacman -S archiso

sudo rm -rf illumiarchlinux

cp -r /usr/share/archiso/configs/releng/ illumiarchlinux

# enable multilib repo's and pacman color mode
sed -i '/\[multilib\]/{ s/^#//; n; s/^#//; }' "illumiarchlinux/pacman.conf"
sed -i 's/^#Color/Color/' "illumiarchlinux/pacman.conf"

cp packages.x86_64 illumiarchlinux/packages.x86_64

cp customize_airootfs.sh illumiarchlinux/airootfs/root/customize_airootfs.sh

cd illumiarchlinux && ./build.sh -v

# rebuild
rm -v work/build.make_*
