#!/bin/bash
# install audio2ascii natron plugin in the right place !

os=$(uname)
[[ "$os" =~ "Darwin" ]] && osx=1 && linux=0
[[ "$os" =~ "Linux" ]] && osx=0 && linux=1

if [[ $osx = 1 ]];then
    RED=""
    YEL=""
    GRE=""
    RAZ=""
else
    RED="\033[1;31m"
    YEL="\033[1;33m"
    GRE="\033[1;32m"
    RAZ="\e[0m"
fi

[[ $osx = 1 ]] && path_bin="/opt/local/bin/" || path_bin=""
[[ $osx = 1 ]] && path_natron="${HOME}/Library/Application Support/INRIA/Natron/Plugins/" || path_natron="${HOME}/.local/share/INRIA/Natron/Plugins/"

if [[ ! $(which ${path_bin}sox) ]];then
	echo -e "Audio2ascii plugin require '${RED}sox${RAZ}' which is not installed"
    [[ $osx = 1 ]] && echo -e "${YEL}'sudo port install sox' in a terminal.${RAZ}" ||\
                      echo -e "${YEL}'sudo apt-get install sox' ${RAZ}or${YEL} 'yum install sox' in a terminal.${RAZ}"
    miss="sox"
fi

if [[ ! $(which ${path_bin}ffplay) ]];then
	echo -e "\nAudio2ascii plugin require '${RED}ffplay (ffmpeg)${RAZ}' which is not installed${RAZ}"
    [[ $osx = 1 ]] && echo -e "${YEL}'sudo port install ffmpeg' in a terminal.${RAZ}" ||\
                      echo -e "${YEL}'sudo apt-get install ffmpeg' ${RAZ}or ${YEL}'yum install ffmpeg' in a terminal.${RAZ}"
	miss="$miss ffplay"   
fi

[[ ! $miss = "" ]] && echo -e "\nInstall aborted ! Some utilities are missing : ${RED}$miss${RAZ}" && exit 1

[[  ! -d "${path_natron}" ]] && echo -e "${YEL}The Natron user directory ${path_natron} doesn't exist: Is Natron installed?${RAZ}\nThis install script will create it"
if [[ ! -d "${path_natron}" ]];then
    mkdir -p "${path_natron}" || ( echo -e "Create ${path_natron}: ${RED}Failed${RAZ}" && exit 1)
fi

cp AudioToAscii.png AudioToAscii.py audio2ascii.sh "${path_natron}" && echo -e "Install plugin's files in ${path_natron}: ${GRE}OK${RAZ}"\
                                  || echo -e "Install plugin's files  in ${path_natron}: ${RED}Failed${RAZ}"

if [[ ${linux} = 1 ]];then
    [[ -d "${HOME}/.local/share/applications" ]] || mkdir -p "${HOME}/.local/share/applications"
    cp audio2ascii.desktop "${HOME}/.local/share/applications/"  && echo -e "Install audio2ascii.desktop in ${HOME}/.local/share/applications: ${GRE}OK${RAZ}"\
                                                                 || echo -e "Install audio2ascii.desktop in ${HOME}/.local/share/applications: ${RED}Failed${RAZ}"
    cp AudioCurve "${path_natron}" && echo -e "Install AudioCurve in ${path_natron}: ${GRE}OK${RAZ}"\
                                   || echo -e "Install AudioCurve in ${path_natron}: ${RED}Failed${RAZ}"
fi
