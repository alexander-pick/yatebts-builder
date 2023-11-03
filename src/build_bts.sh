#!/bin/bash
# Alexander Pick 2022-2023
# Mail: contact@alexander-pick.com

SECONDS=0

RED="\e[31m"
ORANGE="\e[33m"
YELLOW="\e[93m"
BLUE="\e[94m"
NC="\e[0m"

# utility folders, keep trainling "/" (!!!)
LOGS="/usr/src/logs/"
BACKUPS="/usr/src/backups/"

NOOUT="> /dev/null 2>&1"
DATETIME=$(date -d "today" +"%Y%m%d%H%M%S")

PARAM2=${2}

function backup_dir {

    BDIR=${1}

    WRITELOG="${LOGS}/${DATETIME}.backup.log"

    if [ -d "./${BDIR}" ]; then
        eval "tar cvzf ${BACKUPS}${DATETIME}${BDIR}.tgz ./${BDIR} >> ${WRITELOG}"
    fi
}

function build_bladerf {

    echo -e "${BLUE}[i] build target: ${YELLOW}bladeRF${NC}"

    WRITELOG="${LOGS}/${DATETIME}.blade.log"

    cd /usr/src/bladeRF
    echo -e "${BLUE}[i] - reseting git${NC}"

    eval "git reset --hard d0fbe0569059f10fcc71095409284586b00fe59b > ${WRITELOG} 2>&1"
    
    cd host

    eval "rm -fr build >> ${WRITELOG} 2>&1"
    eval "mkdir build >> ${WRITELOG} 2>&1"
    
    cd build
    
    echo -e "${BLUE}[i] - configuring${NC}"
    eval "cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DINSTALL_UDEV_RULES=ON -DENABLE_FX3_BUILD=OFF -DENABLE_HOST_BUILD=ON .. >> ${WRITELOG}"
    echo -e "${BLUE}[i] - cleaning${NC}"
    eval "make clean >> ${WRITELOG}"
    echo -e "${BLUE}[i] - building${NC}"
    eval "make >> ${WRITELOG}"
    echo -e "${BLUE}[i] - installing${NC}"
    eval "make install >> ${WRITELOG}"

    eval "ldconfig >> ${WRITELOG}"
    cd /usr/src

}

function build_yatelib {
    
    echo -e "${BLUE}[i] build target: ${YELLOW}yate${NC}"

    WRITELOG="${LOGS}/${DATETIME}.yate.log"

    cd /usr/src/yate

    if [ "${PARAM2}" == "--quick" ]; then
        echo -e "${YELLOW}[i] doing a quick build${NC}"

    else
        echo -e "${BLUE}[i] - configuring${NC}"
        eval "./autogen.sh > ${WRITELOG}"
        eval "./configure --without-libqt4  >> ${WRITELOG}"    
        echo -e "${BLUE}[i] - cleaning${NC}"
        eval "make clean >> ${WRITELOG}"
    fi

    echo -e "${BLUE}[i] - building ${NC}"
    eval "make engine >> ${WRITELOG}"

    echo -e "${BLUE}[i] - installing ${NC}"
    eval "make install-noapi >> ${WRITELOG}"
    eval "ldconfig >> ${WRITELOG}"
    
    cd /usr/src
}

function build_yatebts {

    echo -e "${BLUE}[i] build target: ${YELLOW}yatebts${NC}"

    WRITELOG="${LOGS}/${DATETIME}.yatebts.log"

    mkdir -p /usr/local/share/yate/nipc_web/
    cd /usr/local/share/yate/nipc_web/
    eval "git clone https://github.com/yatevoip/ansql.git >> ${WRITELOG} 2>&1"
    
    cd /usr/src/yatebts

    if [ "${PARAM2}" == "--quick" ]; then
        echo -e "${YELLOW}[i] doing a quick build${NC}"
    else
        echo -e "${BLUE}[i] - configuring${NC}"
        eval "./autogen.sh > ${WRITELOG}"
        eval "./configure >> ${WRITELOG}"
        echo -e "${BLUE}[i] - cleaning${NC}"
        eval "make clean >> ${WRITELOG}"
    fi

    echo -e "${BLUE}[i] - building${NC}"
    eval "make -j$(nproc) >> ${WRITELOG}"
    echo -e "${BLUE}[i] - installing${NC}"
    eval "make install >> ${WRITELOG}"

    cd /usr/src

}

