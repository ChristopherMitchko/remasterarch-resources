#!/usr/bin/bash
###########################################################################################
# script to be run as root but execute commands as a different user
###########################################################################################

if [ "$(id -u)" != "0" ] ; then
    err "You must be root to test running commands as a different user!"
fi

RED='\033[1;31m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color
echo -e "${CYAN}###################################################################################################################"
echo -e "${CYAN}# script to be run as root but execute commands as a different user and colored output of echo command"
echo -e "${CYAN}###################################################################################################################${NC}"

RUNAS="sudo -u sig7"
echo -e "${RED}echo the current user and uid of current user, which must be root.${NC}"
echo -e "${PURPLE}USER= $(whoami) ${NC}"
echo -e "${PURPLE}UID=  $UID ${NC}"

#Runs bash as different user starting with commands between '_' and starting with \
$RUNAS bash<<_
echo -e "${BLUE}commands being run as different user${NC}"
echo -e "${GREEN}USER= \$(whoami)"
echo -e "${GREEN}UID=  \$UID${NC}"
_

echo -e "${RED}command being run normally again${NC}"
echo -e "${PURPLE}USER= $(whoami)"
echo -e "${PURPLE}UID=  $UID${NC}"


