#! /usr/bin/bash

S_time=$(date +%s)

RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

if [ "$( grep -Ei 'debian' /etc/*release)" ]; then

	echo -e "\n"
	echo -e "${GREEN} |---------------| ${ENDCOLOR}"
	echo -e "${GREEN} | OS check pass | ${ENDCOLOR}"
	echo -e "${GREEN} |---------------| ${ENDCOLOR}"
	echo -e "\n"
else
	echo -e "\n"
	echo -e "${RED} ************************************************** ${ENDCOLOR}" 
	echo -e "${RED} * This script only supports debian based distros * ${ENDCOLOR}"
	echo -e "${RED} ************************************************** ${ENDCOLOR}"
	echo "\n"
	exit 1
fi

if [ $(id -u) -ne 0 ]; then

	echo -e "\n"
	echo -e "${RED} *********************************************** ${ENDCOLOR}"
	echo -e "${RED} * This script must be executed as a root user * ${ENDCOLOR}"
	echo -e "${RED} *********************************************** ${ENDCOLOR}"
	echo -e "\n"
	exit 1
fi	

echo -e "\n"
echo -e "${GREEN} |--------------------------------------------------------| ${ENDCOLOR}"
echo -e "${GREEN} | Installing Linux headers for kernel version => $(uname -r | cut -b -6)  | ${ENDCOLOR}"
echo -e "${GREEN} |--------------------------------------------------------| ${ENDCOLOR}"
echo -e "\n"

sudo apt-get install linux-headers-$(uname -r) build-essential git

if [ ! -d "rtl8812AU_8821AU_linux" ]; then

	echo -e "\n"
	echo -e "${GREEN} |--------------------------------------------------------| ${ENDCOLOR}"
	echo -e "${GREEN} | Cloning project into => $(pwd | awk -F'/' '{print $NF}') Folder                    | ${ENDCOLOR}"
	echo -e "${GREEN} |--------------------------------------------------------| ${ENDCOLOR}"
	echo -e "\n"
	git clone https://github.com/scrivy/rtl8812AU_8821AU_linux.git
else
	rm -rf "rtl8812AU_8821AU_linux"
	git clone https://github.com/scrivy/rtl8812AU_8821AU_linux.git     
fi

cd rtl8812AU_8821AU_linux

echo -e "\n"
echo -e "${GREEN} |----------------------------| ${ENDCOLOR}"
echo -e "${GREEN} | Compiling from source code | ${ENDCOLOR}"
echo -e "${GREEN} |----------------------------| ${ENDCOLOR}"
echo -e "\n"

make || { 
echo -e "\n"
echo -e "${RED} ******************************************************************************** ${ENDCOLOR}" 
echo -e "${RED} * Could not compile please make sure your current kernel version is compatible * ${ENDCOLOR}"
echo -e "${RED} ******************************************************************************** ${ENDCOLOR}"
echo -e "\n"
>&2; exit 1 ; }

sudo make install

echo -e "\n"
echo -e "${GREEN} |--------------------------------------| ${ENDCOLOR}"
echo -e "${GREEN} | Adding modules from the Linux Kernel | ${ENDCOLOR}"
echo -e "${GREEN} |--------------------------------------| ${ENDCOLOR}"
echo -e "\n"

sudo modprobe rtl8812au

E_time=$(date +%s)

echo -e "\n"
echo -e "${GREEN} |---------------------------------------------------------------------| ${ENDCOLOR}"
echo -e "${GREEN} | Time elapsed: $(($E_time - $S_time)) seconds, Rebooting system now                      | ${ENDCOLOR}"
echo -e "${GREEN} |---------------------------------------------------------------------| ${ENDCOLOR}"
echo -e "\n"

reboot