function build_srsgui {

    echo -e "${BLUE}[i] build target: ${YELLOW}srsGUI${NC}"

    WRITELOG="${LOGS}/${DATETIME}.srsgui.log"

    cd /usr/src/srsGUI

    if [ "${PARAM2}" == "--quick" ]; then
        echo -e "${YELLOW}[i] doing a quick build${NC}"
        cd build
    else
        eval "rm -fr build >> ${WRITELOG}"
        eval "mkdir build >> ${WRITELOG}"
        cd build
        eval "cmake .. >> ${WRITELOG}"
    fi

    eval "make -j$(nproc) >> ${WRITELOG}"
    eval "make install >> ${WRITELOG}"

    cd /usr/src

}

function build_srsran_4g {

    echo -e "${BLUE}[i] build target: ${YELLOW}srsRAN 4G${NC}"

    WRITELOG="${LOGS}/${DATETIME}.srs4g.log"

    cd /usr/src/srsRAN_4G

    if [ "${PARAM2}" == "--quick" ]; then
        echo -e "${YELLOW}[i] doing a quick build${NC}"
        cd build
    else
        eval "rm -fr build >> ${WRITELOG}"
        eval "mkdir build >> ${WRITELOG}"
        cd build
        eval "cmake .. >> ${WRITELOG}"
    fi

    eval "make -j$(nproc) >> ${WRITELOG}"
    eval "make install >> ${WRITELOG}"
    eval "ldconfig >> ${WRITELOG}"

    eval "source srsran_install_configs.sh service >> ${WRITELOG}"

    cd /usr/src
}

function build_srsran_project {

    echo -e "${BLUE}[i] build target: ${YELLOW}srsRAN Project${NC}"

    WRITELOG="${LOGS}/${DATETIME}.srs5g.log"

    cd /usr/src/srsRAN_Project

    if [ "${PARAM2}" == "--quick" ]; then
        echo -e "${YELLOW}[i] doing a quick build${NC}"
        cd build
    else
        eval "rm -fr build >> ${WRITELOG}"
        eval "mkdir build >> ${WRITELOG}"
        cd build
        eval "cmake .. >> ${WRITELOG}"
    fi
    eval "make -j$(nproc) >> ${WRITELOG}"
    eval "make install >> ${WRITELOG}"

    cd /usr/src

}

function download_src {

    # backup and clean existing srcs
    if [ -d "/usr/src/yatebts" ]; then
        # clean_src
        mkdir -p ${LOGS}
    fi

    echo -e "${BLUE}[i] downloading bladerf components${NC}"

    WRITELOG="${LOGS}/${DATETIME}.download.log"

    cd /usr/src

    git submodule update --init --recursive

    eval "git clone https://github.com/Nuand/bladeRF.git > ${WRITELOG} 2>&1"

    echo -e "${BLUE}[i] downloading yate${NC}"
    eval "git clone https://github.com/yatevoip/yate.git >> ${WRITELOG} 2>&1"

    echo -e "${BLUE}[i] downloading yatebts${NC}"
    eval "git clone https://github.com/yatevoip/yatebts.git >> ${WRITELOG} 2>&1"

    echo -e "${BLUE}[i] downloading srsGUI${NC}"
    eval "git clone https://github.com/srsLTE/srsGUI.git > ${WRITELOG} 2>&1"

    #4G
    echo -e "${BLUE}[i] downloading srsRAN 4G${NC}"
    eval "git clone https://github.com/srsran/srsRAN_4G.git > ${WRITELOG} 2>&1"

    #5G
    echo -e "${BLUE}[i] downloading srsRAN Project${NC}"
    eval "git clone https://github.com/srsran/srsRAN_Project.git > ${WRITELOG} 2>&1"

    cd /usr/src

    #fix permissions if we run in docker
    if [[ -v "${IS_DOCKER}" ]]; then
        chmod -R 777 /usr/src/yatebts
        chmod -R 777 /usr/src/yate
        chmod -R 777 /usr/src/bladeRF
        chmod -R 777 /usr/src/srsGUI
        chmod -R 777 /usr/src/srsRAN_4G
        chmod -R 777 /usr/src/srsRAN_Project
    fi

}

function backup_src {

    cd /usr/src
    echo -e "${BLUE}[i] creating backups${NC}"
    eval "mkdir ${BACKUPS} ${NOOUT}"
    backup_dir "yate"
    backup_dir "yatebts"
    backup_dir "bladerf"
    backup_dir "srsGUI"
    backup_dir "srsRAN_4G"
    backup_dir "srsRAN_Project"
}

function clean_src {

    backup_src

    cd /usr/src
    echo -e "${BLUE}[i] cleaning...${NC}"
    eval "rm -fr logs ${NOOUT}"
    eval "rm -fr bladeRF ${NOOUT}"
    eval "rm -fr yate ${NOOUT}"
    eval "rm -fr yatebts ${NOOUT}"
    eval "rm -fr srsGUI ${NOOUT}"
    eval "rm -fr srsRAN_4G ${NOOUT}"
    eval "rm -fr srsRAN_Project ${NOOUT}"
    cd /usr/src

}

