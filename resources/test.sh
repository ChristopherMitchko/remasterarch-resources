#!/usr/bin/bash
##############################################################################################
# script to create linux user and set passwd, for use with arch linux aur package building
##############################################################################################

set -e -u -x

RED='\033[1;31m'
CYAN='\033[0;36m'
GREEN='\033[1;32m'
PURPLE='\033[1;35m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

echo -e "${CYAN}##############################################################################################"
echo -e "${CYAN}# script to create linux user and set passwd, for use with arch aur package building"
echo -e "${CYAN}##############################################################################################${NC}"

userdel illumilive && rm -rf /home/illumilive
echo -e "${CYAN} 1: ${PURPLE}trying to create illumilive linux user for use with building arch linux aur packages!${NC}"
username="illumilive"
password="toor"
pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
useradd -m -p $pass $username
[ $? -eq 0 ] && echo -e "${CYAN} RESULT: User has been added to system!\\n ${BLUE}:username= illumilive\\n :password= toor${NC}" && sleep 3 || echo -e "${RED} RESULT: Failed to add a user!${NC}"
usermod -aG wheel illumilive
echo -e ${CYAN} $(id illumilive) ${NC}

RUNAS="sudo -u illumilive"
$RUNAS bash<<_
echo -e "${PURPLE}commands testing if able to run commands as new illumilive user.${NC}"
echo -e "${GREEN}USER= \$(whoami)-\${UID}" "${RED}REMEMBER TO START COMMANDS OFF WITH ${GREEN}\ ${RED}OR IT WILL RUN AS ROOT!"
echo -e "${PURPLE}ROOT=  $(whoami)-${UID}${NC}"
_

# install trizen aur helper
runuser -l illumilive -c 'cd $HOME && mkdir -pv work-area && cd work-area'
runuser -l illumilive -c 'echo $PWD && sleep 4'
\cd $lfs/work-area && git clone https://github.com/trizen/trizen.git
\cd trizen/archlinux/ && makepkg -si

# install a gpg signature
\gpg --recv-keys 8C004C2F93481F6B

\trizen -S dpkg perl-file-homedir perl-git-wrapper perl-list-compare perl-parse-debcontrol debianutils intltool-debian po-debconf debhelper \
\          sensible-utils devscripts dh-make dh-autoreconf python2-debian dput rpm-org git-buildpackage mock-core-configs \
\          python2-bugzilla fluxmod-styles

\cd ~/work-area && trizen --get distribution-gpg-keys
\cd distribution-gpg-keys && makepkg -si

\cd ~/work-area && trizen --get mock-core-configs
\cd mock-core-configs && makepkg -si

\cd ~/work-area && trizen --get mock
\cd mock && makepkg -si

\trizen -S apt apt-mirror

\cd ~/work-area && git clone https://github.com/Naereen/nanorc.git ~/.nano/
\ln -s ~/.nano/.nanorc ~/.nanorc
\echo "$(whoami) = ${UID}"
_

echo "$(whoami) = ${UID} = $PWD"


