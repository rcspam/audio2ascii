#!/bin/bash
# install audio2ascii natron plugin in the right place !

os=$(uname)
[[ "$os" =~ "Darwin" ]] && osx=1 && linux=0
[[ "$os" =~ "Linux" ]] && osx=0 && linux=1

if [[ $Linux = 1 ]];then
    RED="\033[1;31m"
    YEL="\033[1;33m"
    GRE="\033[1;32m"
    RAZ="\e[0m"
fi

[[ $osx = 1 ]] && path_bin="/opt/local/bin/" || path_bin=""
[[ $osx = 1 ]] && path_natron="${HOME}/Library/Application Support/INRIA/Natron/Plugins/" || path_natron="${HOME}/.local/share/INRIA/Natron/Plugins/"

if [[ ! $(which ${path_bin}sox) ]];then
    echo -e "Audio2ascii plugin require '${RED}sox${RAZ}' which is not installed"
    [[ $osx = 1 ]] && echo -e "${YEL}'sudo port install sox' in a terminal.${RAZ}"\
                   || echo -e "${YEL}'sudo apt-get install sox' ${RAZ}or${YEL} 'yum install sox' in a terminal.${RAZ}"
    miss="sox"
fi
if [[ ! $(which ${path_bin}ffplay) ]];then
    echo -e "\nAudio2ascii plugin require '${RED}ffplay (ffmpeg)${RAZ}' which is not installed${RAZ}"
    [[ $osx = 1 ]] && echo -e "${YEL}'sudo port install ffmpeg' in a terminal.${RAZ}"\
                   || echo -e "${YEL}'sudo apt-get install ffmpeg' ${RAZ}or ${YEL}'yum install ffmpeg' in a terminal.${RAZ}"
    miss="$miss ffplay"   
fi
[[ ! $miss = "" ]] && echo -e "\nInstall aborted ! Some utilities are missing : ${RED}$miss${RAZ}" && exit 1

if [[ ! -d "${path_natron}/audio2ascii" ]];then
    mkdir -p "${path_natron}/audio2ascii" && echo -e "Create install directories: ${GRE}Done${RAZ}"\
                                          || ( echo -e "Create ${path_natron}/audio2ascii: ${RED}Failed${RAZ}" && exit 1)
fi

cp AudioToAscii.png AudioToAscii.py  "${path_natron}" && echo -e "Install plugin's files in ${path_natron}: ${GRE}Done${RAZ}"\
                                                      || echo -e "Install plugin's files  in ${path_natron}: ${RED}Failed${RAZ}"
cp audio2ascii/audio2ascii.sh audio2ascii/play.png audio2ascii/play_enabled.png audio2ascii/stop.png "${path_natron}/audio2ascii"\
        && echo -e "Install plugin's files in ${path_natron}/audio2ascii: ${GRE}Done${RAZ}"\
        || echo -e "Install plugin's files  in ${path_natron}/audio2ascii: ${RED}Failed${RAZ}"

if [[ ${linux} = 1 ]];then
    [[ -d "${HOME}/.local/share/applications" ]] || mkdir -p "${HOME}/.local/share/applications"
    cp audio2ascii.desktop "${HOME}/.local/share/applications/" && echo -e "Install audio2ascii.desktop in ${HOME}/.local/share/applications: ${GRE}Done${RAZ}"\
                                                                || echo -e "Install audio2ascii.desktop in ${HOME}/.local/share/applications: ${RED}Failed${RAZ}"
    cp audio2ascii/AudioCurve "${path_natron}/audio2ascii" && echo -e "Install AudioCurve in ${path_natron}/audio2ascii: ${GRE}Done${RAZ}"\
                                                           || echo -e "Install AudioCurve in ${path_natron}/audio2ascii: ${RED}Failed${RAZ}"
fi