function setup_web {

    WRITELOG="${LOGS}/${DATETIME}.web.log"

    echo -e "${BLUE}[i] setting up webpanel${NC}"
    eval "ln -s /usr/local/share/yate/nipc_web/ /var/www/html/nipc ${NOOUT}"

    eval "chmod -R a+rw /usr/local/etc/yate ${NOOUT}"
    
    eval "apachectl restart >> ${WRITELOG} 2>&1"

    echo -e "${BLUE}[i] please check http://localhost:8080/nipc/ for the webpanel"

}

function show_banner {

    # do you seriusly need this fugly ascii art? - yes I do.
    echo -e "\n"
    echo -e ${RED}' API`s BTS'${YELLOW}'   (   (   (         ('${NC}     
    echo -e ${YELLOW}' (        )\ ))\ ))\ )      )\ ) '${NC} 
    echo -e ${ORANGE}' ( )\    ( (()/(()/(()/(  (  (()/( '${NC} 
    echo -e ${ORANGE}' )((_)   )\ /(_))(_))(_)) )\  /(_))'${NC} 
    echo -e ${ORANGE}' ((_)_ _ ((_|_))(_))(_))_ ((_)(_))  '${NC} 
    echo -e ${RED}' | _ ) | | |_ _| |  |   \| __| _ \ '${NC} 
    echo -e ${RED}' | _ \ |_| || || |__| |) | _||   / '${NC} 
    echo -e ${RED}' |___/\___/|___|____|___/|___|_|_\ \n'${NC}
}

function usage {
                                                             
    echo -e "Usage: ${0##*/} <parameter1> <parameter2>\nPossible parameter1:"
    echo -e "\t--help\t\tdisplay this help"
    echo -e "\t--all\t\tcleans, downloads and build all components - yate, yatebts, srsGUI, srsRAN 4G, srsRAN Project and bladerf firmware (recommended for a first run)"
    echo -e "\t--download\tdownloads the required sources only"
    echo -e "\t--rebuild-yate\trebuilds yate"
    echo -e "\t--rebuild-yatebts\trebuilds yatebts"
    echo -e "\t--rebuild-srsgui\trebuilds srsGUI"
    echo -e "\t--rebuild-srs4g\trebuilds srsRAN 4G"
    echo -e "\t--rebuild-srs5g\trebuilds srsRAN Project"
    echo -e "\t--rebuild-core\trebuilds yate, yatebts, srsGUI, srsRAN 4G and srsRAN Project"
    echo -e "\t--rebuild-bladerf\trebuilds bladerf"
    echo -e "\t--web\t\tredo the web setup for yate (port 8080 webpanel)"
    echo -e "\t--clean\t\tclean all external sources (${RED}WARNING: deletes all currently present sources!${NC})" 
    echo -e "Possible parameter2:" 
    echo -e "\t--quick\t\tquick re-build, without configure or clean"
}

show_banner
eval "mkdir ${LOGS} ${NOOUT}"

if [ "${1}" == "--help" ]; then

    usage

elif [ "${1}" == "--clean" ]; then

    clean_src

elif [ "${1}" == "--download" ]; then

    download_src

elif [ "${1}" == "--web" ]; then

    setup_web


elif [ "${1}" == "--backup" ]; then

    backup_src

elif [ "${1}" == "--all" ]; then

    cd /usr/src
    download_src
    build_bladerf
    build_yatelib
    build_yatebts
    build_srsgui
    build_srsran_4g
    build_srsran_project
    cd /usr/src

    setup_web

elif [ "${1}" == "--rebuild-yate" ]; then
    
    build_yatelib

elif [ "${1}" == "--rebuild-yatebts" ]; then
    
    build_yatebts

elif [ "${1}" == "--rebuild-srsgui" ]; then
    
    build_srsgui

elif [ "${1}" == "--rebuild-srs4g" ]; then
    
    build_srsran_4g

elif [ "${1}" == "--rebuild-srs5g" ]; then
    
    build_srsran_project

elif [ "${1}" == "--rebuild-core" ]; then
    
    build_yatelib
    build_yatebts
    build_srsgui
    build_srsran_4g
    build_srsran_project

elif [ "${1}" == "--rebuild-bladerf" ]; then
    
    build_bladerf

else

    echo -e "${RED}[e] no parameter given or parameter unknown!\n${NC}"

    usage
fi

ELAPSED="$(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"
echo -e "${YELLOW}[i] runtime elapsed ${ELAPSED} ${NC}"
